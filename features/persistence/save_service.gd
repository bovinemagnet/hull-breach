class_name SaveServiceNode
extends Node

signal save_started
signal save_finished(path: String)
signal save_failed(message: String)
signal save_recovered(source: String)

const DEFAULT_SAVE_PATH := "user://campaign_save.json"

var save_path := DEFAULT_SAVE_PATH
var last_error := ""
var last_status := "not_loaded"


func configure_path(path: String) -> void:
	assert(path.begins_with("user://"), "Save files must use user://")
	save_path = path


func default_data(difficulty_id: StringName = &"standard") -> Dictionary:
	return {
		"schema_version": SaveMigration.CURRENT_SCHEMA_VERSION,
		"game_version": GameVersion.as_string(),
		"profile": {"difficulty": String(difficulty_id)},
		"campaign": {
			"completed_missions": [],
			"current_mission": "station_blackout",
			"campaign_complete": false,
			"loadout": {},
		},
		"active_mission": {},
		"metadata": {},
	}


func save(data: Dictionary) -> bool:
	save_started.emit()
	last_error = ""
	last_status = "saving"
	var prepared := data.duplicate(true)
	prepared.schema_version = SaveMigration.CURRENT_SCHEMA_VERSION
	prepared.game_version = GameVersion.as_string()
	var metadata: Dictionary = prepared.get("metadata", {}) if prepared.get("metadata", {}) is Dictionary else {}
	if not metadata.has("created_at_unix"):
		metadata.created_at_unix = int(Time.get_unix_time_from_system())
	metadata.updated_at_unix = int(Time.get_unix_time_from_system())
	prepared.metadata = metadata
	prepared.erase("integrity")
	prepared.integrity = {"algorithm": "sha256", "checksum": _integrity_checksum(prepared)}
	var errors := validation_errors(prepared)
	if not errors.is_empty():
		return _fail("Save validation failed: %s" % "; ".join(errors))
	var json_text := JSON.stringify(prepared, "  ")
	var temporary_path := "%s.tmp" % save_path
	var backup_path := "%s.bak" % save_path
	var temporary := FileAccess.open(temporary_path, FileAccess.WRITE)
	if temporary == null:
		return _fail("Unable to open temporary save file")
	temporary.store_string(json_text)
	temporary.flush()
	temporary.close()
	if _read_valid_document(temporary_path).is_empty():
		return _fail("Temporary save verification failed")
	if FileAccess.file_exists(save_path):
		if FileAccess.file_exists(backup_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(backup_path))
		var backup_error := DirAccess.rename_absolute(
			ProjectSettings.globalize_path(save_path),
			ProjectSettings.globalize_path(backup_path)
		)
		if backup_error != OK:
			return _fail("Unable to create save backup")
	var rename_error := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(temporary_path),
		ProjectSettings.globalize_path(save_path)
	)
	if rename_error != OK:
		if FileAccess.file_exists(backup_path) and not FileAccess.file_exists(save_path):
			DirAccess.copy_absolute(ProjectSettings.globalize_path(backup_path), ProjectSettings.globalize_path(save_path))
		return _fail("Unable to promote temporary save")
	last_status = "saved"
	save_finished.emit(save_path)
	return true


func load() -> Dictionary:
	last_error = ""
	last_status = "loading"
	var primary := _read_valid_document(save_path)
	if not primary.is_empty():
		last_status = "loaded_primary"
		return primary
	var backup_path := "%s.bak" % save_path
	var backup := _read_valid_document(backup_path)
	if not backup.is_empty():
		_restore_recovery_copy(backup_path)
		last_error = "Primary save invalid; recovered backup save"
		last_status = "recovered_backup"
		save_recovered.emit("backup")
		return backup
	var temporary_path := "%s.tmp" % save_path
	var temporary := _read_valid_document(temporary_path)
	if not temporary.is_empty():
		_restore_recovery_copy(temporary_path)
		last_error = "Interrupted save recovered"
		last_status = "recovered_temporary"
		save_recovered.emit("temporary")
		return temporary
	if FileAccess.file_exists(save_path) or FileAccess.file_exists(backup_path) or FileAccess.file_exists(temporary_path):
		last_error = "Save data is damaged or unsupported"
		last_status = "damaged"
	else:
		last_status = "no_save"
	return {}


func has_save() -> bool:
	return not self.load().is_empty()


func clear() -> void:
	for path in [save_path, "%s.tmp" % save_path, "%s.bak" % save_path, "%s.recovery" % save_path]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _read_valid_document(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {}
	var parsed: Variant = parser.data
	if not parsed is Dictionary:
		return {}
	var migrated: Dictionary = SaveMigration.migrate(parsed)
	if migrated.is_empty():
		return {}
	if not validation_errors(migrated).is_empty():
		return {}
	return migrated


func validation_errors(data: Dictionary) -> PackedStringArray:
	var errors := PackedStringArray()
	if int(data.get("schema_version", -1)) != SaveMigration.CURRENT_SCHEMA_VERSION:
		errors.append("schema_version is unsupported")
	var profile: Variant = data.get("profile", null)
	if not profile is Dictionary or not DifficultyService.PROFILES.has(StringName(profile.get("difficulty", ""))):
		errors.append("profile difficulty is invalid")
	var campaign: Variant = data.get("campaign", null)
	if not campaign is Dictionary:
		errors.append("campaign must be a dictionary")
	else:
		var current_id := StringName(campaign.get("current_mission", ""))
		if not CampaignCatalog.is_valid_mission(current_id):
			errors.append("current campaign mission is invalid")
		var completed: Variant = campaign.get("completed_missions", null)
		if not completed is Array:
			errors.append("completed_missions must be an array")
		else:
			var seen := {}
			for mission_value in completed:
				var mission_id := StringName(mission_value)
				if not CampaignCatalog.is_valid_mission(mission_id) or seen.has(mission_id):
					errors.append("completed_missions contains an invalid or duplicate mission")
					break
				seen[mission_id] = true
	var active: Variant = data.get("active_mission", null)
	if not active is Dictionary:
		errors.append("active_mission must be a dictionary")
	elif not active.is_empty():
		if not CampaignCatalog.is_valid_mission(StringName(active.get("id", ""))):
			errors.append("active mission ID is invalid")
		var checkpoint: Variant = active.get("checkpoint", null)
		if not checkpoint is Dictionary:
			errors.append("active mission checkpoint is invalid")
		else:
			var checkpoint_state := CheckpointState.from_dictionary(checkpoint)
			if not checkpoint_state.is_valid():
				errors.append("active mission checkpoint contains unsafe state")
	var integrity: Variant = data.get("integrity", null)
	if integrity is Dictionary and not integrity.is_empty():
		var unsigned := data.duplicate(true)
		unsigned.erase("integrity")
		if integrity.get("algorithm", "") != "sha256" or integrity.get("checksum", "") != _integrity_checksum(unsigned):
			errors.append("save integrity check failed")
	return errors


func _integrity_checksum(data: Dictionary) -> String:
	var unsigned := data.duplicate(true)
	unsigned.erase("integrity")
	return JSON.stringify(_canonicalize(unsigned)).sha256_text()


func _canonicalize(value: Variant) -> Variant:
	if value is Dictionary:
		var normalized := {}
		var keys := Array(value.keys())
		keys.sort_custom(func(a: Variant, b: Variant) -> bool: return String(a) < String(b))
		for key in keys:
			normalized[String(key)] = _canonicalize(value[key])
		return normalized
	if value is Array:
		var normalized_array: Array = []
		for entry in value:
			normalized_array.append(_canonicalize(entry))
		return normalized_array
	if value is StringName:
		return String(value)
	if value is float and not is_nan(value) and not is_inf(value) and is_equal_approx(value, roundf(value)):
		return int(roundf(value))
	return value


func _restore_recovery_copy(source_path: String) -> void:
	var temporary_path := "%s.recovery" % save_path
	if FileAccess.file_exists(temporary_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(temporary_path))
	if DirAccess.copy_absolute(ProjectSettings.globalize_path(source_path), ProjectSettings.globalize_path(temporary_path)) != OK:
		return
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	DirAccess.rename_absolute(ProjectSettings.globalize_path(temporary_path), ProjectSettings.globalize_path(save_path))


func _fail(message: String) -> bool:
	last_error = message
	last_status = "save_failed"
	push_error(message)
	save_failed.emit(message)
	return false

class_name SaveServiceNode
extends Node

signal save_started
signal save_finished(path: String)
signal save_failed(message: String)

const DEFAULT_SAVE_PATH := "user://campaign_save.json"

var save_path := DEFAULT_SAVE_PATH
var last_error := ""


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
	}


func save(data: Dictionary) -> bool:
	save_started.emit()
	last_error = ""
	var prepared := data.duplicate(true)
	prepared.schema_version = SaveMigration.CURRENT_SCHEMA_VERSION
	prepared.game_version = GameVersion.as_string()
	var json_text := JSON.stringify(prepared, "  ")
	if JSON.parse_string(json_text) == null:
		return _fail("Save serialization validation failed")
	var temporary_path := "%s.tmp" % save_path
	var backup_path := "%s.bak" % save_path
	var temporary := FileAccess.open(temporary_path, FileAccess.WRITE)
	if temporary == null:
		return _fail("Unable to open temporary save file")
	temporary.store_string(json_text)
	temporary.flush()
	temporary.close()
	if FileAccess.file_exists(save_path):
		if FileAccess.file_exists(backup_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(backup_path))
		var copy_error := DirAccess.copy_absolute(
			ProjectSettings.globalize_path(save_path),
			ProjectSettings.globalize_path(backup_path)
		)
		if copy_error != OK:
			return _fail("Unable to create save backup")
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	var rename_error := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(temporary_path),
		ProjectSettings.globalize_path(save_path)
	)
	if rename_error != OK:
		return _fail("Unable to promote temporary save")
	save_finished.emit(save_path)
	return true


func load() -> Dictionary:
	last_error = ""
	var primary := _load_path(save_path)
	if not primary.is_empty():
		return primary
	var backup := _load_path("%s.bak" % save_path)
	if not backup.is_empty():
		last_error = "Primary save invalid; recovered backup"
		return backup
	return {}


func has_save() -> bool:
	return not self.load().is_empty()


func clear() -> void:
	for path in [save_path, "%s.tmp" % save_path, "%s.bak" % save_path]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _load_path(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		last_error = "Invalid JSON save: %s" % path
		return {}
	var parsed: Variant = parser.data
	if not parsed is Dictionary:
		last_error = "Invalid JSON save: %s" % path
		return {}
	var migrated: Dictionary = SaveMigration.migrate(parsed)
	if migrated.is_empty():
		last_error = "Unsupported save schema: %s" % path
	return migrated


func _fail(message: String) -> bool:
	last_error = message
	push_error(message)
	save_failed.emit(message)
	return false

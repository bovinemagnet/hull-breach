extends SceneTree

const ROOTS := ["res://features", "res://resources", "res://levels/campaign"]
const REQUIRED_SCENES := [
	"res://ui/menus/main_menu.tscn",
	"res://ui/credits/credits.tscn",
	"res://levels/templates/production_level_template.tscn",
]
const REQUIRED_RELEASE_FILES := [
	"res://LICENSE",
	"res://PRIVACY.md",
	"res://THIRD_PARTY_ASSETS.md",
	"res://docs/development/beta-hardening.md",
]

var _errors := PackedStringArray()
var _ids: Dictionary = {}


func _initialize() -> void:
	var required_scenes := REQUIRED_SCENES.duplicate()
	required_scenes.append_array(CampaignCatalog.MISSION_SCENES.values())
	for path in required_scenes:
		if not ResourceLoader.exists(path) or ResourceLoader.load(path) == null:
			_errors.append("Missing or invalid scene: %s" % path)
	for path in REQUIRED_RELEASE_FILES:
		if not FileAccess.file_exists(path):
			_errors.append("Missing release document: %s" % path)
	_validate_campaign_catalog()
	_validate_beta_configuration()
	for root_path in ROOTS:
		_scan_directory(root_path)
	if ProjectSettings.get_setting("application/config/version", "") != GameVersion.as_string():
		_errors.append("Project and GameVersion values differ")
	if _errors.is_empty():
		print("Content validation successful: %d registered IDs" % _ids.size())
		quit(0)
	else:
		for error in _errors:
			push_error(error)
		quit(1)


func _scan_directory(path: String) -> void:
	var directory := DirAccess.open(path)
	if directory == null:
		_errors.append("Cannot open content directory: %s" % path)
		return
	directory.list_dir_begin()
	var entry := directory.get_next()
	while not entry.is_empty():
		var child_path := path.path_join(entry)
		if directory.current_is_dir():
			_scan_directory(child_path)
		elif entry.ends_with(".tres"):
			_validate_resource(child_path)
		entry = directory.get_next()
	directory.list_dir_end()


func _validate_resource(path: String) -> void:
	var resource := ResourceLoader.load(path)
	if resource == null:
		_errors.append("Broken resource reference: %s" % path)
		return
	var validation_method := resource.get("script") as Script
	if validation_method != null and resource.has_method("validation_errors"):
		for error in resource.call("validation_errors"):
			_errors.append("%s: %s" % [path, error])
	elif resource is MissionDefinition:
		for error in (resource as MissionDefinition).validation_errors():
			_errors.append("%s: %s" % [path, error])
	elif resource is CampaignMissionProfile:
		for error in (resource as CampaignMissionProfile).validation_errors():
			_errors.append("%s: %s" % [path, error])
	if resource is WeaponDefinition or resource is EnemyDefinition or resource is ItemDefinition or resource is DifficultyDefinition or resource is MissionDefinition:
		var id: StringName = resource.get("id")
		var content_type := resource.get_class()
		if resource.get_script() != null:
			content_type = (resource.get_script() as Script).get_global_name()
		var key := "%s:%s" % [content_type, id]
		if _ids.has(key):
			_errors.append("Duplicate content ID %s in %s and %s" % [key, _ids[key], path])
		else:
			_ids[key] = path


func _validate_campaign_catalog() -> void:
	if CampaignCatalog.MISSION_IDS.size() != 8:
		_errors.append("Campaign must contain exactly eight missions")
	var seen := {}
	for mission_id in CampaignCatalog.MISSION_IDS:
		if seen.has(mission_id):
			_errors.append("Duplicate campaign mission ID: %s" % mission_id)
		seen[mission_id] = true
		if CampaignCatalog.scene_for(mission_id).is_empty():
			_errors.append("Campaign mission has no scene: %s" % mission_id)


func _validate_beta_configuration() -> void:
	for autoload_name in ["SaveService", "SettingsService", "GameSession", "MusicDirector", "PlatformService"]:
		if not ProjectSettings.has_setting("autoload/%s" % autoload_name):
			_errors.append("Missing required autoload: %s" % autoload_name)
	for action in ["move_left", "move_right", "move_up", "move_down", "aim_left", "aim_right", "aim_up", "aim_down", "fire", "interact", "reload", "pause"]:
		if not InputMap.has_action(action):
			_errors.append("Missing required input action: %s" % action)
	var export_file := FileAccess.open("res://export_presets.cfg", FileAccess.READ)
	if export_file == null:
		_errors.append("Missing export presets")
		return
	var export_text := export_file.get_as_text()
	for platform_name in ["Linux", "Windows Desktop", "macOS", "Android", "iOS"]:
		if not export_text.contains('name="%s"' % platform_name):
			_errors.append("Missing export preset: %s" % platform_name)

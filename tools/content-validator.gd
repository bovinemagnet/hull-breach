extends SceneTree

const ROOTS := ["res://features", "res://resources", "res://levels/campaign"]
const REQUIRED_SCENES := [
	"res://ui/menus/main_menu.tscn",
	"res://levels/campaign/station_blackout/station_blackout.tscn",
	"res://levels/campaign/medical_wing/medical_wing.tscn",
	"res://levels/templates/production_level_template.tscn",
]

var _errors := PackedStringArray()
var _ids: Dictionary = {}


func _initialize() -> void:
	for path in REQUIRED_SCENES:
		if not ResourceLoader.exists(path) or ResourceLoader.load(path) == null:
			_errors.append("Missing or invalid scene: %s" % path)
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
	elif resource is MissionDefinition and not (resource as MissionDefinition).is_valid():
		_errors.append("Invalid mission definition: %s" % path)
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

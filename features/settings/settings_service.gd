class_name SettingsServiceNode
extends Node

signal settings_changed(settings: GameSettings)

const DEFAULT_SETTINGS_PATH := "user://settings.json"

var settings_path := DEFAULT_SETTINGS_PATH
var settings := GameSettings.new()
var last_error := ""


func _ready() -> void:
	load_settings()


func configure_path(path: String) -> void:
	assert(path.begins_with("user://"), "Settings must use user://")
	settings_path = path


func load_settings() -> GameSettings:
	last_error = ""
	var loaded := _load_path(settings_path)
	if loaded.is_empty():
		loaded = _load_path("%s.bak" % settings_path)
		if not loaded.is_empty():
			last_error = "Settings recovered from backup"
	settings = GameSettings.from_dictionary(loaded) if not loaded.is_empty() else GameSettings.new()
	apply_settings()
	return settings


func save_settings() -> bool:
	last_error = ""
	var temporary_path := "%s.tmp" % settings_path
	var backup_path := "%s.bak" % settings_path
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		last_error = "Unable to write temporary settings"
		return false
	file.store_string(JSON.stringify(settings.to_dictionary(), "  "))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		last_error = "Unable to write settings; storage may be full or unavailable"
		return false
	if _load_path(temporary_path).is_empty():
		last_error = "Temporary settings verification failed"
		return false
	if FileAccess.file_exists(settings_path):
		if FileAccess.file_exists(backup_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(backup_path))
		if DirAccess.rename_absolute(ProjectSettings.globalize_path(settings_path), ProjectSettings.globalize_path(backup_path)) != OK:
			last_error = "Unable to create settings backup"
			return false
	if DirAccess.rename_absolute(ProjectSettings.globalize_path(temporary_path), ProjectSettings.globalize_path(settings_path)) != OK:
		if FileAccess.file_exists(backup_path):
			DirAccess.copy_absolute(ProjectSettings.globalize_path(backup_path), ProjectSettings.globalize_path(settings_path))
		last_error = "Unable to promote settings"
		return false
	apply_settings()
	settings_changed.emit(settings)
	return true


func apply_settings() -> void:
	_set_bus_volume(&"Master", settings.master_volume)
	_set_bus_volume(&"Music", settings.music_volume)
	_set_bus_volume(&"Ambience", settings.ambience_volume)
	_set_bus_volume(&"SFX", settings.sfx_volume)
	_set_bus_volume(&"UI", settings.ui_volume)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if settings.vsync_enabled else DisplayServer.VSYNC_DISABLED)
	if not OS.has_feature("headless"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if settings.fullscreen_enabled else DisplayServer.WINDOW_MODE_WINDOWED)
	Engine.max_fps = settings.target_fps
	if get_tree() != null and get_tree().root != null:
		get_tree().root.content_scale_factor = settings.ui_scale
	for action in [&"move_left", &"move_right", &"move_up", &"move_down", &"aim_left", &"aim_right", &"aim_up", &"aim_down"]:
		if InputMap.has_action(action):
			InputMap.action_set_deadzone(action, settings.controller_deadzone)


func clear() -> void:
	for path in [settings_path, "%s.tmp" % settings_path, "%s.bak" % settings_path]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	settings = GameSettings.new()
	apply_settings()


func reset_to_defaults() -> bool:
	settings = GameSettings.new()
	return save_settings()


func _load_path(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK or not parser.data is Dictionary:
		return {}
	return parser.data


func _set_bus_volume(bus_name: StringName, linear: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index >= 0:
		AudioServer.set_bus_volume_db(index, linear_to_db(maxf(linear, 0.0001)))

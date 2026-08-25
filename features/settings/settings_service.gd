class_name SettingsServiceNode
extends Node

signal settings_changed(settings: GameSettings)

const DEFAULT_SETTINGS_PATH := "user://settings.json"

var settings_path := DEFAULT_SETTINGS_PATH
var settings := GameSettings.new()


func _ready() -> void:
	load_settings()


func configure_path(path: String) -> void:
	assert(path.begins_with("user://"), "Settings must use user://")
	settings_path = path


func load_settings() -> GameSettings:
	if FileAccess.file_exists(settings_path):
		var file := FileAccess.open(settings_path, FileAccess.READ)
		if file != null:
			var parser := JSON.new()
			if parser.parse(file.get_as_text()) == OK and parser.data is Dictionary:
				settings = GameSettings.from_dictionary(parser.data)
	apply_settings()
	return settings


func save_settings() -> bool:
	var file := FileAccess.open(settings_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(settings.to_dictionary(), "  "))
	file.close()
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
	Engine.max_fps = settings.target_fps


func clear() -> void:
	if FileAccess.file_exists(settings_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(settings_path))
	settings = GameSettings.new()


func _set_bus_volume(bus_name: StringName, linear: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index >= 0:
		AudioServer.set_bus_volume_db(index, linear_to_db(maxf(linear, 0.0001)))

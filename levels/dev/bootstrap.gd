extends Node

const GAME_NAME := "Hull Breach"
const GAME_VERSION_SCRIPT := preload("res://core/utilities/game_version.gd")


func _ready() -> void:
	print("%s %s" % [GAME_NAME, GAME_VERSION_SCRIPT.as_string()])
	print("Godot: %s" % Engine.get_version_info().string)

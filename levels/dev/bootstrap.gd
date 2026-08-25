extends Node

const GAME_NAME := "Hull Breach"
const GAME_VERSION_SCRIPT := preload("res://core/utilities/game_version.gd")
const COMBAT_SANDBOX := "res://levels/dev/combat_sandbox/combat_sandbox.tscn"

@onready var launch_button: Button = %LaunchButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	print("%s %s" % [GAME_NAME, GAME_VERSION_SCRIPT.as_string()])
	print("Godot: %s" % Engine.get_version_info().string)
	launch_button.pressed.connect(_launch_combat_sandbox)
	quit_button.pressed.connect(get_tree().quit)
	launch_button.grab_focus()


func _launch_combat_sandbox() -> void:
	get_tree().change_scene_to_file(COMBAT_SANDBOX)

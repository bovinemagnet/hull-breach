class_name CreditsScreen
extends Control


func _ready() -> void:
	%VersionLabel.text = GameVersion.support_string().to_upper()
	%LegalButton.pressed.connect(func() -> void: _transition("res://ui/legal/legal.tscn"))
	%MainMenuButton.pressed.connect(_return_to_menu)
	%MainMenuButton.grab_focus()


func _return_to_menu() -> void:
	_transition("res://ui/menus/main_menu.tscn")


func _transition(scene_path: String) -> void:
	var session := get_node_or_null("/root/GameSession") as GameSessionState
	if session != null:
		session.transition_to_scene(scene_path)
	else:
		get_tree().change_scene_to_file(scene_path)

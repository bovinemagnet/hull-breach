class_name CreditsScreen
extends Control


func _ready() -> void:
	%MainMenuButton.pressed.connect(_return_to_menu)
	%MainMenuButton.grab_focus()


func _return_to_menu() -> void:
	var session := get_node_or_null("/root/GameSession") as GameSessionState
	if session != null:
		session.transition_to_scene("res://ui/menus/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")

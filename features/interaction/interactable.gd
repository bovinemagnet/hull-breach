class_name Interactable
extends Area2D

signal interaction_completed(interactable: Interactable, player: Player)
signal feedback_requested(message: String)

@export var interaction_label: String = "Interact"


func _ready() -> void:
	collision_layer = 64
	collision_mask = 0
	monitorable = true
	monitoring = false


func can_interact(_player: Player) -> bool:
	return true


func get_interaction_text(_player: Player) -> String:
	return interaction_label


func interact(player: Player) -> bool:
	if not can_interact(player):
		return false
	interaction_completed.emit(self, player)
	return true

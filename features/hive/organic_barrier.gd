class_name OrganicBarrier
extends StaticBody2D

signal opened

@export var barrier_id: StringName = &"organic_barrier"
@export var required_node_ids := PackedStringArray()
var destroyed_node_ids := PackedStringArray()
var is_open := false


func notify_node_destroyed(node_id: StringName) -> void:
	if not destroyed_node_ids.has(String(node_id)):
		destroyed_node_ids.append(String(node_id))
	if not is_open and _requirements_met():
		open()


func open() -> void:
	if is_open:
		return
	is_open = true
	collision_layer = 0
	collision_mask = 0
	visible = false
	opened.emit()


func restore_state(opened_state: bool, destroyed: PackedStringArray = PackedStringArray()) -> void:
	destroyed_node_ids = destroyed.duplicate()
	if opened_state:
		open()


func _requirements_met() -> bool:
	for required_id in required_node_ids:
		if not destroyed_node_ids.has(required_id):
			return false
	return true

class_name ReachTrigger
extends Area2D

signal reached(event_id: StringName)

@export var event_id: StringName
@export var one_shot := true
var triggered := false


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	monitoring = true
	monitorable = false
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if (triggered and one_shot) or not body is Player:
		return
	triggered = true
	reached.emit(event_id)

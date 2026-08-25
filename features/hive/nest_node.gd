class_name NestNode
extends Node2D

signal destroyed(node_id: StringName)

@export var node_id: StringName = &"nest_node"
@export_range(1.0, 1000.0, 1.0) var maximum_health := 90.0
var current_health := 90.0
var is_destroyed := false


func _ready() -> void:
	current_health = maximum_health
	queue_redraw()


func receive_damage(info: DamageInfo) -> void:
	if is_destroyed:
		return
	current_health = maxf(0.0, current_health - maxf(0.0, info.amount))
	if is_zero_approx(current_health):
		is_destroyed = true
		destroyed.emit(node_id)
		visible = false
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 24.0, Color(0.23, 0.04, 0.16))
	draw_circle(Vector2.ZERO, 17.0, Color(0.75, 0.16, 0.46))
	draw_arc(Vector2.ZERO, 29.0, 0.0, TAU, 18, Color(0.5, 0.9, 0.4), 3.0)

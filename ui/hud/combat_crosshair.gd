class_name CombatCrosshair
extends Node2D

var target: Player


func _process(_delta: float) -> void:
	if not is_instance_valid(target):
		hide()
		return
	show()
	if target.is_using_controller_aim():
		global_position = target.global_position + target.aim_direction * 64.0
	else:
		global_position = target.get_global_mouse_position()
	queue_redraw()


func _draw() -> void:
	var colour := Color(0.55, 1.0, 0.9, 0.9)
	draw_arc(Vector2.ZERO, 7.0, 0.0, TAU, 16, Color(0.02, 0.08, 0.09, 0.9), 4.0)
	draw_arc(Vector2.ZERO, 7.0, 0.0, TAU, 16, colour, 1.5)
	draw_line(Vector2(-11.0, 0.0), Vector2(-5.0, 0.0), colour, 1.5)
	draw_line(Vector2(5.0, 0.0), Vector2(11.0, 0.0), colour, 1.5)
	draw_line(Vector2(0.0, -11.0), Vector2(0.0, -5.0), colour, 1.5)
	draw_line(Vector2(0.0, 5.0), Vector2(0.0, 11.0), colour, 1.5)

class_name ImpactEffect
extends Node2D

var _colour := Color(0.25, 0.95, 1.0)
var _lifetime := 0.16
var _remaining := 0.16


func configure(colour: Color, lifetime: float = 0.16) -> void:
	_colour = colour
	_lifetime = maxf(lifetime, 0.01)
	_remaining = _lifetime


func _process(delta: float) -> void:
	_remaining -= delta
	if _remaining <= 0.0:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var progress := 1.0 - (_remaining / _lifetime)
	var colour := Color(_colour, 1.0 - progress)
	draw_circle(Vector2.ZERO, lerpf(2.0, 9.0, progress), colour, false, 2.0)
	for index in 4:
		var direction := Vector2.RIGHT.rotated((TAU / 4.0) * index)
		draw_line(direction * 3.0, direction * lerpf(6.0, 14.0, progress), colour, 2.0)

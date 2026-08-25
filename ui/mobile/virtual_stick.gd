class_name VirtualStick
extends Control

signal vector_changed(value: Vector2)

@export var radius := 54.0
var value := Vector2.ZERO
var _touch_index := -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index < 0:
			_touch_index = event.index
			_update_value(event.position)
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_set_value(Vector2.ZERO)
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_value(event.position)
	elif event is InputEventMouseButton:
		if event.pressed:
			_touch_index = -2
			_update_value(event.position)
		else:
			_touch_index = -1
			_set_value(Vector2.ZERO)
	elif event is InputEventMouseMotion and _touch_index == -2:
		_update_value(event.position)


func _update_value(local_position: Vector2) -> void:
	_set_value((local_position - size * 0.5) / radius)


func _set_value(next_value: Vector2) -> void:
	value = next_value.limit_length(1.0)
	vector_changed.emit(value)
	queue_redraw()


func release() -> void:
	_touch_index = -1
	_set_value(Vector2.ZERO)


func _draw() -> void:
	var centre := size * 0.5
	draw_circle(centre, radius, Color(0.1, 0.22, 0.24, 0.42))
	draw_arc(centre, radius, 0.0, TAU, 40, Color(0.35, 0.9, 0.8, 0.55), 2.0)
	draw_circle(centre + value * radius * 0.58, radius * 0.36, Color(0.35, 0.9, 0.8, 0.7))

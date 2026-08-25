class_name NoiseSystem
extends Node2D

signal noise_emitted(event: NoiseEvent)

@export var debug_visualization: bool = false

var _listeners: Array[WeakRef] = []
var _debug_events: Array[Dictionary] = []


func _ready() -> void:
	if not OS.is_debug_build():
		debug_visualization = false


func register_listener(listener: NoiseListener) -> void:
	for listener_ref in _listeners:
		if listener_ref.get_ref() == listener:
			return
	_listeners.append(weakref(listener))


func unregister_listener(listener: NoiseListener) -> void:
	_listeners = _listeners.filter(func(listener_ref: WeakRef) -> bool: return listener_ref.get_ref() != listener)


func emit_noise(event: NoiseEvent) -> int:
	var heard_count := 0
	var active_listeners: Array[WeakRef] = []
	for listener_ref in _listeners:
		var listener := listener_ref.get_ref() as NoiseListener
		if not is_instance_valid(listener):
			continue
		active_listeners.append(listener_ref)
		var owner := listener.get_parent() as Node2D
		if owner != null and listener.evaluate(event, owner.global_position):
			heard_count += 1
	_listeners = active_listeners
	noise_emitted.emit(event)
	if debug_visualization:
		_debug_events.append({"position": event.position, "radius": event.radius, "remaining": 0.8})
		queue_redraw()
	return heard_count


func _process(delta: float) -> void:
	if _debug_events.is_empty():
		return
	for event_data in _debug_events:
		event_data.remaining = float(event_data.remaining) - delta
	_debug_events = _debug_events.filter(func(event_data: Dictionary) -> bool: return float(event_data.remaining) > 0.0)
	queue_redraw()


func _draw() -> void:
	for event_data in _debug_events:
		var remaining := float(event_data.remaining)
		var colour := Color(1.0, 0.55, 0.15, minf(0.8, remaining))
		draw_arc(to_local(event_data.position), float(event_data.radius), 0.0, TAU, 64, colour, 2.0)

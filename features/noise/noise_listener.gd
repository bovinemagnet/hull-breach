class_name NoiseListener
extends Node

signal noise_heard(event: NoiseEvent)

@export_range(0.0, 5.0, 0.05) var hearing_sensitivity: float = 1.0


func evaluate(event: NoiseEvent, listener_position: Vector2) -> bool:
	if event.radius <= 0.0 or event.intensity <= 0.0:
		return false
	if listener_position.distance_to(event.position) > event.radius * hearing_sensitivity:
		return false
	noise_heard.emit(event)
	return true

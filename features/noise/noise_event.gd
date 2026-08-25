class_name NoiseEvent
extends RefCounted

var position: Vector2
var radius: float
var intensity: float
var category: StringName
var source: Node


func _init(
	p_position: Vector2,
	p_radius: float,
	p_category: StringName,
	p_source: Node = null,
	p_intensity: float = 1.0
) -> void:
	position = p_position
	radius = maxf(0.0, p_radius)
	intensity = maxf(0.0, p_intensity)
	category = p_category
	source = p_source

class_name LightZone
extends Area2D

@export_range(0.0, 1.0, 0.05) var illumination_level := 1.0
@export var powered := true


func _ready() -> void:
	add_to_group(&"light_zones")


func illumination_at(point: Vector2) -> float:
	if not powered:
		return 0.0
	for child in get_children():
		if child is CollisionShape2D and (child as CollisionShape2D).shape != null:
			var local_point := (child as CollisionShape2D).to_local(point)
			var shape := (child as CollisionShape2D).shape
			if shape is RectangleShape2D:
				var half_size := (shape as RectangleShape2D).size * 0.5
				if absf(local_point.x) <= half_size.x and absf(local_point.y) <= half_size.y:
					return illumination_level
			elif shape is CircleShape2D and local_point.length() <= (shape as CircleShape2D).radius:
				return illumination_level
	return 0.0

class_name Stalker
extends Drone

@export_range(0.0, 1.0, 0.05) var bright_threshold := 0.65
var current_illumination := 0.0


func _physics_process(delta: float) -> void:
	current_illumination = _illumination_at(global_position)
	super._physics_process(delta)


func _chase_destination(to_target: Vector2, distance: float) -> Vector2:
	if current_illumination >= bright_threshold and distance > definition.attack_range * 1.3:
		return global_position - to_target.normalized() * 120.0
	return target.global_position


func is_light_reluctant() -> bool:
	return current_illumination >= bright_threshold


func _illumination_at(point: Vector2) -> float:
	if not is_inside_tree():
		return 0.0
	var illumination := 0.0
	for node in get_tree().get_nodes_in_group(&"light_zones"):
		if node is LightZone:
			illumination = maxf(illumination, (node as LightZone).illumination_at(point))
	return illumination

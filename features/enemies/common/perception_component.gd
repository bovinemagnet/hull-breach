class_name EnemyPerceptionComponent
extends NoiseListener

var target: Node2D
var owner_body: CollisionObject2D
var vision_range := 360.0


func configure(body: CollisionObject2D, p_target: Node2D, range: float, sensitivity: float) -> void:
	owner_body = body
	target = p_target
	vision_range = range
	hearing_sensitivity = sensitivity


func can_see_target() -> bool:
	if not is_instance_valid(owner_body) or not is_instance_valid(target):
		return false
	if owner_body.global_position.distance_to(target.global_position) > vision_range:
		return false
	var query := PhysicsRayQueryParameters2D.create(owner_body.global_position, target.global_position, 1)
	query.exclude = [owner_body.get_rid()]
	return owner_body.get_world_2d().direct_space_state.intersect_ray(query).is_empty()

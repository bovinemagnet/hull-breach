class_name Hunter
extends Drone

var _strafe_sign := 1.0


func _ready() -> void:
	_strafe_sign = -1.0 if get_instance_id() % 2 == 0 else 1.0
	super._ready()


func _chase_destination(to_target: Vector2, distance: float) -> Vector2:
	if distance < definition.attack_range * 1.8:
		return target.global_position + to_target.normalized().orthogonal() * 72.0 * _strafe_sign
	return target.global_position

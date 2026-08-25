class_name MeleeAttack
extends Node


func apply(attacker: Node2D, target: Node2D, damage: float, attack_range: float) -> bool:
	if not is_instance_valid(target) or attacker.global_position.distance_to(target.global_position) > attack_range:
		return false
	if not target.has_method("receive_damage"):
		return false
	var direction := attacker.global_position.direction_to(target.global_position)
	target.call("receive_damage", DamageInfo.new(damage, attacker, target.global_position, direction))
	return true

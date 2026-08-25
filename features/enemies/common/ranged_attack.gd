class_name RangedAttack
extends Node

@export var projectile_scene: PackedScene


func fire(attacker: Node2D, target: Node2D, damage: float, speed: float, lifetime: float) -> bool:
	if projectile_scene == null or not is_instance_valid(target) or not attacker.is_inside_tree():
		return false
	var projectile := projectile_scene.instantiate() as Projectile
	if projectile == null:
		return false
	attacker.get_tree().current_scene.add_child(projectile)
	var direction := attacker.global_position.direction_to(target.global_position)
	projectile.global_position = attacker.global_position + direction * 19.0
	projectile.collision_layer = 16
	projectile.collision_mask = 3
	projectile.modulate = Color(0.55, 1.0, 0.28)
	projectile.configure(direction, damage, speed, lifetime, attacker)
	return true

class_name Spitter
extends Drone

@onready var ranged_attack: RangedAttack = $RangedAttack


func _apply_attack_if_in_range() -> void:
	if not is_instance_valid(target):
		return
	if global_position.distance_to(target.global_position) > definition.attack_range + 7.0:
		return
	if ranged_attack.fire(self, target, definition.attack_damage * _damage_multiplier, definition.projectile_speed, definition.projectile_lifetime):
		if _attack_audio != null:
			_attack_audio.play()

class_name Brute
extends Drone

@export_range(0.0, 1.0, 0.05) var frontal_damage_multiplier := 0.3


func receive_damage(info: DamageInfo) -> void:
	var forward := Vector2.RIGHT.rotated(rotation)
	var incoming_from_front := not info.direction.is_zero_approx() and info.direction.dot(forward) < -0.2
	if incoming_from_front:
		var reduced := DamageInfo.new(info.amount * frontal_damage_multiplier, info.source, info.hit_position, info.direction)
		super.receive_damage(reduced)
	else:
		super.receive_damage(info)

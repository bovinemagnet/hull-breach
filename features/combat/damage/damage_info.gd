class_name DamageInfo
extends RefCounted

var amount: float
var source: Node
var hit_position: Vector2
var direction: Vector2


func _init(
	p_amount: float,
	p_source: Node = null,
	p_hit_position: Vector2 = Vector2.ZERO,
	p_direction: Vector2 = Vector2.ZERO
) -> void:
	amount = p_amount
	source = p_source
	hit_position = p_hit_position
	direction = p_direction.normalized() if not p_direction.is_zero_approx() else Vector2.ZERO

class_name AttackTimer
extends RefCounted

var cooldown: float
var remaining: float = 0.0


func _init(p_cooldown: float = 0.8) -> void:
	cooldown = maxf(0.0, p_cooldown)


func advance(delta: float) -> void:
	remaining = maxf(0.0, remaining - maxf(delta, 0.0))


func is_ready() -> bool:
	return is_zero_approx(remaining)


func try_consume() -> bool:
	if not is_ready():
		return false
	remaining = cooldown
	return true

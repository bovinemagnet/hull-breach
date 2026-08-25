class_name HealthComponent
extends Node

signal health_changed(current: float, maximum: float)
signal damage_received(amount: float)
signal healed(amount: float)
signal died

@export_range(0.1, 10000.0, 0.1) var maximum_health: float = 100.0

var current_health: float = 0.0
var is_dead: bool = false


func _ready() -> void:
	reset()


func apply_damage(damage: DamageInfo) -> void:
	if is_dead or damage.amount <= 0.0:
		return
	var previous_health := current_health
	current_health = maxf(0.0, current_health - damage.amount)
	var applied_amount := previous_health - current_health
	damage_received.emit(applied_amount)
	health_changed.emit(current_health, maximum_health)
	if is_zero_approx(current_health):
		is_dead = true
		died.emit()


func heal(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	var previous_health := current_health
	current_health = minf(maximum_health, current_health + amount)
	var applied_amount := current_health - previous_health
	if applied_amount > 0.0:
		healed.emit(applied_amount)
		health_changed.emit(current_health, maximum_health)


func reset() -> void:
	maximum_health = maxf(maximum_health, 0.1)
	current_health = maximum_health
	is_dead = false
	health_changed.emit(current_health, maximum_health)


func health_ratio() -> float:
	return current_health / maximum_health

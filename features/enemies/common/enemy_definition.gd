class_name EnemyDefinition
extends Resource

@export var id: StringName = &"enemy"
@export var display_name: String = "Enemy"
@export_range(0.0, 10000.0, 0.1) var maximum_health: float = 50.0
@export_range(0.0, 1000.0, 1.0) var move_speed: float = 90.0
@export_range(0.0, 1000.0, 0.1) var attack_damage: float = 10.0
@export_range(0.0, 1000.0, 1.0) var attack_range: float = 28.0
@export_range(0.0, 30.0, 0.05) var attack_cooldown: float = 0.8
@export_range(0.0, 5000.0, 1.0) var detection_range: float = 500.0
@export_range(0.0, 5.0, 0.01) var attack_windup: float = 0.18
@export_range(0.0, 5000.0, 1.0) var vision_range: float = 360.0
@export_range(0.0, 30.0, 0.1) var search_duration: float = 3.0
@export_range(0.0, 5.0, 0.05) var hearing_sensitivity: float = 1.0


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if maximum_health <= 0.0:
		errors.append("maximum_health must be greater than zero")
	if move_speed <= 0.0:
		errors.append("move_speed must be greater than zero")
	if attack_damage <= 0.0:
		errors.append("attack_damage must be greater than zero")
	if attack_range <= 0.0:
		errors.append("attack_range must be greater than zero")
	if attack_cooldown < 0.0:
		errors.append("attack_cooldown cannot be negative")
	if detection_range <= 0.0:
		errors.append("detection_range must be greater than zero")
	return errors


func is_valid() -> bool:
	return validation_errors().is_empty()

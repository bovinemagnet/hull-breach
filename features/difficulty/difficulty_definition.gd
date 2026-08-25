class_name DifficultyDefinition
extends Resource

@export var id: StringName = &"standard"
@export var display_name := "Standard"
@export_multiline var description := "The intended Hull Breach experience."
@export_range(0.1, 3.0, 0.05) var enemy_health_multiplier := 1.0
@export_range(0.1, 3.0, 0.05) var enemy_damage_multiplier := 1.0
@export_range(0.1, 3.0, 0.05) var enemy_speed_multiplier := 1.0
@export_range(0.1, 3.0, 0.05) var hearing_multiplier := 1.0
@export_range(0.1, 3.0, 0.05) var ammo_quantity_multiplier := 1.0
@export_range(0.1, 3.0, 0.05) var health_pickup_multiplier := 1.0
@export_range(0.0, 1.0, 0.05) var aim_assist_strength := 0.0


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty():
		errors.append("id must not be empty")
	for multiplier in [enemy_health_multiplier, enemy_damage_multiplier, enemy_speed_multiplier, hearing_multiplier, ammo_quantity_multiplier, health_pickup_multiplier]:
		if multiplier <= 0.0:
			errors.append("multipliers must be greater than zero")
			break
	return errors

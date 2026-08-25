class_name HazardDefinition
extends Resource

@export var id: StringName = &"hazard"
@export var display_name := "Hazard"
@export_range(0.0, 1000.0, 0.5) var damage := 10.0
@export_range(0.05, 10.0, 0.05) var damage_interval := 0.5
@export var starts_enabled := true
@export var power_circuit: StringName
@export var enabled_when_powered := true
@export var affected_group: StringName = &"player"


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty():
		errors.append("id must not be empty")
	if damage <= 0.0:
		errors.append("damage must be greater than zero")
	if damage_interval <= 0.0:
		errors.append("damage_interval must be greater than zero")
	return errors

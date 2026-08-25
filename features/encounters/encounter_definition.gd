class_name EncounterDefinition
extends Resource

@export var id: StringName
@export var waves: Array[WaveDefinition] = []
@export var auto_start := false
@export_range(1, 100, 1) var maximum_active_enemies := 20
@export_range(1, 20, 1) var maximum_spawn_per_frame := 2


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty():
		errors.append("id must not be empty")
	if waves.is_empty():
		errors.append("encounter requires at least one wave")
	for wave in waves:
		if wave == null:
			errors.append("encounter contains missing wave")
		else:
			errors.append_array(wave.validation_errors())
	return errors

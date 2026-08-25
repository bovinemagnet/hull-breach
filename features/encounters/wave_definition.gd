class_name WaveDefinition
extends Resource

@export_range(0.0, 30.0, 0.1) var delay := 0.0
@export var spawn_point_ids: PackedStringArray
@export var enemy_scenes: Array[PackedScene] = []
@export var counts: PackedInt32Array
@export_range(0.0, 10.0, 0.05) var spawn_interval := 0.25
@export_range(0, 100, 1) var minimum_alive_before_next := 0


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if spawn_point_ids.size() != enemy_scenes.size() or counts.size() != enemy_scenes.size():
		errors.append("wave entry arrays must have equal lengths")
	for index in enemy_scenes.size():
		if spawn_point_ids[index].is_empty() or enemy_scenes[index] == null or counts[index] <= 0:
			errors.append("wave entries require spawn point, scene, and positive count")
	return errors

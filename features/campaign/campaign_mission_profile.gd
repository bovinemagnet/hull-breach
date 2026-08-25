class_name CampaignMissionProfile
extends Resource

@export var mission_id: StringName
@export_range(1, 8, 1) var campaign_index := 1
@export var mission_definition: MissionDefinition
@export var theme_name := "Facility"
@export var ambience_cue := "emergency systems"
@export_multiline var briefing := ""
@export var floor_colour := Color(0.04, 0.06, 0.07)
@export var accent_colour := Color(0.2, 0.8, 0.75)
@export var objective_positions := PackedVector2Array()
@export var checkpoint_objectives := PackedInt32Array()
@export var enemy_scene_paths := PackedStringArray()
@export var enemies_per_beat := PackedInt32Array()
@export var weapon_unlocks := PackedStringArray()
@export var timed_objective_index := -1
@export_range(0.0, 600.0, 1.0) var timed_objective_seconds := 0.0


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if mission_id.is_empty():
		errors.append("mission_id must not be empty")
	if mission_definition == null or not mission_definition.is_valid():
		errors.append("mission_definition must be valid")
	elif mission_definition.id != mission_id:
		errors.append("mission_id must match mission_definition.id")
	elif objective_positions.size() != mission_definition.objective_ids.size():
		errors.append("objective_positions must match objective count")
	elif mission_definition.objective_kinds[-1] != MissionDefinition.ObjectiveKind.EXTRACTION:
		errors.append("final objective must be extraction")
	if enemy_scene_paths.size() != enemies_per_beat.size():
		errors.append("enemy_scene_paths must match enemies_per_beat")
	if timed_objective_index >= 0:
		if timed_objective_index >= objective_positions.size() or timed_objective_seconds <= 0.0:
			errors.append("timed objective configuration is invalid")
	var seen := {}
	for checkpoint_index in checkpoint_objectives:
		if checkpoint_index < 0 or checkpoint_index >= objective_positions.size():
			errors.append("checkpoint objective index is out of range")
		if seen.has(checkpoint_index):
			errors.append("checkpoint objective indices must be unique")
		seen[checkpoint_index] = true
	return errors


func is_valid() -> bool:
	return validation_errors().is_empty()

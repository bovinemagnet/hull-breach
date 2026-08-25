class_name MissionDefinition
extends Resource

enum ObjectiveKind { REACH, INTERACT, COLLECT, EXTRACTION, TIMED }

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var objective_ids: PackedStringArray
@export var objective_titles: PackedStringArray
@export var objective_details: PackedStringArray
@export var objective_events: PackedStringArray
@export var objective_kinds: PackedInt32Array
@export var objective_time_limits: PackedFloat32Array


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	var count := objective_ids.size()
	if id.is_empty() or display_name.is_empty():
		errors.append("id and display_name must not be empty")
	if count <= 0:
		errors.append("at least one objective is required")
	if objective_titles.size() != count or objective_details.size() != count or objective_events.size() != count or objective_kinds.size() != count:
		errors.append("objective arrays must have matching lengths")
	if not objective_time_limits.is_empty() and objective_time_limits.size() != count:
		errors.append("objective_time_limits must be empty or match objective count")
	if not errors.is_empty():
		return errors
	var seen_ids := {}
	var seen_events := {}
	for index in count:
		if seen_ids.has(objective_ids[index]) or objective_ids[index].is_empty():
			errors.append("objective IDs must be non-empty and unique")
		seen_ids[objective_ids[index]] = true
		if seen_events.has(objective_events[index]) or objective_events[index].is_empty():
			errors.append("objective events must be non-empty and unique")
		seen_events[objective_events[index]] = true
		if objective_kinds[index] < ObjectiveKind.REACH or objective_kinds[index] > ObjectiveKind.TIMED:
			errors.append("objective kind is invalid")
		if objective_kinds[index] == ObjectiveKind.TIMED and (objective_time_limits.is_empty() or objective_time_limits[index] <= 0.0):
			errors.append("timed objectives require a positive time limit")
	return errors


func is_valid() -> bool:
	return validation_errors().is_empty()

class_name MissionDefinition
extends Resource

enum ObjectiveKind { REACH, INTERACT, COLLECT, EXTRACTION }

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var objective_ids: PackedStringArray
@export var objective_titles: PackedStringArray
@export var objective_details: PackedStringArray
@export var objective_events: PackedStringArray
@export var objective_kinds: PackedInt32Array


func is_valid() -> bool:
	var count := objective_ids.size()
	return (
		count > 0
		and objective_titles.size() == count
		and objective_details.size() == count
		and objective_events.size() == count
		and objective_kinds.size() == count
	)

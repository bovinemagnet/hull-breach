class_name MissionController
extends Node

signal active_objective_changed(title: String, details: String, current: int, total: int)
signal objective_completed(objective_id: StringName, title: String)
signal mission_completed

@export var definition: MissionDefinition

var objectives: Array[MissionObjective] = []
var active_index := -1
var is_complete := false


func _ready() -> void:
	if definition != null:
		configure(definition)


func configure(p_definition: MissionDefinition) -> void:
	definition = p_definition
	assert(definition != null and definition.is_valid(), "MissionDefinition is invalid")
	objectives.clear()
	for index in definition.objective_ids.size():
		var objective := _create_objective(definition.objective_kinds[index])
		objective.id = StringName(definition.objective_ids[index])
		objective.title = definition.objective_titles[index]
		objective.details = definition.objective_details[index]
		objective.event_id = StringName(definition.objective_events[index])
		objectives.append(objective)
	active_index = 0
	is_complete = false
	objectives[active_index].activate()
	_emit_active_objective()


func notify_event(event_id: StringName) -> bool:
	var objective := get_active_objective()
	if objective == null or objective.event_id != event_id:
		return false
	if not objective.complete():
		return false
	objective_completed.emit(objective.id, objective.title)
	active_index += 1
	if active_index >= objectives.size():
		is_complete = true
		mission_completed.emit()
		return true
	objectives[active_index].activate()
	_emit_active_objective()
	return true


func skip_current() -> void:
	var objective := get_active_objective()
	if objective != null:
		notify_event(objective.event_id)


func get_active_objective() -> MissionObjective:
	if active_index < 0 or active_index >= objectives.size():
		return null
	return objectives[active_index]


func snapshot() -> Dictionary:
	var completed_ids := PackedStringArray()
	for objective in objectives:
		if objective.state == MissionObjective.State.COMPLETED:
			completed_ids.append(String(objective.id))
	return {
		"active_index": active_index,
		"completed_ids": completed_ids,
		"is_complete": is_complete,
	}


func restore(data: Dictionary) -> void:
	var completed_ids: PackedStringArray = data.get("completed_ids", PackedStringArray())
	active_index = int(data.get("active_index", 0))
	is_complete = bool(data.get("is_complete", false))
	for index in objectives.size():
		var objective := objectives[index]
		if completed_ids.has(String(objective.id)):
			objective.state = MissionObjective.State.COMPLETED
		elif index == active_index and not is_complete:
			objective.state = MissionObjective.State.ACTIVE
		else:
			objective.state = MissionObjective.State.INACTIVE
	if not is_complete:
		_emit_active_objective()


func _emit_active_objective() -> void:
	var objective := get_active_objective()
	if objective != null:
		active_objective_changed.emit(objective.title, objective.details, active_index + 1, objectives.size())


func _create_objective(kind: int) -> MissionObjective:
	match kind:
		MissionDefinition.ObjectiveKind.INTERACT:
			return InteractObjective.new()
		MissionDefinition.ObjectiveKind.COLLECT:
			return CollectObjective.new()
		MissionDefinition.ObjectiveKind.EXTRACTION:
			return ExtractionObjective.new()
		_:
			return ReachAreaObjective.new()

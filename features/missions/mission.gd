class_name MissionController
extends Node

signal active_objective_changed(title: String, details: String, current: int, total: int)
signal objective_completed(objective_id: StringName, title: String)
signal objective_timer_changed(objective_id: StringName, remaining: float)
signal timed_objective_failed(objective_id: StringName)
signal mission_completed

@export var definition: MissionDefinition

var objectives: Array[MissionObjective] = []
var active_index := -1
var is_complete := false
var satisfied_events: Dictionary = {}


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
		if objective is TimedObjective and not definition.objective_time_limits.is_empty():
			(objective as TimedObjective).configure_timer(definition.objective_time_limits[index])
		objectives.append(objective)
	active_index = 0
	is_complete = false
	satisfied_events.clear()
	objectives[active_index].activate()
	_emit_active_objective()


func _process(delta: float) -> void:
	var objective := get_active_objective()
	if not objective is TimedObjective:
		return
	var timed := objective as TimedObjective
	if timed.advance(delta):
		var failed_id := timed.id
		timed.fail()
		timed_objective_failed.emit(failed_id)
		_advance_after_failure()
	else:
		objective_timer_changed.emit(timed.id, timed.remaining)


func notify_event(event_id: StringName) -> bool:
	if event_id.is_empty() or is_complete:
		return false
	satisfied_events[event_id] = true
	return _resolve_satisfied_events()


func _resolve_satisfied_events() -> bool:
	var progressed := false
	var objective := get_active_objective()
	while objective != null and satisfied_events.has(objective.event_id):
		if not objective.complete():
			break
		progressed = true
		objective_completed.emit(objective.id, objective.title)
		active_index += 1
		if active_index >= objectives.size():
			is_complete = true
			mission_completed.emit()
			return true
		objectives[active_index].activate()
		_emit_active_objective()
		objective = get_active_objective()
	return progressed


func skip_current() -> void:
	var objective := get_active_objective()
	if objective != null:
		notify_event(objective.event_id)


func _advance_after_failure() -> void:
	active_index += 1
	if active_index >= objectives.size():
		is_complete = true
		mission_completed.emit()
		return
	objectives[active_index].activate()
	_emit_active_objective()


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
		"objective_states": _objective_states(),
		"satisfied_events": satisfied_events.keys(),
	}


func restore(data: Dictionary) -> void:
	var completed_ids: PackedStringArray = data.get("completed_ids", PackedStringArray())
	var objective_states: Dictionary = data.get("objective_states", {})
	active_index = int(data.get("active_index", 0))
	is_complete = bool(data.get("is_complete", false))
	satisfied_events.clear()
	for event_id in data.get("satisfied_events", []):
		satisfied_events[StringName(event_id)] = true
	for index in objectives.size():
		var objective := objectives[index]
		if objective_states.has(String(objective.id)):
			objective.state = int(objective_states[String(objective.id)].get("state", MissionObjective.State.INACTIVE)) as MissionObjective.State
			if objective is TimedObjective:
				(objective as TimedObjective).remaining = float(objective_states[String(objective.id)].get("remaining", (objective as TimedObjective).duration))
		elif completed_ids.has(String(objective.id)):
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
		MissionDefinition.ObjectiveKind.TIMED:
			return TimedObjective.new()
		MissionDefinition.ObjectiveKind.INTERACT:
			return InteractObjective.new()
		MissionDefinition.ObjectiveKind.COLLECT:
			return CollectObjective.new()
		MissionDefinition.ObjectiveKind.EXTRACTION:
			return ExtractionObjective.new()
		_:
			return ReachAreaObjective.new()


func _objective_states() -> Dictionary:
	var states := {}
	for objective in objectives:
		var entry := {"state": objective.state}
		if objective is TimedObjective:
			entry.remaining = (objective as TimedObjective).remaining
		states[String(objective.id)] = entry
	return states

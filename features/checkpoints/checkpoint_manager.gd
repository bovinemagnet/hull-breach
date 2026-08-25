class_name CheckpointManager
extends Node

signal checkpoint_saved(checkpoint_id: StringName)

static var _pending_state: CheckpointState

var current_state: CheckpointState


func save(state: CheckpointState) -> void:
	current_state = state.copy()
	checkpoint_saved.emit(current_state.checkpoint_id)


func prepare_restart() -> bool:
	if current_state == null:
		return false
	_pending_state = current_state.copy()
	return true


func consume_pending() -> CheckpointState:
	if _pending_state == null:
		return null
	var state := _pending_state.copy()
	_pending_state = null
	return state


static func clear_pending() -> void:
	_pending_state = null

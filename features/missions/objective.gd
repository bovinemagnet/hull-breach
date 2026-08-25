class_name MissionObjective
extends Resource

signal activated
signal completed
signal failed
signal progress_changed(current: int, target: int)

enum State { INACTIVE, ACTIVE, COMPLETED, FAILED }

@export var id: StringName
@export var title: String
@export var details: String
@export var event_id: StringName

var state := State.INACTIVE


func activate() -> bool:
	if state != State.INACTIVE:
		return false
	state = State.ACTIVE
	activated.emit()
	return true


func complete() -> bool:
	if state != State.ACTIVE:
		return false
	state = State.COMPLETED
	completed.emit()
	return true


func fail() -> bool:
	if state != State.ACTIVE:
		return false
	state = State.FAILED
	failed.emit()
	return true

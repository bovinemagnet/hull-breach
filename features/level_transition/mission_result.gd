class_name MissionResult
extends RefCounted

var mission_id: StringName
var completed := false
var completion_time := 0.0
var enemies_killed := 0
var shots_fired := 0
var damage_taken := 0.0
var difficulty: StringName = &"standard"


func to_dictionary() -> Dictionary:
	return {
		"mission_id": String(mission_id),
		"completed": completed,
		"completion_time": completion_time,
		"enemies_killed": enemies_killed,
		"shots_fired": shots_fired,
		"damage_taken": damage_taken,
		"difficulty": String(difficulty),
	}

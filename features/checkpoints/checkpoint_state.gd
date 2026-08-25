class_name CheckpointState
extends RefCounted

var checkpoint_id: StringName
var player_position: Vector2
var player_health: float
var magazine_ammo: int
var reserve_ammo: int
var credentials := PackedStringArray()
var mission_state: Dictionary = {}
var power_state: Dictionary = {}
var world_flags: Dictionary = {}
var door_states: Dictionary = {}


func copy() -> CheckpointState:
	var state := CheckpointState.new()
	state.checkpoint_id = checkpoint_id
	state.player_position = player_position
	state.player_health = player_health
	state.magazine_ammo = magazine_ammo
	state.reserve_ammo = reserve_ammo
	state.credentials = credentials.duplicate()
	state.mission_state = mission_state.duplicate(true)
	state.power_state = power_state.duplicate(true)
	state.world_flags = world_flags.duplicate(true)
	state.door_states = door_states.duplicate(true)
	return state

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
var weapon_states: Dictionary = {}


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
	state.weapon_states = weapon_states.duplicate(true)
	return state


func to_dictionary() -> Dictionary:
	return {
		"checkpoint_id": String(checkpoint_id),
		"player_position": [player_position.x, player_position.y],
		"player_health": player_health,
		"magazine_ammo": magazine_ammo,
		"reserve_ammo": reserve_ammo,
		"credentials": Array(credentials),
		"mission_state": mission_state.duplicate(true),
		"power_state": power_state.duplicate(true),
		"world_flags": world_flags.duplicate(true),
		"door_states": door_states.duplicate(true),
		"weapon_states": weapon_states.duplicate(true),
	}


static func from_dictionary(data: Dictionary) -> CheckpointState:
	var state := CheckpointState.new()
	state.checkpoint_id = StringName(data.get("checkpoint_id", ""))
	var position_data: Array = data.get("player_position", [0.0, 0.0])
	if position_data.size() >= 2:
		state.player_position = Vector2(float(position_data[0]), float(position_data[1]))
	state.player_health = float(data.get("player_health", 100.0))
	state.magazine_ammo = int(data.get("magazine_ammo", 0))
	state.reserve_ammo = int(data.get("reserve_ammo", 0))
	state.credentials = PackedStringArray(data.get("credentials", []))
	state.mission_state = data.get("mission_state", {}).duplicate(true)
	state.power_state = data.get("power_state", {}).duplicate(true)
	state.world_flags = data.get("world_flags", {}).duplicate(true)
	state.door_states = data.get("door_states", {}).duplicate(true)
	state.weapon_states = data.get("weapon_states", {}).duplicate(true)
	return state

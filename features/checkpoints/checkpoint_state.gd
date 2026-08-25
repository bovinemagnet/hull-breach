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


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if checkpoint_id.is_empty():
		errors.append("checkpoint_id must not be empty")
	if is_nan(player_position.x) or is_inf(player_position.x) or is_nan(player_position.y) or is_inf(player_position.y):
		errors.append("player_position must be finite")
	if is_nan(player_health) or is_inf(player_health) or player_health <= 0.0:
		errors.append("player_health must be finite and positive")
	if magazine_ammo < 0 or reserve_ammo < 0:
		errors.append("ammunition must not be negative")
	return errors


func is_valid() -> bool:
	return validation_errors().is_empty()


func sanitize(fallback_position: Vector2, maximum_health: float) -> void:
	if checkpoint_id.is_empty():
		checkpoint_id = &"start"
	if is_nan(player_position.x) or is_inf(player_position.x) or is_nan(player_position.y) or is_inf(player_position.y):
		player_position = fallback_position
	player_health = clampf(player_health, 1.0, maxf(1.0, maximum_health))
	magazine_ammo = maxi(0, magazine_ammo)
	reserve_ammo = maxi(0, reserve_ammo)


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
	var position_variant: Variant = data.get("player_position", [0.0, 0.0])
	var position_data: Array = position_variant if position_variant is Array else [0.0, 0.0]
	if position_data.size() >= 2:
		state.player_position = Vector2(float(position_data[0]), float(position_data[1]))
	state.player_health = float(data.get("player_health", 100.0))
	state.magazine_ammo = int(data.get("magazine_ammo", 0))
	state.reserve_ammo = int(data.get("reserve_ammo", 0))
	state.credentials = PackedStringArray(data.get("credentials", []))
	state.mission_state = data.get("mission_state", {}).duplicate(true) if data.get("mission_state", {}) is Dictionary else {}
	state.power_state = data.get("power_state", {}).duplicate(true) if data.get("power_state", {}) is Dictionary else {}
	state.world_flags = data.get("world_flags", {}).duplicate(true) if data.get("world_flags", {}) is Dictionary else {}
	state.door_states = data.get("door_states", {}).duplicate(true) if data.get("door_states", {}) is Dictionary else {}
	state.weapon_states = data.get("weapon_states", {}).duplicate(true) if data.get("weapon_states", {}) is Dictionary else {}
	return state

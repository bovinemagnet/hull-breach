extends GdUnitTestSuite


func test_powered_unlocked_door_opens_and_emits_one_transition() -> void:
	var context := await _spawn_door(false)
	var transitions: Array[int] = []
	context.door.state_changed.connect(func(state: Door.State) -> void: transitions.append(state))
	assert_bool(context.door.interact(context.player)).is_true()
	assert_int(context.door.state).is_equal(Door.State.OPENING)
	assert_int(transitions.size()).is_equal(1)


func test_unpowered_door_rejects_interaction() -> void:
	var context := await _spawn_door(true)
	assert_int(context.door.state).is_equal(Door.State.UNPOWERED)
	assert_bool(context.door.interact(context.player)).is_false()
	assert_bool(context.door.is_open()).is_false()


func test_credential_controls_locked_door() -> void:
	var context := await _spawn_door(false, &"engineering")
	assert_bool(context.door.interact(context.player)).is_false()
	assert_int(context.door.state).is_equal(Door.State.LOCKED)
	context.player.access_inventory.grant(&"engineering")
	assert_bool(context.door.interact(context.player)).is_true()


func _spawn_door(requires_power: bool, credential: StringName = &"") -> Dictionary:
	var player_scene := load("res://features/player/player.tscn") as PackedScene
	var door_scene := load("res://features/doors/door.tscn") as PackedScene
	var player := auto_free(player_scene.instantiate()) as Player
	var door := auto_free(door_scene.instantiate()) as Door
	var definition := DoorDefinition.new()
	definition.requires_power = requires_power
	definition.access_credential = credential
	door.definition = definition
	add_child(player)
	add_child(door)
	await await_idle_frame()
	return {"player": player, "door": door}

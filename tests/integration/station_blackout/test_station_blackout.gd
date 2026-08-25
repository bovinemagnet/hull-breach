extends GdUnitTestSuite


func test_vertical_slice_loads_required_systems() -> void:
	var station := await _spawn_station()
	assert_object(station.player).is_not_null()
	assert_object(station.get_node("SpawnPoints/PlayerSpawn")).is_not_null()
	assert_object(station.get_node("Mission")).is_not_null()
	assert_object(station.get_node("PowerGrid")).is_not_null()
	assert_object(station.get_node("World/NavigationRegion")).is_not_null()
	assert_object(station.get_node("World/Interactive/Extraction")).is_not_null()
	assert_int(station.mission.objectives.size()).is_equal(7)
	assert_int((station.get_node("World/Floor") as TileMapLayer).get_used_cells().size()).is_greater(800)
	assert_int((station.get_node("World/Walls") as TileMapLayer).get_used_cells().size()).is_greater(100)


func test_engineering_door_requires_then_accepts_credential() -> void:
	var station := await _spawn_station()
	assert_bool(station.engineering_door.interact(station.player)).is_false()
	assert_bool(station.engineering_door.is_open()).is_false()
	station.player.access_inventory.grant(&"engineering")
	assert_bool(station.engineering_door.interact(station.player)).is_true()
	assert_int(station.engineering_door.state).is_equal(Door.State.OPENING)


func test_power_enables_communications_and_shortcut() -> void:
	var station := await _spawn_station()
	assert_bool(station.communications_terminal.powered).is_false()
	assert_bool(station.shortcut_door.powered).is_false()
	station.power_grid.restore_main_power()
	assert_bool(station.communications_terminal.powered).is_true()
	assert_bool(station.shortcut_door.powered).is_true()


func test_weapon_noise_moves_nearby_drone_to_investigate() -> void:
	var station := await _spawn_station()
	var drone := station._spawn_drone(station.player.global_position + Vector2(80.0, 0.0))
	drone.set_target(null)
	station.noise_system.emit_noise(NoiseEvent.new(station.player.global_position, 120.0, &"weapon", station.player))
	assert_int(drone.state).is_equal(Drone.State.INVESTIGATE)


func test_drone_searches_after_reaching_noise_position() -> void:
	var station := await _spawn_station()
	var drone := station._spawn_drone(Vector2(900.0, 700.0))
	drone.set_target(null)
	station.noise_system.emit_noise(NoiseEvent.new(drone.global_position, 120.0, &"weapon", station.player))
	await await_idle_frame()
	assert_int(drone.state).is_equal(Drone.State.SEARCH)


func test_complete_mission_flow_reaches_extraction_without_editor_intervention() -> void:
	var station := await _spawn_station()
	station._on_communications_reached(&"communications")
	assert_int(station.mission.active_index).is_equal(1)
	assert_bool(station.credential_pickup.interact(station.player)).is_true()
	assert_int(station.mission.active_index).is_equal(2)
	assert_bool(station.engineering_door.interact(station.player)).is_true()
	station.mission.notify_event(&"engineering_reached")
	assert_bool(station.power_terminal.interact(station.player)).is_true()
	assert_bool(station.power_grid.is_powered(&"communications")).is_true()
	station._on_communications_reached(&"communications")
	assert_bool(station.communications_terminal.interact(station.player)).is_true()
	assert_bool(station.extraction.active).is_true()
	assert_bool(station.extraction.interact(station.player)).is_true()
	assert_bool(station.mission.is_complete).is_true()


func _spawn_station() -> StationBlackout:
	CheckpointManager.clear_pending()
	var packed_scene := load("res://levels/campaign/station_blackout/station_blackout.tscn") as PackedScene
	assert_object(packed_scene).is_not_null()
	var station := auto_free(packed_scene.instantiate()) as StationBlackout
	add_child(station)
	await await_idle_frame()
	return station

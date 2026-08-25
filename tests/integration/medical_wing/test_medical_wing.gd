extends GdUnitTestSuite


func test_medical_wing_loads_reused_production_systems() -> void:
	var wing := await _spawn_wing()
	assert_int(wing.mission.objectives.size()).is_equal(7)
	assert_object(wing.quarantine_door).is_not_null()
	assert_object(wing.electrical_hazard).is_not_null()
	assert_object(wing.gas_hazard).is_not_null()
	assert_object(wing.hunter_encounter).is_not_null()
	assert_object(wing.spitter_encounter).is_not_null()
	assert_int((wing.get_node("World/Floor") as TileMapLayer).get_used_cells().size()).is_greater(800)


func test_medical_access_hazard_and_archive_flow() -> void:
	var wing := await _spawn_wing()
	wing.mission.notify_event(&"triage_reached")
	assert_bool(wing.medical_pickup.interact(wing.player)).is_true()
	assert_bool(wing.player.access_inventory.has_access(&"medical")).is_true()
	assert_bool(wing.quarantine_door.interact(wing.player)).is_true()
	wing.mission.notify_event(&"wards_entered")
	assert_bool(wing.hazard_terminal.interact(wing.player)).is_true()
	assert_bool(wing.electrical_hazard.enabled).is_false()
	assert_bool(wing.gas_hazard.enabled).is_false()
	wing.mission.notify_event(&"archive_reached")
	assert_bool(wing.archive_terminal.interact(wing.player)).is_true()
	assert_bool(wing.extraction.active).is_true()
	assert_bool(wing.extraction.interact(wing.player)).is_true()
	assert_bool(wing.mission.is_complete).is_true()


func test_shotgun_pickup_adds_third_weapon_slot() -> void:
	var wing := await _spawn_wing()
	assert_bool(wing.shotgun_pickup.interact(wing.player)).is_true()
	assert_int(wing.player.weapon_inventory.weapons.size()).is_equal(3)
	assert_str(String(wing.player.weapon.definition.id)).is_equal("shotgun")


func _spawn_wing() -> MedicalWing:
	CheckpointManager.clear_pending()
	var packed := load("res://levels/campaign/medical_wing/medical_wing.tscn") as PackedScene
	var wing := auto_free(packed.instantiate()) as MedicalWing
	add_child(wing)
	await await_idle_frame()
	return wing

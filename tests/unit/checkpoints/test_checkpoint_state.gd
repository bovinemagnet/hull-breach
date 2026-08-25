extends GdUnitTestSuite


func test_copy_preserves_and_isolates_complete_checkpoint_state() -> void:
	var source := CheckpointState.new()
	source.checkpoint_id = &"engineering"
	source.player_health = 55.0
	source.magazine_ammo = 8
	source.reserve_ammo = 34
	source.credentials = PackedStringArray(["engineering"])
	source.power_state = {&"main": true}
	source.mission_state = {"active_index": 4}
	source.world_flags = {"power_restored": true}
	var copied := source.copy()
	assert_str(String(copied.checkpoint_id)).is_equal("engineering")
	assert_float(copied.player_health).is_equal(55.0)
	assert_int(copied.magazine_ammo).is_equal(8)
	assert_int(copied.reserve_ammo).is_equal(34)
	assert_bool(copied.credentials.has("engineering")).is_true()
	assert_bool(copied.power_state[&"main"]).is_true()
	copied.world_flags.power_restored = false
	assert_bool(source.world_flags.power_restored).is_true()

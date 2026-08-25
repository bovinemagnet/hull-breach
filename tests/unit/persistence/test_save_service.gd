extends GdUnitTestSuite

const TEST_PATH := "user://phase3_save_test.json"


func test_save_round_trip_preserves_campaign_checkpoint() -> void:
	var service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	var data := service.default_data(&"survivor")
	data.active_mission = {"id": "medical_wing", "checkpoint": {"player_health": 42.0}}
	assert_bool(service.save(data)).is_true()
	var restored := service.load()
	assert_str(restored.profile.difficulty).is_equal("survivor")
	assert_str(restored.active_mission.id).is_equal("medical_wing")
	assert_float(restored.active_mission.checkpoint.player_health).is_equal(42.0)
	service.clear()


func test_schema_zero_migrates_to_current() -> void:
	var migrated := SaveMigration.migrate({"game_version": "0.0.1"})
	assert_int(migrated.schema_version).is_equal(SaveMigration.CURRENT_SCHEMA_VERSION)
	assert_str(migrated.profile.difficulty).is_equal("standard")
	assert_str(migrated.campaign.current_mission).is_equal("station_blackout")


func test_future_schema_is_rejected() -> void:
	assert_dict(SaveMigration.migrate({"schema_version": 999})).is_empty()


func test_corrupted_primary_recovers_previous_backup() -> void:
	var service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	var first := service.default_data(&"explorer")
	assert_bool(service.save(first)).is_true()
	var second := service.default_data(&"survivor")
	assert_bool(service.save(second)).is_true()
	var file := FileAccess.open(TEST_PATH, FileAccess.WRITE)
	file.store_string("not json")
	file.close()
	var recovered := service.load()
	assert_str(recovered.profile.difficulty).is_equal("explorer")
	assert_str(service.last_error).contains("recovered backup")
	service.clear()

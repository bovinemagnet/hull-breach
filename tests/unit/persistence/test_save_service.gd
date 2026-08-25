extends GdUnitTestSuite

const TEST_PATH := "user://phase3_save_test.json"


func test_save_round_trip_preserves_campaign_checkpoint() -> void:
	var service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	var data := service.default_data(&"survivor")
	data.active_mission = {
		"id": "medical_wing",
		"checkpoint": {
			"checkpoint_id": "medical_access",
			"player_position": [240.0, 180.0],
			"player_health": 42.0,
			"magazine_ammo": 6,
			"reserve_ammo": 24,
		},
	}
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
	assert_bool(migrated.campaign.campaign_complete).is_false()


func test_future_schema_is_rejected() -> void:
	assert_dict(SaveMigration.migrate({"schema_version": 999})).is_empty()


func test_beta_schema_three_save_loads_without_progress_loss() -> void:
	var save_service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	save_service.configure_path(TEST_PATH)
	save_service.clear()
	var beta_save := {
		"schema_version": 3,
		"game_version": "0.8.0",
		"profile": {"difficulty": "standard"},
		"campaign": {
			"completed_missions": ["station_blackout", "medical_wing"],
			"current_mission": "cargo_deck",
			"campaign_complete": false,
			"loadout": {},
		},
		"active_mission": {},
		"metadata": {},
	}
	var file := FileAccess.open(TEST_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(beta_save))
	file.close()
	var restored := save_service.load()
	assert_str(restored.game_version).is_equal("0.8.0")
	assert_str(restored.campaign.current_mission).is_equal("cargo_deck")
	assert_array(restored.campaign.completed_missions).contains_exactly(["station_blackout", "medical_wing"])
	assert_bool(save_service.save(restored)).is_true()
	assert_str(save_service.load().game_version).is_equal("1.0.0-rc.1")
	save_service.clear()


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
	assert_str(service.last_status).is_equal("recovered_backup")
	service.clear()


func test_integrity_tampering_is_rejected_and_backup_is_restored() -> void:
	var service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	assert_bool(service.save(service.default_data(&"explorer"))).is_true()
	assert_bool(service.save(service.default_data(&"standard"))).is_true()
	var file := FileAccess.open(TEST_PATH, FileAccess.READ_WRITE)
	var document: Dictionary = JSON.parse_string(file.get_as_text())
	document.profile.difficulty = "survivor"
	file.seek(0)
	file.store_string(JSON.stringify(document, "  "))
	file.close()
	var recovered := service.load()
	assert_str(recovered.profile.difficulty).is_equal("explorer")
	assert_str(service.last_status).is_equal("recovered_backup")
	service.clear()


func test_interrupted_temporary_save_recovers_when_primary_is_missing() -> void:
	var service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	assert_bool(service.save(service.default_data(&"survivor"))).is_true()
	assert_int(DirAccess.rename_absolute(ProjectSettings.globalize_path(TEST_PATH), ProjectSettings.globalize_path("%s.tmp" % TEST_PATH))).is_equal(OK)
	var recovered := service.load()
	assert_str(recovered.profile.difficulty).is_equal("survivor")
	assert_str(service.last_status).is_equal("recovered_temporary")
	assert_bool(FileAccess.file_exists(TEST_PATH)).is_true()
	service.clear()


func test_invalid_campaign_structure_fails_before_write() -> void:
	var service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	var invalid := service.default_data()
	invalid.campaign.current_mission = "not_a_mission"
	assert_bool(service.save(invalid)).is_false()
	assert_str(service.last_error).contains("current campaign mission")
	assert_bool(FileAccess.file_exists(TEST_PATH)).is_false()
	service.clear()


func test_unavailable_save_directory_fails_without_corrupting_existing_data() -> void:
	var service := auto_free(SaveServiceNode.new()) as SaveServiceNode
	service.configure_path("user://missing-release-test-directory/campaign.json")
	assert_bool(service.save(service.default_data())).is_false()
	assert_str(service.last_error).contains("temporary save file")

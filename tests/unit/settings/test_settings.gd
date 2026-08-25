extends GdUnitTestSuite

const TEST_PATH := "user://phase3_settings_test.json"


func test_settings_round_trip_and_clamp() -> void:
	var service := auto_free(SettingsServiceNode.new()) as SettingsServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	service.settings.master_volume = 0.35
	service.settings.controller_deadzone = 0.3
	service.settings.touch_sensitivity = 1.4
	service.settings.vibration_intensity = 0.25
	assert_bool(service.save_settings()).is_true()
	service.settings = GameSettings.new()
	var restored := service.load_settings()
	assert_float(restored.master_volume).is_equal_approx(0.35, 0.001)
	assert_float(restored.controller_deadzone).is_equal_approx(0.3, 0.001)
	assert_float(restored.touch_sensitivity).is_equal_approx(1.4, 0.001)
	assert_float(restored.vibration_intensity).is_equal_approx(0.25, 0.001)
	service.clear()


func test_invalid_dictionary_values_are_clamped() -> void:
	var settings := GameSettings.from_dictionary({"audio": {"master": 5.0}, "controls": {"controller_deadzone": -2.0}})
	assert_float(settings.master_volume).is_equal(1.0)
	assert_float(settings.controller_deadzone).is_equal(0.0)


func test_corrupted_settings_recover_from_backup() -> void:
	var service := auto_free(SettingsServiceNode.new()) as SettingsServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	service.settings.master_volume = 0.2
	assert_bool(service.save_settings()).is_true()
	service.settings.master_volume = 0.7
	assert_bool(service.save_settings()).is_true()
	var file := FileAccess.open(TEST_PATH, FileAccess.WRITE)
	file.store_string("damaged")
	file.close()
	var recovered := service.load_settings()
	assert_float(recovered.master_volume).is_equal_approx(0.2, 0.001)
	assert_str(service.last_error).contains("backup")
	service.clear()


func test_unavailable_settings_directory_fails_gracefully() -> void:
	var service := auto_free(SettingsServiceNode.new()) as SettingsServiceNode
	service.configure_path("user://missing-release-test-directory/settings.json")
	assert_bool(service.save_settings()).is_false()
	assert_str(service.last_error).contains("temporary settings")

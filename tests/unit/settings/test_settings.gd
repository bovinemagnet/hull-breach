extends GdUnitTestSuite

const TEST_PATH := "user://phase3_settings_test.json"


func test_settings_round_trip_and_clamp() -> void:
	var service := auto_free(SettingsServiceNode.new()) as SettingsServiceNode
	service.configure_path(TEST_PATH)
	service.clear()
	service.settings.master_volume = 0.35
	service.settings.controller_deadzone = 0.3
	assert_bool(service.save_settings()).is_true()
	service.settings = GameSettings.new()
	var restored := service.load_settings()
	assert_float(restored.master_volume).is_equal_approx(0.35, 0.001)
	assert_float(restored.controller_deadzone).is_equal_approx(0.3, 0.001)
	service.clear()


func test_invalid_dictionary_values_are_clamped() -> void:
	var settings := GameSettings.from_dictionary({"audio": {"master": 5.0}, "controls": {"controller_deadzone": -2.0}})
	assert_float(settings.master_volume).is_equal(1.0)
	assert_float(settings.controller_deadzone).is_equal(0.0)

extends GdUnitTestSuite


func test_game_version_is_phase_zero_version() -> void:
	assert_str(GameVersion.as_string()).is_equal("0.0.1")

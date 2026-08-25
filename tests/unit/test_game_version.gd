extends GdUnitTestSuite


func test_game_version_is_phase_three_version() -> void:
	assert_str(GameVersion.as_string()).is_equal("0.3.0")

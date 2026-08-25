extends GdUnitTestSuite


func test_game_version_is_phase_two_version() -> void:
	assert_str(GameVersion.as_string()).is_equal("0.2.0")

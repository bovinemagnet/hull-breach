extends GdUnitTestSuite


func test_game_version_is_beta_version() -> void:
	assert_str(GameVersion.as_string()).is_equal("0.8.0")
	assert_str(GameVersion.display_string()).contains("Beta")

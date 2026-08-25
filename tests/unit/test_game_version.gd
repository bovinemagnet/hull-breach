extends GdUnitTestSuite


func test_game_version_is_release_candidate() -> void:
	assert_str(GameVersion.as_string()).is_equal("1.0.0-rc.1")
	assert_str(GameVersion.display_string()).contains("Release Candidate")
	assert_bool(GameVersion.is_release_candidate()).is_true()


func test_support_string_exposes_release_identity() -> void:
	var support := GameVersion.support_string()
	assert_str(support).contains("Version: 1.0.0-rc.1")
	assert_str(support).contains("Commit:")
	assert_str(support).contains("Build Date:")
	assert_str(support).contains("Channel: Release Candidate")

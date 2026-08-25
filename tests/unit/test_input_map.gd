extends GdUnitTestSuite


func test_required_input_actions_are_configured() -> void:
	var required_actions: Array[StringName] = [
		&"move_left",
		&"move_right",
		&"move_up",
		&"move_down",
		&"aim_left",
		&"aim_right",
		&"aim_up",
		&"aim_down",
		&"fire",
		&"secondary_fire",
		&"interact",
		&"reload",
		&"sprint",
		&"weapon_next",
		&"weapon_previous",
		&"pause",
		&"map",
	]

	for action in required_actions:
		assert_bool(InputMap.has_action(action)).is_true()

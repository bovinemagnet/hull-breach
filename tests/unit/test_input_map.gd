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


func test_movement_actions_include_arrow_keys() -> void:
	var arrow_bindings: Dictionary = {
		&"move_left": KEY_LEFT,
		&"move_right": KEY_RIGHT,
		&"move_up": KEY_UP,
		&"move_down": KEY_DOWN,
	}

	for action: StringName in arrow_bindings:
		assert_bool(_action_has_key(action, int(arrow_bindings[action]))).override_failure_message(
			"%s must include its arrow-key binding" % action
		).is_true()


func _action_has_key(action: StringName, keycode: int) -> bool:
	for input_event: InputEvent in InputMap.action_get_events(action):
		var key_event := input_event as InputEventKey
		if key_event != null and (key_event.keycode == keycode or key_event.physical_keycode == keycode):
			return true
	return false

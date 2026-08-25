extends GdUnitTestSuite


func test_input_methods_expose_stable_interaction_prompts() -> void:
	var service := auto_free(PlatformServiceNode.new()) as PlatformServiceNode
	service.active_input_method = PlatformServiceNode.InputMethod.KEYBOARD_MOUSE
	assert_str(service.prompt_prefix()).is_equal("[E]")
	service.active_input_method = PlatformServiceNode.InputMethod.CONTROLLER
	assert_str(service.prompt_prefix()).is_equal("[A]")
	service.active_input_method = PlatformServiceNode.InputMethod.TOUCH
	assert_str(service.prompt_prefix()).is_equal("[USE]")

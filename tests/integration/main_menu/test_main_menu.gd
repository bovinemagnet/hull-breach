extends GdUnitTestSuite


func test_main_menu_loads_campaign_and_settings_actions() -> void:
	var packed := load("res://ui/menus/main_menu.tscn") as PackedScene
	var menu := auto_free(packed.instantiate()) as MainMenu
	add_child(menu)
	await await_idle_frame()
	assert_object(menu.get_node("MainPanel/Buttons/NewGameButton")).is_instanceof(Button)
	assert_object(menu.get_node("MainPanel/Buttons/ContinueButton")).is_instanceof(Button)
	assert_object(menu.get_node("MainPanel/Buttons/SettingsButton")).is_instanceof(Button)
	assert_object(menu.get_node("MainPanel/Buttons/MissionSelectButton")).is_instanceof(Button)
	assert_object(menu.get_node("MainPanel/Buttons/CreditsButton")).is_instanceof(Button)
	assert_object(menu.get_node("SettingsPanel/Scroll/Grid/FullscreenCheck")).is_instanceof(CheckButton)
	assert_object(menu.get_node("SettingsPanel/Scroll")).is_instanceof(ScrollContainer)
	assert_bool(menu.difficulty_panel.visible).is_false()
	assert_bool(menu.settings_panel.visible).is_false()

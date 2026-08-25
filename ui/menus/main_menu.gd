class_name MainMenu
extends Control

@onready var continue_button: Button = %ContinueButton
@onready var main_panel: Control = %MainPanel
@onready var difficulty_panel: Control = %DifficultyPanel
@onready var settings_panel: Control = %SettingsPanel
var mission_select_panel: PanelContainer
var controller_sensitivity_slider: HSlider
var touch_sensitivity_slider: HSlider
var screen_shake_slider: HSlider
var flash_intensity_slider: HSlider


func _ready() -> void:
	%NewGameButton.pressed.connect(_show_difficulty)
	continue_button.pressed.connect(func() -> void: GameSession.continue_campaign())
	%SettingsButton.pressed.connect(_show_settings)
	%QuitButton.pressed.connect(get_tree().quit)
	%ExplorerButton.pressed.connect(func() -> void: GameSession.new_game(&"explorer"))
	%StandardButton.pressed.connect(func() -> void: GameSession.new_game(&"standard"))
	%SurvivorButton.pressed.connect(func() -> void: GameSession.new_game(&"survivor"))
	%DifficultyBackButton.pressed.connect(_show_main)
	%SettingsBackButton.pressed.connect(_save_and_show_main)
	continue_button.disabled = not SaveService.has_save()
	_build_campaign_actions()
	_build_accessibility_settings()
	_populate_settings()
	%NewGameButton.grab_focus()


func _show_difficulty() -> void:
	main_panel.hide()
	difficulty_panel.show()
	%StandardButton.grab_focus()


func _show_settings() -> void:
	main_panel.hide()
	settings_panel.show()
	%MasterSlider.grab_focus()


func _show_main() -> void:
	difficulty_panel.hide()
	settings_panel.hide()
	if mission_select_panel != null:
		mission_select_panel.hide()
	main_panel.show()
	%NewGameButton.grab_focus()


func _build_campaign_actions() -> void:
	var mission_select_button := Button.new()
	mission_select_button.name = "MissionSelectButton"
	mission_select_button.text = "Mission Select"
	mission_select_button.pressed.connect(_show_mission_select)
	$MainPanel/Buttons.add_child(mission_select_button)
	$MainPanel/Buttons.move_child(mission_select_button, 2)
	var credits_button := Button.new()
	credits_button.name = "CreditsButton"
	credits_button.text = "Credits"
	credits_button.pressed.connect(func() -> void: GameSession.transition_to_scene("res://ui/credits/credits.tscn"))
	$MainPanel/Buttons.add_child(credits_button)
	$MainPanel/Buttons.move_child(credits_button, $MainPanel/Buttons.get_child_count() - 2)
	mission_select_panel = PanelContainer.new()
	mission_select_panel.name = "MissionSelectPanel"
	mission_select_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	mission_select_panel.position = Vector2(-190, -165)
	mission_select_panel.size = Vector2(380, 330)
	var list := VBoxContainer.new()
	list.add_child(_menu_label("CAMPAIGN MISSION SELECT"))
	for mission_id in CampaignCatalog.MISSION_IDS:
		var selected_id := mission_id
		var button := Button.new()
		button.text = "%02d  %s" % [CampaignCatalog.MISSION_IDS.find(selected_id) + 1, CampaignCatalog.MISSION_NAMES[selected_id]]
		button.disabled = not OS.is_debug_build() and not GameSession.is_mission_unlocked(selected_id)
		button.pressed.connect(func() -> void: GameSession.transition_to_mission(selected_id))
		list.add_child(button)
	var back := Button.new()
	back.text = "Back"
	back.pressed.connect(_show_main)
	list.add_child(back)
	mission_select_panel.add_child(list)
	add_child(mission_select_panel)
	mission_select_panel.hide()


func _menu_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label


func _show_mission_select() -> void:
	main_panel.hide()
	mission_select_panel.show()
	var first_button := mission_select_panel.get_child(0).get_child(1) as Button
	first_button.grab_focus()


func _build_accessibility_settings() -> void:
	controller_sensitivity_slider = _add_settings_slider("Controller Sensitivity", 0.1, 3.0)
	touch_sensitivity_slider = _add_settings_slider("Touch Sensitivity", 0.25, 2.0)
	screen_shake_slider = _add_settings_slider("Screen Shake", 0.0, 1.0)
	flash_intensity_slider = _add_settings_slider("Flash Intensity", 0.0, 1.0)


func _add_settings_slider(label_text: String, minimum: float, maximum: float) -> HSlider:
	var label := Label.new()
	label.text = label_text
	var slider := HSlider.new()
	slider.min_value = minimum
	slider.max_value = maximum
	slider.step = 0.05
	$SettingsPanel/Grid.add_child(label)
	$SettingsPanel/Grid.add_child(slider)
	$SettingsPanel/Grid.move_child(%SettingsBackButton, $SettingsPanel/Grid.get_child_count() - 1)
	return slider


func _populate_settings() -> void:
	var settings := SettingsService.settings
	%MasterSlider.value = settings.master_volume
	%MusicSlider.value = settings.music_volume
	%AmbienceSlider.value = settings.ambience_volume
	%SfxSlider.value = settings.sfx_volume
	%VsyncCheck.button_pressed = settings.vsync_enabled
	%DeadzoneSlider.value = settings.controller_deadzone
	%AimAssistSlider.value = settings.aim_assist_strength
	%UiScaleSlider.value = settings.ui_scale
	controller_sensitivity_slider.value = settings.controller_sensitivity
	touch_sensitivity_slider.value = settings.touch_sensitivity
	screen_shake_slider.value = settings.screen_shake_intensity
	flash_intensity_slider.value = settings.flash_intensity


func _save_and_show_main() -> void:
	var settings := SettingsService.settings
	settings.master_volume = %MasterSlider.value
	settings.music_volume = %MusicSlider.value
	settings.ambience_volume = %AmbienceSlider.value
	settings.sfx_volume = %SfxSlider.value
	settings.vsync_enabled = %VsyncCheck.button_pressed
	settings.controller_deadzone = %DeadzoneSlider.value
	settings.aim_assist_strength = %AimAssistSlider.value
	settings.ui_scale = %UiScaleSlider.value
	settings.controller_sensitivity = controller_sensitivity_slider.value
	settings.touch_sensitivity = touch_sensitivity_slider.value
	settings.screen_shake_intensity = screen_shake_slider.value
	settings.flash_intensity = flash_intensity_slider.value
	SettingsService.save_settings()
	_show_main()

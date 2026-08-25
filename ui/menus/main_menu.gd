class_name MainMenu
extends Control

@onready var continue_button: Button = %ContinueButton
@onready var main_panel: Control = %MainPanel
@onready var difficulty_panel: Control = %DifficultyPanel
@onready var settings_panel: Control = %SettingsPanel


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
	main_panel.show()
	%NewGameButton.grab_focus()


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
	SettingsService.save_settings()
	_show_main()

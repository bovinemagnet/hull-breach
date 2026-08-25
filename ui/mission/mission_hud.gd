class_name MissionHud
extends CanvasLayer

signal replay_requested
signal quit_requested

@onready var objective_title: Label = %ObjectiveTitle
@onready var objective_details: Label = %ObjectiveDetails
@onready var prompt_label: Label = %PromptLabel
@onready var notification_label: Label = %NotificationLabel
@onready var power_label: Label = %PowerLabel
@onready var debug_label: Label = %DebugLabel
@onready var complete_overlay: Control = %CompleteOverlay

var _notification_remaining := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	%ReplayButton.pressed.connect(func() -> void: replay_requested.emit())
	%QuitButton.pressed.connect(func() -> void: quit_requested.emit())
	prompt_label.hide()
	notification_label.hide()
	debug_label.hide()
	complete_overlay.hide()


func _process(delta: float) -> void:
	if _notification_remaining > 0.0:
		_notification_remaining -= delta
		if _notification_remaining <= 0.0:
			notification_label.hide()


func set_objective(title: String, details: String, current: int, total: int) -> void:
	objective_title.text = "OBJECTIVE %d/%d  •  %s" % [current, total, title.to_upper()]
	objective_details.text = details


func set_prompt(text: String) -> void:
	prompt_label.text = "[E / A]  %s" % text
	prompt_label.visible = not text.is_empty()


func notify(message: String, duration: float = 2.2) -> void:
	notification_label.text = message
	notification_label.show()
	_notification_remaining = duration


func set_power(main_powered: bool) -> void:
	power_label.text = "FACILITY POWER  %s" % ("ONLINE" if main_powered else "EMERGENCY")
	power_label.modulate = Color(0.45, 1.0, 0.7) if main_powered else Color(1.0, 0.48, 0.25)


func set_debug(visible: bool, text: String) -> void:
	debug_label.visible = visible
	debug_label.text = text


func show_complete() -> void:
	complete_overlay.show()
	%ReplayButton.grab_focus()

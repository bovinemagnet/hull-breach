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
var _current_title := ""
var _completed_titles := PackedStringArray()
var _mission: MissionController


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	%ReplayButton.pressed.connect(func() -> void: replay_requested.emit())
	%QuitButton.pressed.connect(func() -> void: quit_requested.emit())
	prompt_label.hide()
	notification_label.hide()
	debug_label.hide()
	complete_overlay.hide()
	var platform := get_node_or_null("/root/PlatformService") as PlatformServiceNode
	if platform != null:
		platform.input_method_changed.connect(func(_method: PlatformServiceNode.InputMethod) -> void: _refresh_prompt())


func _process(delta: float) -> void:
	if _notification_remaining > 0.0:
		_notification_remaining -= delta
		if _notification_remaining <= 0.0:
			notification_label.hide()


func set_objective(title: String, details: String, current: int, total: int) -> void:
	if not _current_title.is_empty() and _current_title != title and not _completed_titles.has(_current_title):
		_completed_titles.append(_current_title)
	_current_title = title
	objective_title.text = "OBJECTIVE %d/%d  •  %s" % [current, total, title.to_upper()]
	objective_details.text = details


func bind_mission(mission: MissionController) -> void:
	_mission = mission


func set_prompt(text: String) -> void:
	prompt_label.set_meta(&"prompt_text", text)
	_refresh_prompt()
	prompt_label.visible = not text.is_empty()


func objective_summary() -> String:
	var completed := PackedStringArray()
	if _mission != null:
		for objective in _mission.objectives:
			if objective.state == MissionObjective.State.COMPLETED:
				completed.append(objective.title)
	else:
		completed = _completed_titles.duplicate()
	var history := "NONE" if completed.is_empty() else ", ".join(completed)
	return "CURRENT OBJECTIVE\n%s\n\nCOMPLETED  %d\n%s" % [_current_title.to_upper(), completed.size(), history]


func _refresh_prompt() -> void:
	var text := String(prompt_label.get_meta(&"prompt_text", ""))
	var platform := get_node_or_null("/root/PlatformService") as PlatformServiceNode
	var prefix := platform.prompt_prefix() if platform != null else "[E]"
	prompt_label.text = "%s  %s" % [prefix, text]


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


func show_complete(title := "MISSION COMPLETE", subtitle := "Objective secured. Extraction successful.", action := "Continue") -> void:
	%CompleteTitle.text = title
	%CompleteSubtitle.text = subtitle
	%ReplayButton.text = action
	complete_overlay.show()
	%ReplayButton.grab_focus()

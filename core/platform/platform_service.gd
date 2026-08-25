class_name PlatformServiceNode
extends Node

signal pause_requested(reason: String)
signal resumed
signal controller_disconnected(device: int)
signal controller_connected(device: int)
signal input_method_changed(method: InputMethod)

enum InputMethod { KEYBOARD_MOUSE, CONTROLLER, TOUCH }

const GAMEPLAY_ACTIONS := [
	&"move_left", &"move_right", &"move_up", &"move_down",
	&"aim_left", &"aim_right", &"aim_up", &"aim_down",
	&"fire", &"secondary_fire", &"interact", &"reload", &"sprint",
]

var active_input_method := InputMethod.KEYBOARD_MOUSE
var active_controller_device := -1
var lifecycle_paused := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.joy_connection_changed.connect(_on_joy_connection_changed)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		_set_input_method(InputMethod.TOUCH)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event is InputEventJoypadMotion and absf(event.axis_value) < 0.25:
			return
		active_controller_device = event.device
		_set_input_method(InputMethod.CONTROLLER)
	elif event is InputEventKey or event is InputEventMouseButton:
		_set_input_method(InputMethod.KEYBOARD_MOUSE)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		request_gameplay_pause("APPLICATION PAUSED")
	elif what == NOTIFICATION_APPLICATION_RESUMED or what == NOTIFICATION_APPLICATION_FOCUS_IN:
		if lifecycle_paused:
			lifecycle_paused = false
			resumed.emit()


func request_gameplay_pause(reason: String) -> void:
	if get_tree() == null or get_tree().get_first_node_in_group(&"player") == null:
		return
	_release_gameplay_actions()
	if get_tree().paused:
		return
	lifecycle_paused = true
	get_tree().paused = true
	pause_requested.emit(reason)


func prompt_prefix() -> String:
	match active_input_method:
		InputMethod.CONTROLLER:
			return "[A]"
		InputMethod.TOUCH:
			return "[USE]"
		_:
			return "[E]"


func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected:
		controller_connected.emit(device)
		return
	controller_disconnected.emit(device)
	if active_input_method == InputMethod.CONTROLLER and (active_controller_device < 0 or active_controller_device == device):
		request_gameplay_pause("CONTROLLER DISCONNECTED")


func _set_input_method(method: InputMethod) -> void:
	if active_input_method == method:
		return
	active_input_method = method
	input_method_changed.emit(active_input_method)


func _release_gameplay_actions() -> void:
	for action in GAMEPLAY_ACTIONS:
		Input.action_release(action)

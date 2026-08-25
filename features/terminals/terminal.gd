class_name Terminal
extends Interactable

signal activated(terminal_id: StringName, player: Player)

@export var terminal_id: StringName = &"terminal"
@export var display_name: String = "Access Terminal"
@export var requires_power: bool = false
@export var power_circuit: StringName = &"main"
@export_multiline var offline_message: String = "SYSTEM OFFLINE"

var powered := true
var used := false
var _power_consumer: PowerConsumer


func _ready() -> void:
	super._ready()
	interaction_label = display_name
	powered = not requires_power
	queue_redraw()


func bind_power_grid(grid: PowerGrid) -> void:
	if not requires_power:
		return
	_power_consumer = PowerConsumer.new()
	_power_consumer.circuit = power_circuit
	add_child(_power_consumer)
	_power_consumer.powered_changed.connect(func(enabled: bool) -> void: powered = enabled; queue_redraw())
	_power_consumer.bind(grid)


func get_interaction_text(_player: Player) -> String:
	return display_name if powered else "%s (Offline)" % display_name


func interact(player: Player) -> bool:
	if not powered:
		feedback_requested.emit(offline_message)
		activated.emit(terminal_id, player)
		return false
	used = true
	activated.emit(terminal_id, player)
	interaction_completed.emit(self, player)
	queue_redraw()
	return true


func _draw() -> void:
	draw_rect(Rect2(-16.0, -22.0, 32.0, 44.0), Color(0.12, 0.17, 0.18), true)
	draw_rect(Rect2(-12.0, -17.0, 24.0, 18.0), Color(0.08, 0.12, 0.13), true)
	var screen_colour := Color(0.24, 0.95, 0.75) if powered else Color(0.55, 0.16, 0.12)
	draw_rect(Rect2(-9.0, -14.0, 18.0, 12.0), screen_colour, true)
	draw_line(Vector2(-10.0, 9.0), Vector2(10.0, 9.0), Color(0.4, 0.46, 0.46), 2.0)

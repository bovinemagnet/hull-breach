class_name PoweredLight
extends Node2D

@export var circuit: StringName = &"main"
@export var light_colour := Color(0.55, 0.9, 1.0)
@export_range(0.0, 4.0, 0.05) var energy: float = 0.75
@export_range(0.1, 5.0, 0.1) var texture_scale: float = 2.5

var powered := false
var _light: PointLight2D
var _consumer: PowerConsumer


func _ready() -> void:
	_light = PointLight2D.new()
	_light.texture = LightTextureFactory.radial()
	_light.color = light_colour
	_light.energy = energy
	_light.texture_scale = texture_scale
	_light.enabled = false
	add_child(_light)
	queue_redraw()


func bind_power_grid(grid: PowerGrid) -> void:
	_consumer = PowerConsumer.new()
	_consumer.circuit = circuit
	add_child(_consumer)
	_consumer.powered_changed.connect(_on_powered_changed)
	_consumer.bind(grid)


func _on_powered_changed(enabled: bool) -> void:
	powered = enabled
	_light.enabled = powered
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(-11.0, -3.0, 22.0, 6.0), Color(0.13, 0.18, 0.19), true)
	draw_rect(Rect2(-8.0, -2.0, 16.0, 4.0), light_colour if powered else Color(0.16, 0.18, 0.18), true)

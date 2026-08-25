class_name HealthPickup
extends Area2D

signal feedback_requested(message: String)

@export_range(1.0, 1000.0, 1.0) var healing: float = 35.0
var collected := false
var _pulse := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	_pulse += delta
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if collected or not body is Player:
		return
	var player := body as Player
	if player.health_component.is_dead or player.health_component.current_health >= player.health_component.maximum_health:
		feedback_requested.emit("HEALTH FULL")
		return
	player.health_component.heal(healing)
	collected = true
	queue_free()


func _draw() -> void:
	var glow := 0.72 + sin(_pulse * 4.0) * 0.18
	draw_circle(Vector2.ZERO, 15.0, Color(0.25, 1.0, 0.5, 0.12 * glow))
	draw_rect(Rect2(-10.0, -8.0, 20.0, 16.0), Color(0.12, 0.2, 0.18), true)
	draw_rect(Rect2(-3.0, -6.0, 6.0, 12.0), Color(0.3, 1.0, 0.55, glow), true)
	draw_rect(Rect2(-7.0, -2.0, 14.0, 4.0), Color(0.3, 1.0, 0.55, glow), true)

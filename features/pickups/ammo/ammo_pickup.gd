class_name AmmoPickup
extends Area2D

@export_range(1, 1000, 1) var rounds: int = 60
var _pulse := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	queue_redraw()


func _process(delta: float) -> void:
	_pulse += delta
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		var accepted: int = player.weapon.add_reserve_ammo(rounds)
		if accepted > 0:
			queue_free()


func _draw() -> void:
	var glow := 0.75 + sin(_pulse * 4.0) * 0.2
	draw_circle(Vector2.ZERO, 16.0, Color(0.1, 0.5, 0.55, 0.16 * glow))
	draw_rect(Rect2(-10.0, -7.0, 20.0, 14.0), Color(0.12, 0.2, 0.23), true)
	draw_rect(Rect2(-7.0, -4.0, 14.0, 8.0), Color(0.3, 0.95, 0.85, glow), true)
	for offset in [-4.0, 0.0, 4.0]:
		draw_line(Vector2(offset, -3.0), Vector2(offset, 3.0), Color(0.04, 0.12, 0.14), 1.0)

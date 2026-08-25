class_name GasHazard
extends Hazard

var _phase := 0.0


func _process(delta: float) -> void:
	_phase += delta
	queue_redraw()


func _draw() -> void:
	if not enabled:
		return
	for index in 12:
		var angle := float(index) / 12.0 * TAU + _phase * 0.08
		var offset := Vector2(cos(angle) * 85.0, sin(angle) * 44.0)
		draw_circle(offset, 24.0, Color(0.35, 0.78, 0.28, 0.09))
	draw_rect(Rect2(-105.0, -60.0, 210.0, 120.0), Color(0.25, 0.55, 0.18, 0.08), true)

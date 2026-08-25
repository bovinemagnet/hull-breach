class_name ElectricalHazard
extends Hazard

var _phase := 0.0


func _process(delta: float) -> void:
	_phase += delta
	queue_redraw()


func _draw() -> void:
	var colour := Color(0.3, 0.8, 1.0, 0.9) if enabled else Color(0.18, 0.25, 0.27, 0.35)
	draw_rect(Rect2(-70.0, -24.0, 140.0, 48.0), Color(colour, 0.13), true)
	if enabled:
		for index in 5:
			var start := Vector2(-64.0 + index * 28.0, sin(_phase * 12.0 + index) * 8.0)
			draw_polyline(PackedVector2Array([start, start + Vector2(9, -10), start + Vector2(17, 9), start + Vector2(27, -3)]), colour, 2.0)

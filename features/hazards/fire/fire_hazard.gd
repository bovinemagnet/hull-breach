class_name FireHazard
extends Hazard

var _phase := 0.0


func _process(delta: float) -> void:
	_phase += delta
	queue_redraw()


func _draw() -> void:
	if not enabled:
		return
	for index in 7:
		var x := -36.0 + index * 12.0
		var height := 20.0 + sin(_phase * 7.0 + index) * 7.0
		draw_circle(Vector2(x, -height * 0.3), 10.0, Color(1.0, 0.22 + index * 0.04, 0.04, 0.7))
		draw_circle(Vector2(x, -height * 0.6), 6.0, Color(1.0, 0.78, 0.18, 0.82))
	draw_rect(Rect2(-48.0, 5.0, 96.0, 12.0), Color(0.24, 0.04, 0.02, 0.7), true)

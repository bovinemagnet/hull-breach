class_name ExtractionZone
extends Interactable

signal extraction_requested

var active := false


func _ready() -> void:
	super._ready()
	interaction_label = "Extract"
	queue_redraw()


func get_interaction_text(_player: Player) -> String:
	return "Board Extraction Shuttle" if active else "Extraction Unavailable"


func interact(player: Player) -> bool:
	if not active:
		feedback_requested.emit("EXTRACTION NOT YET AUTHORISED")
		return false
	extraction_requested.emit()
	interaction_completed.emit(self, player)
	return true


func set_active(enabled: bool) -> void:
	active = enabled
	queue_redraw()


func _draw() -> void:
	var colour := Color(0.25, 1.0, 0.65, 0.8) if active else Color(0.28, 0.32, 0.34, 0.6)
	draw_arc(Vector2.ZERO, 42.0, 0.0, TAU, 32, colour, 4.0)
	draw_arc(Vector2.ZERO, 30.0, 0.0, TAU, 32, colour, 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(-30.0, 5.0), "EXIT", HORIZONTAL_ALIGNMENT_CENTER, 60.0, 14, colour)

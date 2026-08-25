class_name LegalScreen
extends Control

const DOCUMENTS := [
	"res://THIRD_PARTY_NOTICES.md",
	"res://PRIVACY.md",
]


func _ready() -> void:
	%LegalText.text = _load_documents()
	%BackButton.pressed.connect(_return_to_credits)
	%BackButton.grab_focus()


func _load_documents() -> String:
	var sections := PackedStringArray()
	for path in DOCUMENTS:
		var file := FileAccess.open(path, FileAccess.READ)
		sections.append(file.get_as_text() if file != null else "Required legal document unavailable: %s" % path)
	return "\n\n────────────────────────\n\n".join(sections)


func _return_to_credits() -> void:
	var session := get_node_or_null("/root/GameSession") as GameSessionState
	if session != null:
		session.transition_to_scene("res://ui/credits/credits.tscn")
	else:
		get_tree().change_scene_to_file("res://ui/credits/credits.tscn")

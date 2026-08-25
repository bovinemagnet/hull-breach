class_name CredentialPickup
extends Interactable

signal credential_collected(credential_id: StringName)

@export var credential: AccessCredential
var collected := false


func _ready() -> void:
	super._ready()
	assert(credential != null, "AccessCredential is required")
	interaction_label = "Collect %s" % credential.display_name
	queue_redraw()


func can_interact(_player: Player) -> bool:
	return not collected


func interact(player: Player) -> bool:
	if collected or not player.access_inventory.grant(credential.id):
		return false
	collected = true
	credential_collected.emit(credential.id)
	feedback_requested.emit("%s ACQUIRED" % credential.display_name.to_upper())
	interaction_completed.emit(self, player)
	hide()
	set_deferred(&"monitorable", false)
	return true


func restore_collected(was_collected: bool) -> void:
	collected = was_collected
	visible = not collected
	monitorable = not collected


func _draw() -> void:
	draw_rect(Rect2(-13.0, -9.0, 26.0, 18.0), Color(0.12, 0.18, 0.2), true)
	draw_rect(Rect2(-10.0, -6.0, 20.0, 12.0), Color(1.0, 0.68, 0.18), true)
	draw_circle(Vector2(6.0, 0.0), 2.5, Color(0.08, 0.1, 0.1))

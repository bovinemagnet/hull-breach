class_name ItemPickup
extends Interactable

signal item_collected(item_id: StringName, quantity: int)

@export var definition: ItemDefinition
@export_range(1, 1000, 1) var quantity := 1
var collected := false


func _ready() -> void:
	super._ready()
	assert(definition != null and definition.validation_errors().is_empty(), "ItemDefinition is invalid")
	interaction_label = "Collect %s" % definition.display_name
	queue_redraw()


func can_interact(_player: Player) -> bool:
	return not collected


func interact(player: Player) -> bool:
	if collected or not _grant(player):
		return false
	collected = true
	item_collected.emit(definition.id, quantity)
	feedback_requested.emit("%s ACQUIRED" % definition.display_name.to_upper())
	interaction_completed.emit(self, player)
	hide()
	set_deferred(&"monitorable", false)
	return true


func restore_collected(value: bool) -> void:
	collected = value
	visible = not value
	monitorable = not value


func _grant(player: Player) -> bool:
	var granted_quantity := _difficulty_adjusted_quantity()
	match definition.kind:
		ItemDefinition.Kind.HEALTH:
			if player.health_component.current_health >= player.health_component.maximum_health:
				return false
			player.health_component.heal(float(granted_quantity))
			return true
		ItemDefinition.Kind.AMMO:
			return player.weapon_inventory.add_ammo(definition.ammo_type, granted_quantity) > 0
		ItemDefinition.Kind.WEAPON:
			return player.weapon_inventory.add_weapon_scene(definition.weapon_scene)
		ItemDefinition.Kind.CREDENTIAL:
			return player.access_inventory.grant(definition.credential_id)
	return false


func _difficulty_adjusted_quantity() -> int:
	var session: Node = get_node_or_null("/root/GameSession")
	if session == null or not session.get("difficulty") is DifficultyDefinition:
		return quantity
	var profile := session.get("difficulty") as DifficultyDefinition
	if definition.kind == ItemDefinition.Kind.AMMO:
		return DifficultyService.effective_ammo(quantity, profile)
	if definition.kind == ItemDefinition.Kind.HEALTH:
		return maxi(1, int(round(quantity * profile.health_pickup_multiplier)))
	return quantity


func _draw() -> void:
	draw_circle(Vector2.ZERO, 17.0, Color(0.18, 0.8, 0.65, 0.16))
	draw_rect(Rect2(-12.0, -9.0, 24.0, 18.0), Color(0.08, 0.18, 0.2), true)
	draw_rect(Rect2(-8.0, -5.0, 16.0, 10.0), Color(0.3, 0.95, 0.78), true)

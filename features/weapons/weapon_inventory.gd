class_name WeaponInventory
extends Node

signal current_weapon_changed(weapon: Weapon, slot: int)
signal loadout_changed
signal noise_requested(event: NoiseEvent)

const WEAPON_CATALOG := {
	&"sidearm": "res://features/weapons/sidearm/sidearm.tscn",
	&"hb4_pulse_rifle": "res://features/weapons/pulse_rifle/pulse_rifle.tscn",
	&"shotgun": "res://features/weapons/shotgun/shotgun.tscn",
	&"plasma_cutter": "res://features/weapons/plasma_cutter/plasma_cutter.tscn",
	&"incinerator": "res://features/weapons/incinerator/incinerator.tscn",
}

@export_range(1, 5, 1) var maximum_slots := 5
@export var weapon_container_path := NodePath("../WeaponPivot")
@export var starting_weapon_id: StringName = &"hb4_pulse_rifle"

var weapons: Array[Weapon] = []
var current_slot := 0


func collect_weapons() -> void:
	weapons.clear()
	var container := get_node(weapon_container_path)
	for child in container.get_children():
		if child is Weapon:
			_register_weapon(child as Weapon)
	weapons.sort_custom(func(left: Weapon, right: Weapon) -> bool: return left.definition.preferred_slot < right.definition.preferred_slot)
	current_slot = clampi(current_slot, 0, maxi(0, weapons.size() - 1))
	for index in weapons.size():
		if weapons[index].definition.id == starting_weapon_id:
			current_slot = index
			break
	_update_visibility()
	loadout_changed.emit()


func add_weapon_scene(scene: PackedScene) -> bool:
	if scene == null:
		return false
	var weapon := scene.instantiate() as Weapon
	if weapon == null:
		return false
	for existing in weapons:
		if existing.definition.id == weapon.definition.id:
			weapon.queue_free()
			return false
	if weapons.size() >= maximum_slots:
		weapon.queue_free()
		return false
	get_node(weapon_container_path).add_child(weapon)
	_register_weapon(weapon)
	weapons.sort_custom(func(left: Weapon, right: Weapon) -> bool: return left.definition.preferred_slot < right.definition.preferred_slot)
	current_slot = weapons.find(weapon)
	_update_visibility()
	loadout_changed.emit()
	current_weapon_changed.emit(current_weapon(), current_slot)
	return true


func current_weapon() -> Weapon:
	if weapons.is_empty():
		return null
	return weapons[current_slot]


func cycle(direction: int) -> Weapon:
	if weapons.size() <= 1:
		return current_weapon()
	var previous := current_weapon()
	if previous != null:
		previous.stop_actions()
	current_slot = posmod(current_slot + direction, weapons.size())
	_update_visibility()
	current_weapon_changed.emit(current_weapon(), current_slot)
	return current_weapon()


func select_slot(slot: int) -> Weapon:
	if slot < 0 or slot >= weapons.size() or slot == current_slot:
		return current_weapon()
	var previous := current_weapon()
	if previous != null:
		previous.stop_actions()
	current_slot = slot
	_update_visibility()
	current_weapon_changed.emit(current_weapon(), current_slot)
	return current_weapon()


func add_ammo(ammo_type: StringName, amount: int) -> int:
	var accepted := 0
	for weapon in weapons:
		if weapon.definition.ammo_type == ammo_type:
			accepted += weapon.add_reserve_ammo(amount)
	return accepted


func refill_all() -> void:
	for weapon in weapons:
		weapon.refill_ammunition()


func snapshot() -> Dictionary:
	var states := {}
	for weapon in weapons:
		states[String(weapon.definition.id)] = {
			"magazine": weapon.current_magazine,
			"reserve": weapon.reserve_ammo,
		}
	return {"current_slot": current_slot, "weapons": states}


func restore(data: Dictionary) -> void:
	var states: Dictionary = data.get("weapons", {})
	for weapon_id in states:
		if _find_weapon(StringName(weapon_id)) == null and WEAPON_CATALOG.has(StringName(weapon_id)):
			add_weapon_scene(load(WEAPON_CATALOG[StringName(weapon_id)]) as PackedScene)
	for weapon in weapons:
		var state: Dictionary = states.get(String(weapon.definition.id), {})
		if not state.is_empty():
			weapon.current_magazine = int(state.get("magazine", weapon.current_magazine))
			weapon.reserve_ammo = int(state.get("reserve", weapon.reserve_ammo))
			weapon.ammo_changed.emit(weapon.current_magazine, weapon.reserve_ammo)
	current_slot = clampi(int(data.get("current_slot", current_slot)), 0, maxi(0, weapons.size() - 1))
	_update_visibility()
	current_weapon_changed.emit(current_weapon(), current_slot)


func _find_weapon(id: StringName) -> Weapon:
	for weapon in weapons:
		if weapon.definition.id == id:
			return weapon
	return null


func _register_weapon(weapon: Weapon) -> void:
	if weapons.has(weapon):
		return
	weapons.append(weapon)
	weapon.noise_requested.connect(func(event: NoiseEvent) -> void: noise_requested.emit(event))


func _update_visibility() -> void:
	for index in weapons.size():
		weapons[index].visible = index == current_slot
		weapons[index].process_mode = Node.PROCESS_MODE_INHERIT if index == current_slot else Node.PROCESS_MODE_DISABLED

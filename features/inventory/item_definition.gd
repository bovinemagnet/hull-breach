class_name ItemDefinition
extends Resource

enum Kind { HEALTH, AMMO, WEAPON, CREDENTIAL }

@export var id: StringName
@export var display_name := "Item"
@export var kind := Kind.AMMO
@export var ammo_type: StringName
@export var weapon_scene: PackedScene
@export var credential_id: StringName


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if id.is_empty():
		errors.append("id must not be empty")
	if display_name.is_empty():
		errors.append("display_name must not be empty")
	if kind == Kind.AMMO and ammo_type.is_empty():
		errors.append("ammo item requires ammo_type")
	if kind == Kind.WEAPON and weapon_scene == null:
		errors.append("weapon item requires weapon_scene")
	if kind == Kind.CREDENTIAL and credential_id.is_empty():
		errors.append("credential item requires credential_id")
	return errors

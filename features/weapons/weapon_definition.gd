class_name WeaponDefinition
extends Resource

@export var id: StringName = &"weapon"
@export var display_name: String = "Weapon"
@export_range(0.0, 10000.0, 0.1) var damage: float = 10.0
@export_range(0.0, 100.0, 0.1) var rounds_per_second: float = 5.0
@export_range(0, 1000, 1) var magazine_size: int = 30
@export_range(0, 10000, 1) var reserve_ammo: int = 120
@export_range(0.0, 30.0, 0.05) var reload_duration: float = 1.5
@export_range(0.0, 5000.0, 1.0) var projectile_speed: float = 600.0
@export_range(0.0, 10.0, 0.05) var projectile_lifetime: float = 1.5
@export_range(0.0, 45.0, 0.1) var spread_degrees: float = 0.0
@export_range(0, 32, 1) var projectiles_per_shot: int = 1
@export var automatic: bool = true


func validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()
	if damage <= 0.0:
		errors.append("damage must be greater than zero")
	if rounds_per_second <= 0.0:
		errors.append("rounds_per_second must be greater than zero")
	if magazine_size <= 0:
		errors.append("magazine_size must be greater than zero")
	if reserve_ammo < 0:
		errors.append("reserve_ammo cannot be negative")
	if reload_duration < 0.0:
		errors.append("reload_duration cannot be negative")
	if projectile_speed <= 0.0:
		errors.append("projectile_speed must be greater than zero")
	if projectile_lifetime <= 0.0:
		errors.append("projectile_lifetime must be greater than zero")
	if projectiles_per_shot < 1:
		errors.append("projectiles_per_shot must be at least one")
	return errors


func is_valid() -> bool:
	return validation_errors().is_empty()

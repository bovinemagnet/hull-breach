class_name DifficultyService
extends RefCounted

const PROFILES := {
	&"explorer": "res://resources/difficulty/explorer.tres",
	&"standard": "res://resources/difficulty/standard.tres",
	&"survivor": "res://resources/difficulty/survivor.tres",
}


static func load_profile(id: StringName) -> DifficultyDefinition:
	var path: String = PROFILES.get(id, PROFILES[&"standard"])
	return load(path) as DifficultyDefinition


static func effective_enemy_health(base_value: float, profile: DifficultyDefinition) -> float:
	return base_value * profile.enemy_health_multiplier


static func effective_enemy_damage(base_value: float, profile: DifficultyDefinition) -> float:
	return base_value * profile.enemy_damage_multiplier


static func effective_ammo(base_value: int, profile: DifficultyDefinition) -> int:
	return maxi(1, int(round(base_value * profile.ammo_quantity_multiplier)))

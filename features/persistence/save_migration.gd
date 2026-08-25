class_name SaveMigration
extends RefCounted

const CURRENT_SCHEMA_VERSION := 1


static func migrate(data: Dictionary) -> Dictionary:
	var schema_version := int(data.get("schema_version", 0))
	if schema_version > CURRENT_SCHEMA_VERSION:
		return {}
	var migrated := data.duplicate(true)
	while schema_version < CURRENT_SCHEMA_VERSION:
		match schema_version:
			0:
				migrated = _migrate_zero_to_one(migrated)
			_:
				return {}
		schema_version += 1
	migrated.schema_version = CURRENT_SCHEMA_VERSION
	return migrated


static func _migrate_zero_to_one(data: Dictionary) -> Dictionary:
	var migrated := data.duplicate(true)
	if not migrated.has("profile"):
		migrated.profile = {"difficulty": "standard"}
	if not migrated.has("campaign"):
		migrated.campaign = {"completed_missions": [], "current_mission": "station_blackout"}
	if not migrated.has("active_mission"):
		migrated.active_mission = {}
	return migrated

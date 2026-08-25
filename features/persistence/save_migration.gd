class_name SaveMigration
extends RefCounted

const CURRENT_SCHEMA_VERSION := 3


static func migrate(data: Dictionary) -> Dictionary:
	var schema_version := int(data.get("schema_version", 0))
	if schema_version > CURRENT_SCHEMA_VERSION:
		return {}
	var migrated := data.duplicate(true)
	while schema_version < CURRENT_SCHEMA_VERSION:
		match schema_version:
			0:
				migrated = _migrate_zero_to_one(migrated)
			1:
				migrated = _migrate_one_to_two(migrated)
			2:
				migrated = _migrate_two_to_three(migrated)
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


static func _migrate_one_to_two(data: Dictionary) -> Dictionary:
	var migrated := data.duplicate(true)
	var campaign: Dictionary = migrated.get("campaign", {})
	campaign.campaign_complete = bool(campaign.get("campaign_complete", false))
	campaign.loadout = campaign.get("loadout", {})
	migrated.campaign = campaign
	return migrated


static func _migrate_two_to_three(data: Dictionary) -> Dictionary:
	var migrated := data.duplicate(true)
	var campaign: Dictionary = migrated.get("campaign", {})
	campaign.completed_missions = Array(campaign.get("completed_missions", []))
	campaign.current_mission = String(campaign.get("current_mission", "station_blackout"))
	campaign.campaign_complete = bool(campaign.get("campaign_complete", false))
	campaign.loadout = campaign.get("loadout", {}) if campaign.get("loadout", {}) is Dictionary else {}
	migrated.campaign = campaign
	migrated.metadata = migrated.get("metadata", {}) if migrated.get("metadata", {}) is Dictionary else {}
	return migrated

class_name CampaignCatalog
extends RefCounted

const MISSION_IDS: Array[StringName] = [
	&"station_blackout",
	&"medical_wing",
	&"cargo_deck",
	&"research_sector",
	&"engineering_complex",
	&"reactor_core",
	&"hive",
	&"evacuation",
]

const MISSION_NAMES := {
	&"station_blackout": "Station Blackout",
	&"medical_wing": "Medical Wing",
	&"cargo_deck": "Cargo Deck",
	&"research_sector": "Research Sector",
	&"engineering_complex": "Engineering Complex",
	&"reactor_core": "Reactor Core",
	&"hive": "The Hive",
	&"evacuation": "Evacuation",
}

const MISSION_SCENES := {
	&"station_blackout": "res://levels/campaign/station_blackout/station_blackout.tscn",
	&"medical_wing": "res://levels/campaign/medical_wing/medical_wing.tscn",
	&"cargo_deck": "res://levels/campaign/cargo_deck/cargo_deck.tscn",
	&"research_sector": "res://levels/campaign/research_sector/research_sector.tscn",
	&"engineering_complex": "res://levels/campaign/engineering_complex/engineering_complex.tscn",
	&"reactor_core": "res://levels/campaign/reactor_core/reactor_core.tscn",
	&"hive": "res://levels/campaign/hive/hive.tscn",
	&"evacuation": "res://levels/campaign/evacuation/evacuation.tscn",
}


static func scene_for(mission_id: StringName) -> String:
	return MISSION_SCENES.get(mission_id, "")


static func next_after(mission_id: StringName) -> StringName:
	var index := MISSION_IDS.find(mission_id)
	if index < 0 or index + 1 >= MISSION_IDS.size():
		return &""
	return MISSION_IDS[index + 1]


static func is_valid_mission(mission_id: StringName) -> bool:
	return MISSION_SCENES.has(mission_id)


static func unlocked_from(completed: Array) -> Array[StringName]:
	var unlocked: Array[StringName] = [&"station_blackout"]
	for mission_id in MISSION_IDS:
		if not completed.has(String(mission_id)):
			break
		var next_id := next_after(mission_id)
		if not next_id.is_empty() and not unlocked.has(next_id):
			unlocked.append(next_id)
	return unlocked

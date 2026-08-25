extends GdUnitTestSuite

const PROFILE_PATHS := [
	"res://levels/campaign/cargo_deck/cargo_deck_profile.tres",
	"res://levels/campaign/research_sector/research_sector_profile.tres",
	"res://levels/campaign/engineering_complex/engineering_complex_profile.tres",
	"res://levels/campaign/reactor_core/reactor_core_profile.tres",
	"res://levels/campaign/hive/hive_profile.tres",
	"res://levels/campaign/evacuation/evacuation_profile.tres",
]


func test_phase_four_profiles_are_valid_and_have_unique_objectives() -> void:
	var mission_ids := {}
	for path in PROFILE_PATHS:
		var profile := load(path) as CampaignMissionProfile
		assert_object(profile).is_not_null()
		assert_array(Array(profile.validation_errors())).is_empty()
		assert_bool(mission_ids.has(profile.mission_id)).is_false()
		mission_ids[profile.mission_id] = true
		var objective_ids := {}
		for objective_id in profile.mission_definition.objective_ids:
			assert_bool(objective_ids.has(objective_id)).is_false()
			objective_ids[objective_id] = true


func test_enemy_and_weapon_alpha_rosters_validate() -> void:
	for path in [
		"res://features/enemies/swarm/swarm.tres",
		"res://features/enemies/stalker/stalker.tres",
		"res://features/enemies/brute/brute.tres",
		"res://features/enemies/brood_entity/brood_entity.tres",
	]:
		assert_bool((load(path) as EnemyDefinition).is_valid()).is_true()
	for path in [
		"res://features/weapons/plasma_cutter/plasma_cutter.tres",
		"res://features/weapons/incinerator/incinerator.tres",
	]:
		assert_bool((load(path) as WeaponDefinition).is_valid()).is_true()
	assert_int(WeaponInventory.WEAPON_CATALOG.size()).is_equal(5)

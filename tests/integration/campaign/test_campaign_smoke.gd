extends GdUnitTestSuite


func test_every_campaign_scene_instantiates() -> void:
	for mission_id in CampaignCatalog.MISSION_IDS:
		CheckpointManager.clear_pending()
		var packed := load(CampaignCatalog.scene_for(mission_id)) as PackedScene
		assert_object(packed).is_not_null()
		var mission_scene: Node = auto_free(packed.instantiate()) as Node
		assert_object(mission_scene).is_not_null()


func test_phase_four_missions_boot_with_essential_systems() -> void:
	for mission_id in CampaignCatalog.MISSION_IDS.slice(2):
		CheckpointManager.clear_pending()
		var packed := load(CampaignCatalog.scene_for(mission_id)) as PackedScene
		var mission_scene := auto_free(packed.instantiate()) as CampaignContentMission
		add_child(mission_scene)
		await await_idle_frame()
		assert_object(mission_scene.player).is_not_null()
		assert_object(mission_scene.mission).is_not_null()
		assert_object(mission_scene.checkpoint_manager).is_not_null()
		assert_str(String(mission_scene.profile.mission_id)).is_equal(String(mission_id))
		mission_scene.queue_free()
		await await_idle_frame()


func test_campaign_logic_can_advance_from_new_game_to_credits() -> void:
	var completed: Array = []
	for mission_id in CampaignCatalog.MISSION_IDS:
		var unlocked := CampaignCatalog.unlocked_from(completed)
		assert_bool(unlocked.has(mission_id)).is_true()
		completed.append(String(mission_id))
	assert_str(String(CampaignCatalog.next_after(&"evacuation"))).is_empty()

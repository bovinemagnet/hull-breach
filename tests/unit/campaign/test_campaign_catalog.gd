extends GdUnitTestSuite


func test_campaign_contains_eight_ordered_unique_missions() -> void:
	assert_int(CampaignCatalog.MISSION_IDS.size()).is_equal(8)
	var unique := {}
	for mission_id in CampaignCatalog.MISSION_IDS:
		unique[mission_id] = true
		assert_bool(ResourceLoader.exists(CampaignCatalog.scene_for(mission_id))).is_true()
	assert_int(unique.size()).is_equal(8)
	assert_str(String(CampaignCatalog.next_after(&"station_blackout"))).is_equal("medical_wing")
	assert_str(String(CampaignCatalog.next_after(&"evacuation"))).is_empty()


func test_completion_unlocks_campaign_in_order() -> void:
	var completed: Array = []
	for index in CampaignCatalog.MISSION_IDS.size():
		var unlocked := CampaignCatalog.unlocked_from(completed)
		assert_bool(unlocked.has(CampaignCatalog.MISSION_IDS[index])).is_true()
		if index + 1 < CampaignCatalog.MISSION_IDS.size():
			assert_bool(unlocked.has(CampaignCatalog.MISSION_IDS[index + 1])).is_false()
		completed.append(String(CampaignCatalog.MISSION_IDS[index]))
	assert_int(CampaignCatalog.unlocked_from(completed).size()).is_equal(8)

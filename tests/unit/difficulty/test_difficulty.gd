extends GdUnitTestSuite


func test_profiles_are_valid_and_ordered_by_damage() -> void:
	var explorer := DifficultyService.load_profile(&"explorer")
	var standard := DifficultyService.load_profile(&"standard")
	var survivor := DifficultyService.load_profile(&"survivor")
	assert_array(explorer.validation_errors()).is_empty()
	assert_array(standard.validation_errors()).is_empty()
	assert_array(survivor.validation_errors()).is_empty()
	assert_float(explorer.enemy_damage_multiplier).is_less(standard.enemy_damage_multiplier)
	assert_float(survivor.enemy_damage_multiplier).is_greater(standard.enemy_damage_multiplier)


func test_ammo_budget_uses_profile_multiplier() -> void:
	assert_int(DifficultyService.effective_ammo(10, DifficultyService.load_profile(&"explorer"))).is_equal(14)
	assert_int(DifficultyService.effective_ammo(10, DifficultyService.load_profile(&"survivor"))).is_equal(8)

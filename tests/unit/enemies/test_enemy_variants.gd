extends GdUnitTestSuite


func test_all_phase_three_enemy_scenes_instantiate_with_shared_components() -> void:
	for path in ["res://features/enemies/drone/drone.tscn", "res://features/enemies/hunter/hunter.tscn", "res://features/enemies/spitter/spitter.tscn"]:
		var packed := load(path) as PackedScene
		var enemy := auto_free(packed.instantiate()) as Drone
		assert_object(enemy).is_not_null()
		assert_object(enemy.get_node("Perception")).is_instanceof(EnemyPerceptionComponent)
		assert_object(enemy.get_node("NavigationAgent2D")).is_instanceof(EnemyNavigationComponent)
		assert_object(enemy.get_node("MeleeAttack")).is_instanceof(MeleeAttack)


func test_spitter_maintains_preferred_range() -> void:
	var definition := load("res://features/enemies/spitter/spitter.tres") as EnemyDefinition
	assert_bool(definition.is_valid()).is_true()
	assert_float(definition.preferred_minimum_range).is_greater(0.0)
	assert_float(definition.attack_range).is_greater(definition.preferred_minimum_range)

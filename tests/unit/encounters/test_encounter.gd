extends GdUnitTestSuite


func test_wave_spawns_configured_count_and_completes_after_deaths() -> void:
	var enemy_parent := auto_free(Node2D.new()) as Node2D
	add_child(enemy_parent)
	var target := auto_free(Node2D.new()) as Node2D
	add_child(target)
	var point := auto_free(EnemySpawnPoint.new()) as EnemySpawnPoint
	point.id = &"test"
	add_child(point)
	var wave := WaveDefinition.new()
	wave.spawn_point_ids = PackedStringArray(["test"])
	wave.enemy_scenes.append(load("res://features/enemies/drone/drone.tscn") as PackedScene)
	wave.counts = PackedInt32Array([2])
	wave.spawn_interval = 0.0
	var definition := EncounterDefinition.new()
	definition.id = &"test_encounter"
	definition.waves.append(wave)
	var encounter := auto_free(Encounter.new()) as Encounter
	encounter.definition = definition
	encounter.configure([point], enemy_parent, target)
	add_child(encounter)
	assert_bool(encounter.start()).is_true()
	encounter.advance(0.1)
	assert_int(encounter.living_count()).is_equal(2)
	for enemy in enemy_parent.get_children():
		if enemy is Drone:
			(enemy as Drone).receive_damage(DamageInfo.new(1000.0))
	encounter.advance(0.1)
	assert_bool(encounter.is_complete).is_true()

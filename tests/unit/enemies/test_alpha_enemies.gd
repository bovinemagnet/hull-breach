extends GdUnitTestSuite


func test_stalker_reports_light_reluctance() -> void:
	var stalker := auto_free(Stalker.new()) as Stalker
	stalker.current_illumination = 0.8
	assert_bool(stalker.is_light_reluctant()).is_true()
	stalker.current_illumination = 0.2
	assert_bool(stalker.is_light_reluctant()).is_false()


func test_brute_front_armour_reduces_damage() -> void:
	var packed := load("res://features/enemies/brute/brute.tscn") as PackedScene
	var brute := auto_free(packed.instantiate()) as Brute
	var target := auto_free(Node2D.new()) as Node2D
	target.position = Vector2(100, 0)
	brute.set_target(target)
	add_child(target)
	add_child(brute)
	await await_idle_frame()
	var starting_health := brute.health_component.current_health
	brute.rotation = 0.0
	brute.receive_damage(DamageInfo.new(100.0, target, brute.position, Vector2.LEFT))
	assert_float(brute.health_component.current_health).is_equal(starting_health - 30.0)


func test_brood_entity_exposes_core_in_final_phase() -> void:
	var packed := load("res://features/enemies/brood_entity/brood_entity.tscn") as PackedScene
	var brood := auto_free(packed.instantiate()) as BroodEntity
	add_child(brood)
	await await_idle_frame()
	brood.receive_damage(DamageInfo.new(300.0))
	assert_int(brood.phase).is_equal(3)
	assert_bool(brood.is_core_exposed()).is_true()

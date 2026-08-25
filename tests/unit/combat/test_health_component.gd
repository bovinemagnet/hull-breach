extends GdUnitTestSuite


func _new_health(maximum: float = 100.0) -> HealthComponent:
	var health := auto_free(HealthComponent.new()) as HealthComponent
	health.maximum_health = maximum
	health.reset()
	return health


func test_health_initialises_to_maximum() -> void:
	var health := _new_health(125.0)
	assert_float(health.current_health).is_equal(125.0)
	assert_float(health.health_ratio()).is_equal(1.0)


func test_damage_reduces_health_and_clamps_at_zero() -> void:
	var health := _new_health()
	health.apply_damage(DamageInfo.new(35.0))
	assert_float(health.current_health).is_equal(65.0)
	health.apply_damage(DamageInfo.new(100.0))
	assert_float(health.current_health).is_equal(0.0)
	assert_bool(health.is_dead).is_true()


func test_negative_damage_is_ignored() -> void:
	var health := _new_health()
	health.apply_damage(DamageInfo.new(-10.0))
	assert_float(health.current_health).is_equal(100.0)


func test_healing_cannot_exceed_maximum() -> void:
	var health := _new_health()
	health.apply_damage(DamageInfo.new(20.0))
	health.heal(50.0)
	assert_float(health.current_health).is_equal(100.0)


func test_death_emits_exactly_once() -> void:
	var health := _new_health()
	var death_count: Array[int] = [0]
	health.died.connect(func() -> void: death_count[0] += 1)
	health.apply_damage(DamageInfo.new(100.0))
	health.apply_damage(DamageInfo.new(100.0))
	assert_int(death_count[0]).is_equal(1)


func test_reset_restores_dead_component() -> void:
	var health := _new_health()
	health.apply_damage(DamageInfo.new(100.0))
	health.reset()
	assert_bool(health.is_dead).is_false()
	assert_float(health.current_health).is_equal(100.0)

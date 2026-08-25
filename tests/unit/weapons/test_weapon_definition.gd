extends GdUnitTestSuite


func test_pulse_rifle_definition_is_valid() -> void:
	var definition := load("res://features/weapons/pulse_rifle/pulse_rifle.tres") as WeaponDefinition
	assert_object(definition).is_not_null()
	assert_bool(definition.is_valid()).is_true()
	assert_float(definition.damage).is_equal(20.0)
	assert_float(1.0 / definition.rounds_per_second).is_equal_approx(0.125, 0.0001)


func test_invalid_definition_reports_all_required_constraints() -> void:
	var definition := WeaponDefinition.new()
	definition.damage = 0.0
	definition.rounds_per_second = 0.0
	definition.magazine_size = 0
	definition.reload_duration = -1.0
	definition.projectile_speed = 0.0
	definition.projectiles_per_shot = 0
	assert_bool(definition.is_valid()).is_false()
	assert_int(definition.validation_errors().size()).is_greater_equal(6)

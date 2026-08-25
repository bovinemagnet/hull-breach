extends GdUnitTestSuite


func test_drone_definition_is_valid() -> void:
	var definition := load("res://features/enemies/drone/drone.tres") as EnemyDefinition
	assert_object(definition).is_not_null()
	assert_bool(definition.is_valid()).is_true()
	assert_float(definition.maximum_health).is_equal(50.0)
	assert_float(definition.attack_damage).is_equal(10.0)


func test_invalid_enemy_definition_fails_validation() -> void:
	var definition := EnemyDefinition.new()
	definition.maximum_health = 0.0
	definition.move_speed = 0.0
	definition.attack_damage = 0.0
	definition.attack_range = 0.0
	definition.detection_range = 0.0
	assert_bool(definition.is_valid()).is_false()
	assert_int(definition.validation_errors().size()).is_equal(5)

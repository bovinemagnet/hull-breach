extends GdUnitTestSuite


func test_bootstrap_scene_loads_and_instantiates() -> void:
	var packed_scene := load("res://levels/dev/bootstrap.tscn") as PackedScene
	assert_object(packed_scene).is_not_null()

	var instance := packed_scene.instantiate()
	auto_free(instance)
	assert_object(instance).is_not_null()

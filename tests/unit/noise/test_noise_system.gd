extends GdUnitTestSuite


func test_only_listener_inside_effective_radius_hears_noise() -> void:
	var system := auto_free(NoiseSystem.new()) as NoiseSystem
	var near_owner := auto_free(Node2D.new()) as Node2D
	near_owner.position = Vector2(90.0, 0.0)
	var near_listener := NoiseListener.new()
	near_owner.add_child(near_listener)
	var far_owner := auto_free(Node2D.new()) as Node2D
	far_owner.position = Vector2(220.0, 0.0)
	var far_listener := NoiseListener.new()
	far_owner.add_child(far_listener)
	system.register_listener(near_listener)
	system.register_listener(far_listener)
	var event := NoiseEvent.new(Vector2.ZERO, 100.0, &"weapon")
	assert_int(system.emit_noise(event)).is_equal(1)
	assert_object(event).is_not_null()
	assert_vector(event.position).is_equal(Vector2.ZERO)


func test_hearing_sensitivity_expands_radius() -> void:
	var listener := auto_free(NoiseListener.new()) as NoiseListener
	listener.hearing_sensitivity = 1.5
	assert_bool(listener.evaluate(NoiseEvent.new(Vector2.ZERO, 100.0, &"test"), Vector2(140.0, 0.0))).is_true()

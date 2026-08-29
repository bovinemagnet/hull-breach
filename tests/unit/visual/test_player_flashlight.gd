extends GdUnitTestSuite


func test_flashlight_cone_starts_at_the_light_node() -> void:
	var scene := load("res://features/player/player.tscn") as PackedScene
	var player := auto_free(scene.instantiate()) as Player
	add_child(player)
	await await_idle_frame()

	var scaled_half_width := player.flashlight.texture.get_width() * player.flashlight.texture_scale * 0.5
	assert_float(player.flashlight.offset.x).is_equal_approx(scaled_half_width, 0.01)
	assert_float(player.flashlight.offset.y).is_equal(0.0)

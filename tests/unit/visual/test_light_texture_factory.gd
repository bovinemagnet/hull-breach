extends GdUnitTestSuite


func test_cone_emits_forward_from_texture_centre() -> void:
	var texture := LightTextureFactory.cone(64, 32)
	var image := texture.get_image()
	var centre := Vector2i(image.get_width() / 2, image.get_height() / 2)

	assert_float(image.get_pixel(centre.x - 1, centre.y).a).is_equal(0.0)
	assert_float(image.get_pixel(centre.x + 1, centre.y).a).is_greater(0.0)
	assert_float(image.get_pixel(image.get_width() - 1, centre.y).a).is_greater(0.0)

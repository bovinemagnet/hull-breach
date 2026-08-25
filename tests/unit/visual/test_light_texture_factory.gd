extends GdUnitTestSuite


func test_cone_apex_sits_on_the_left_edge() -> void:
	var texture := LightTextureFactory.cone(64, 32)
	var image := texture.get_image()
	var centre_y := image.get_height() / 2

	assert_float(image.get_pixel(0, centre_y).a).is_greater(0.9)
	assert_float(image.get_pixel(image.get_width() - 1, centre_y).a).is_greater(0.0)
	assert_float(image.get_pixel(0, 0).a).is_equal(0.0)

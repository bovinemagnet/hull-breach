class_name LightTextureFactory
extends RefCounted


static func radial(size: int = 96) -> ImageTexture:
	var safe_size := maxi(8, size)
	var image := Image.create(safe_size, safe_size, false, Image.FORMAT_RGBA8)
	var centre := Vector2(safe_size, safe_size) * 0.5
	var radius := float(safe_size) * 0.5
	for y in safe_size:
		for x in safe_size:
			var distance := Vector2(x, y).distance_to(centre) / radius
			var alpha := pow(maxf(0.0, 1.0 - distance), 1.8)
			image.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
	return ImageTexture.create_from_image(image)


static func cone(width: int = 192, height: int = 112) -> ImageTexture:
	var safe_width := maxi(16, width)
	var safe_height := maxi(16, height)
	var image := Image.create(safe_width, safe_height, false, Image.FORMAT_RGBA8)
	var origin := Vector2(4.0, float(safe_height) * 0.5)
	var maximum_angle := deg_to_rad(32.0)
	for y in safe_height:
		for x in safe_width:
			var offset := Vector2(x, y) - origin
			var distance_ratio := offset.length() / float(safe_width)
			var angle := absf(offset.angle())
			var angle_fade := clampf(1.0 - (angle / maximum_angle), 0.0, 1.0)
			var distance_fade := pow(maxf(0.0, 1.0 - distance_ratio), 1.3)
			var alpha := angle_fade * distance_fade if offset.x >= 0.0 else 0.0
			image.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
	return ImageTexture.create_from_image(image)

class_name RuntimeLevelBuilder
extends RefCounted


static func create_tile_set(base_colour: Color, line_colour: Color, tile_size := 40) -> TileSet:
	var image := Image.create(tile_size, tile_size, false, Image.FORMAT_RGBA8)
	image.fill(base_colour)
	for pixel in tile_size:
		image.set_pixel(pixel, 0, line_colour)
		image.set_pixel(0, pixel, line_colour)
	image.set_pixel(tile_size / 2, tile_size / 2, line_colour)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = ImageTexture.create_from_image(image)
	atlas.texture_region_size = Vector2i(tile_size, tile_size)
	atlas.create_tile(Vector2i.ZERO)
	var tile_set := TileSet.new()
	tile_set.tile_size = Vector2i(tile_size, tile_size)
	tile_set.add_source(atlas, 0)
	return tile_set


static func add_wall(parent: Node, position: Vector2, size: Vector2) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = position
	body.collision_layer = 1
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = size
	shape.shape = rectangle
	body.add_child(shape)
	parent.add_child(body)
	return body


static func rectangular_navigation(rect: Rect2, inset := 12.0) -> NavigationPolygon:
	var polygon := NavigationPolygon.new()
	polygon.vertices = PackedVector2Array([
		rect.position + Vector2(inset, inset),
		Vector2(rect.end.x - inset, rect.position.y + inset),
		rect.end - Vector2(inset, inset),
		Vector2(rect.position.x + inset, rect.end.y - inset),
	])
	polygon.add_polygon(PackedInt32Array([0, 1, 2, 3]))
	return polygon

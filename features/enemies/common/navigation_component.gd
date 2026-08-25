class_name EnemyNavigationComponent
extends NavigationAgent2D

var update_interval := 0.15
var _update_remaining := 0.0


func direction_to_destination(origin: Vector2, destination: Vector2, delta: float) -> Vector2:
	_update_remaining -= maxf(delta, 0.0)
	if _update_remaining <= 0.0:
		target_position = destination
		_update_remaining = update_interval
	var direction := origin.direction_to(destination)
	if not is_navigation_finished():
		var next_position := get_next_path_position()
		if origin.distance_squared_to(next_position) > 1.0:
			direction = origin.direction_to(next_position)
	return direction

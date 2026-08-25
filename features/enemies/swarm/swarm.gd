class_name Swarm
extends Drone


func _ready() -> void:
	perception_enabled = true
	super._ready()


func _chase_destination(_to_target: Vector2, _distance: float) -> Vector2:
	return target.global_position

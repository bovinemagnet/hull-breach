class_name PlayerConfig
extends Resource

@export_range(1.0, 1000.0, 1.0) var move_speed: float = 180.0
@export_range(1.0, 5000.0, 1.0) var acceleration: float = 1600.0
@export_range(1.0, 5000.0, 1.0) var deceleration: float = 1800.0
@export_range(1.0, 1000.0, 1.0) var maximum_health: float = 100.0
@export_range(0.0, 1.0, 0.01) var controller_aim_deadzone: float = 0.20
@export_range(0.0, 1.0, 0.01) var controller_move_deadzone: float = 0.15
@export_range(0.0, 100.0, 1.0) var camera_look_ahead: float = 42.0

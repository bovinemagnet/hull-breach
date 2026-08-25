class_name DoorDefinition
extends Resource

@export_range(0.05, 5.0, 0.05) var open_duration: float = 0.35
@export var requires_power: bool = false
@export var power_circuit: StringName = &"main"
@export var auto_close: bool = false
@export_range(0.1, 30.0, 0.1) var auto_close_delay: float = 3.0
@export var access_credential: StringName
@export var locked_message: String = "ACCESS DENIED"

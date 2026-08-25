class_name MobileControls
extends CanvasLayer

signal pause_requested

@onready var root: Control = $Root
@onready var move_stick: VirtualStick = %MoveStick
@onready var aim_stick: VirtualStick = %AimStick
var player: Player


func _ready() -> void:
	layer = 5
	root.visible = OS.has_feature("mobile")
	move_stick.vector_changed.connect(func(value: Vector2) -> void: if player != null: player.set_mobile_move(value))
	aim_stick.vector_changed.connect(_on_aim_changed)
	%UseButton.pressed.connect(func() -> void: if player != null: player.mobile_interact())
	%ReloadButton.pressed.connect(func() -> void: if player != null: player.mobile_reload())
	%PauseButton.pressed.connect(func() -> void: pause_requested.emit())


func bind_player(p_player: Player) -> void:
	player = p_player


func toggle_debug_visibility() -> void:
	root.visible = not root.visible


func _on_aim_changed(value: Vector2) -> void:
	if player != null:
		player.set_mobile_aim(value)
		player.set_mobile_firing(value.length() > 0.45)

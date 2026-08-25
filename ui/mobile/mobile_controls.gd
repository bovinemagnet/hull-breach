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
	_apply_safe_area()
	var settings := GameSettings.new()
	var service: Node = get_node_or_null("/root/SettingsService")
	if service != null and service.get("settings") is GameSettings:
		settings = service.get("settings") as GameSettings
	move_stick.scale = Vector2.ONE * settings.mobile_stick_size
	aim_stick.scale = Vector2.ONE * settings.mobile_stick_size
	move_stick.modulate.a = settings.mobile_stick_opacity
	aim_stick.modulate.a = settings.mobile_stick_opacity
	move_stick.vector_changed.connect(func(value: Vector2) -> void: if player != null: player.set_mobile_move(value))
	aim_stick.vector_changed.connect(_on_aim_changed)
	%UseButton.pressed.connect(func() -> void: if player != null: player.mobile_interact())
	%ReloadButton.pressed.connect(func() -> void: if player != null: player.mobile_reload())
	%WeaponButton.pressed.connect(func() -> void: if player != null: player.mobile_cycle_weapon())
	%PauseButton.pressed.connect(func() -> void: pause_requested.emit())
	get_viewport().size_changed.connect(_apply_safe_area)
	var platform := get_node_or_null("/root/PlatformService") as PlatformServiceNode
	if platform != null:
		platform.pause_requested.connect(func(_reason: String) -> void: release_input())


func bind_player(p_player: Player) -> void:
	player = p_player
	player.weapon_changed.connect(func(weapon: Weapon, _slot: int) -> void: %WeaponButton.text = weapon.definition.display_name)
	%WeaponButton.text = player.weapon.definition.display_name


func toggle_debug_visibility() -> void:
	if not OS.is_debug_build():
		return
	root.visible = not root.visible


func release_input() -> void:
	move_stick.release()
	aim_stick.release()
	if player != null:
		player.set_mobile_move(Vector2.ZERO)
		player.set_mobile_aim(Vector2.ZERO)
		player.set_mobile_firing(false)


func _apply_safe_area() -> void:
	if not OS.has_feature("mobile"):
		return
	var window_size := Vector2(DisplayServer.window_get_size())
	if window_size.x <= 0.0 or window_size.y <= 0.0:
		return
	var safe := Rect2(DisplayServer.get_display_safe_area())
	var normalized := Rect2(safe.position / window_size, safe.size / window_size)
	root.anchor_left = clampf(normalized.position.x, 0.0, 1.0)
	root.anchor_top = clampf(normalized.position.y, 0.0, 1.0)
	root.anchor_right = clampf(normalized.end.x, 0.0, 1.0)
	root.anchor_bottom = clampf(normalized.end.y, 0.0, 1.0)
	root.offset_left = 0.0
	root.offset_top = 0.0
	root.offset_right = 0.0
	root.offset_bottom = 0.0


func _on_aim_changed(value: Vector2) -> void:
	if player != null:
		var sensitivity := 1.0
		var service: Node = get_node_or_null("/root/SettingsService")
		if service != null and service.get("settings") is GameSettings:
			sensitivity = (service.get("settings") as GameSettings).touch_sensitivity
		player.set_mobile_aim(value * sensitivity)
		player.set_mobile_firing(value.length() > 0.45)

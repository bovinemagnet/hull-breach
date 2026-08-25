class_name Player
extends CharacterBody2D

signal died
signal invulnerability_changed(enabled: bool)

@export var config: PlayerConfig

@onready var health_component: HealthComponent = $HealthComponent
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var weapon: Weapon = $WeaponPivot/PulseRifle
@onready var camera: Camera2D = $Camera2D
@onready var interaction_detector: InteractionDetector = $InteractionDetector
@onready var access_inventory: AccessInventory = $AccessInventory
@onready var flashlight: PointLight2D = $WeaponPivot/Flashlight

var aim_direction := Vector2.RIGHT
var input_enabled := true
var invulnerable := false
var _controller_aim_active := false
var _mobile_move := Vector2.ZERO
var _mobile_aim := Vector2.ZERO
var _mobile_firing := false
var _damage_flash_remaining := 0.0
var _movement_phase := 0.0
var _damage_audio: AudioStreamPlayer2D
var _death_audio: AudioStreamPlayer2D


func _ready() -> void:
	add_to_group(&"player")
	assert(config != null, "PlayerConfig is required")
	health_component.maximum_health = config.maximum_health
	health_component.reset()
	health_component.damage_received.connect(_on_damage_received)
	health_component.died.connect(_on_died)
	_build_audio()
	flashlight.texture = LightTextureFactory.cone()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_controller_aim_active = false
	elif event is InputEventJoypadMotion and absf(event.axis_value) > config.controller_aim_deadzone:
		if event.axis == JOY_AXIS_RIGHT_X or event.axis == JOY_AXIS_RIGHT_Y:
			_controller_aim_active = true


func _physics_process(delta: float) -> void:
	if not input_enabled:
		velocity = velocity.move_toward(Vector2.ZERO, config.deceleration * delta)
		move_and_slide()
		return

	var move_input := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	if _mobile_move.length() > move_input.length():
		move_input = _mobile_move
	if move_input.length() < config.controller_move_deadzone:
		move_input = Vector2.ZERO
	var target_velocity := move_input * config.move_speed
	var rate := config.acceleration if not move_input.is_zero_approx() else config.deceleration
	velocity = velocity.move_toward(target_velocity, rate * delta)
	move_and_slide()
	if not velocity.is_zero_approx():
		_movement_phase += delta * 10.0
	queue_redraw()


func _process(delta: float) -> void:
	_damage_flash_remaining = maxf(0.0, _damage_flash_remaining - delta)
	if input_enabled:
		_update_aim()
		var wants_fire := (Input.is_action_pressed(&"fire") or _mobile_firing) if weapon.definition.automatic else Input.is_action_just_pressed(&"fire")
		if wants_fire:
			weapon.try_fire(aim_direction, self)
		if Input.is_action_just_pressed(&"reload"):
			weapon.start_reload()
	weapon_pivot.rotation = aim_direction.angle()
	camera.position = camera.position.lerp(aim_direction * config.camera_look_ahead, minf(1.0, delta * 8.0))
	queue_redraw()


func receive_damage(info: DamageInfo) -> void:
	if not invulnerable:
		health_component.apply_damage(info)


func restore_health() -> void:
	health_component.reset()
	input_enabled = true
	queue_redraw()


func refill_ammunition() -> void:
	weapon.refill_ammunition()


func set_invulnerable(enabled: bool) -> void:
	invulnerable = enabled
	invulnerability_changed.emit(invulnerable)
	queue_redraw()


func is_using_controller_aim() -> bool:
	return _controller_aim_active


func set_mobile_move(value: Vector2) -> void:
	_mobile_move = value.limit_length(1.0)


func set_mobile_aim(value: Vector2) -> void:
	_mobile_aim = value.limit_length(1.0)
	if _mobile_aim.length() >= config.controller_aim_deadzone:
		aim_direction = _mobile_aim.normalized()
		_controller_aim_active = true


func set_mobile_firing(enabled: bool) -> void:
	_mobile_firing = enabled


func mobile_interact() -> void:
	interaction_detector.interact_current()


func mobile_reload() -> void:
	weapon.start_reload()


func _update_aim() -> void:
	if _mobile_aim.length() >= config.controller_aim_deadzone:
		aim_direction = _mobile_aim.normalized()
		return
	var controller_aim := Input.get_vector(&"aim_left", &"aim_right", &"aim_up", &"aim_down")
	if controller_aim.length() >= config.controller_aim_deadzone:
		aim_direction = controller_aim.normalized()
		_controller_aim_active = true
	elif not _controller_aim_active:
		var mouse_direction := get_global_mouse_position() - global_position
		if mouse_direction.length_squared() > 1.0:
			aim_direction = mouse_direction.normalized()


func _on_damage_received(_amount: float) -> void:
	_damage_flash_remaining = 0.12
	if _damage_audio != null:
		_damage_audio.play()
	queue_redraw()


func _on_died() -> void:
	input_enabled = false
	weapon.stop_actions()
	if _death_audio != null:
		_death_audio.play()
	died.emit()
	queue_redraw()


func _build_audio() -> void:
	_damage_audio = AudioStreamPlayer2D.new()
	_damage_audio.bus = &"SFX"
	_damage_audio.stream = ToneFactory.create_tone(95.0, 0.11, 0.22)
	add_child(_damage_audio)
	_death_audio = AudioStreamPlayer2D.new()
	_death_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	_death_audio.bus = &"SFX"
	_death_audio.stream = ToneFactory.create_tone(52.0, 0.38, 0.24)
	add_child(_death_audio)


func _exit_tree() -> void:
	for audio in [_damage_audio, _death_audio]:
		if is_instance_valid(audio):
			audio.stop()
			audio.stream = null


func _draw() -> void:
	var body_colour := Color(0.95, 0.98, 1.0) if _damage_flash_remaining > 0.0 else Color(0.18, 0.72, 0.78)
	if health_component != null and health_component.is_dead:
		body_colour = Color(0.2, 0.24, 0.27)
	elif invulnerable:
		body_colour = Color(0.35, 1.0, 0.55)
	var bob := sin(_movement_phase) * 1.2 if not velocity.is_zero_approx() else 0.0
	draw_circle(Vector2(0.0, bob), 13.0, Color(0.03, 0.09, 0.12))
	draw_circle(Vector2(0.0, bob), 10.0, body_colour)
	draw_line(Vector2(0.0, bob), aim_direction * 17.0, Color(0.8, 1.0, 1.0), 3.0)
	draw_arc(aim_direction * 56.0, 5.0, 0.0, TAU, 12, Color(0.65, 1.0, 0.92, 0.8), 1.5)

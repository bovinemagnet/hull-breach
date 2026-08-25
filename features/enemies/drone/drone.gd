class_name Drone
extends CharacterBody2D

signal died(drone: Drone)

enum State { IDLE, INVESTIGATE, SEARCH, CHASE, ATTACK, DEAD }

@export var definition: EnemyDefinition
@export var perception_enabled := false

@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var noise_listener: NoiseListener = $NoiseListener

var target: Node2D
var state := State.IDLE
var _attack_timer: AttackTimer
var _windup_remaining := 0.0
var _hit_flash_remaining := 0.0
var _death_progress := 0.0
var _knockback := Vector2.ZERO
var _avoidance_remaining := 0.0
var _avoidance_direction := Vector2.ZERO
var _investigation_position := Vector2.ZERO
var _search_remaining := 0.0
var _navigation_update_remaining := 0.0
var _hit_audio: AudioStreamPlayer2D
var _attack_audio: AudioStreamPlayer2D
var _death_audio: AudioStreamPlayer2D


func _ready() -> void:
	add_to_group(&"enemies")
	assert(definition != null and definition.is_valid(), "EnemyDefinition is invalid")
	health_component.maximum_health = definition.maximum_health
	health_component.reset()
	health_component.damage_received.connect(_on_damage_received)
	health_component.died.connect(_on_died)
	_attack_timer = AttackTimer.new(definition.attack_cooldown)
	noise_listener.hearing_sensitivity = definition.hearing_sensitivity
	noise_listener.noise_heard.connect(_on_noise_heard)
	navigation_agent.velocity_computed.connect(_on_navigation_velocity_computed)
	_build_audio()
	queue_redraw()


func set_target(p_target: Node2D) -> void:
	target = p_target


func hear_noise(event: NoiseEvent) -> void:
	noise_listener.evaluate(event, global_position)


func can_see_target() -> bool:
	if not is_instance_valid(target):
		return false
	if global_position.distance_to(target.global_position) > definition.vision_range:
		return false
	var query := PhysicsRayQueryParameters2D.create(global_position, target.global_position, 1)
	query.exclude = [get_rid()]
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()


func receive_damage(info: DamageInfo) -> void:
	if state == State.DEAD:
		return
	_knockback += info.direction * 72.0
	health_component.apply_damage(info)


func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	_attack_timer.advance(delta)
	_hit_flash_remaining = maxf(0.0, _hit_flash_remaining - delta)
	_knockback = _knockback.move_toward(Vector2.ZERO, 240.0 * delta)
	_avoidance_remaining = maxf(0.0, _avoidance_remaining - delta)

	if not is_instance_valid(target) and state not in [State.INVESTIGATE, State.SEARCH]:
		state = State.IDLE
		velocity = _knockback
		move_and_slide()
		queue_redraw()
		return

	if perception_enabled and state in [State.IDLE, State.INVESTIGATE, State.SEARCH] and can_see_target():
		state = State.CHASE

	if perception_enabled and state == State.INVESTIGATE:
		_move_to(_investigation_position, delta)
		if global_position.distance_to(_investigation_position) <= 24.0:
			state = State.SEARCH
			_search_remaining = definition.search_duration
		queue_redraw()
		return
	if perception_enabled and state == State.SEARCH:
		_search_remaining = maxf(0.0, _search_remaining - delta)
		velocity = _knockback
		move_and_slide()
		rotation += delta * 1.8
		if is_zero_approx(_search_remaining):
			state = State.IDLE
		queue_redraw()
		return

	var to_target := target.global_position - global_position
	var distance := to_target.length()
	if distance > definition.detection_range or (perception_enabled and not can_see_target() and state == State.IDLE):
		state = State.IDLE
		velocity = _knockback
	elif _windup_remaining > 0.0:
		state = State.ATTACK
		velocity = _knockback
		_windup_remaining = maxf(0.0, _windup_remaining - delta)
		if is_zero_approx(_windup_remaining):
			_apply_attack_if_in_range()
	elif distance <= definition.attack_range:
		state = State.ATTACK
		velocity = _knockback
		if _attack_timer.try_consume():
			_windup_remaining = definition.attack_windup
	else:
		state = State.CHASE
		if perception_enabled:
			_move_to(target.global_position, delta)
		else:
			var chase_direction := _avoidance_direction if _avoidance_remaining > 0.0 else to_target.normalized()
			velocity = chase_direction * definition.move_speed + _knockback

	move_and_slide()
	if state == State.CHASE and get_slide_collision_count() > 0:
		_begin_wall_avoidance(to_target)
	if not velocity.is_zero_approx():
		rotation = lerp_angle(rotation, to_target.angle(), minf(1.0, delta * 9.0))
	queue_redraw()


func _move_to(destination: Vector2, delta: float) -> void:
	_navigation_update_remaining -= delta
	if _navigation_update_remaining <= 0.0:
		navigation_agent.target_position = destination
		_navigation_update_remaining = 0.15
	var direction := global_position.direction_to(destination)
	if not navigation_agent.is_navigation_finished():
		var next_position := navigation_agent.get_next_path_position()
		if global_position.distance_squared_to(next_position) > 1.0:
			direction = global_position.direction_to(next_position)
	var desired_velocity := direction * definition.move_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = desired_velocity
	else:
		velocity = desired_velocity + _knockback
		move_and_slide()


func _on_navigation_velocity_computed(safe_velocity: Vector2) -> void:
	if state not in [State.INVESTIGATE, State.CHASE] or state == State.DEAD:
		return
	velocity = safe_velocity + _knockback
	move_and_slide()


func _on_noise_heard(event: NoiseEvent) -> void:
	if not perception_enabled or state in [State.CHASE, State.ATTACK, State.DEAD]:
		return
	_investigation_position = event.position
	state = State.INVESTIGATE
	_search_remaining = definition.search_duration
	queue_redraw()


func _begin_wall_avoidance(to_target: Vector2) -> void:
	var collision := get_slide_collision(0)
	if not collision.get_collider() is StaticBody2D:
		return
	var tangent := collision.get_normal().orthogonal().normalized()
	var tangent_alignment := tangent.dot(to_target)
	if tangent_alignment < 0.0 or (is_zero_approx(tangent_alignment) and get_instance_id() % 2 == 0):
		tangent = -tangent
	_avoidance_direction = tangent
	_avoidance_remaining = 0.45


func _apply_attack_if_in_range() -> void:
	if not is_instance_valid(target):
		return
	if global_position.distance_to(target.global_position) > definition.attack_range + 7.0:
		return
	if target.has_method("receive_damage"):
		var direction := global_position.direction_to(target.global_position)
		target.call("receive_damage", DamageInfo.new(definition.attack_damage, self, target.global_position, direction))
		if _attack_audio != null:
			_attack_audio.play()


func _on_damage_received(_amount: float) -> void:
	_hit_flash_remaining = 0.10
	if _hit_audio != null:
		_hit_audio.pitch_scale = randf_range(0.9, 1.1)
		_hit_audio.play()
	queue_redraw()


func _on_died() -> void:
	state = State.DEAD
	velocity = Vector2.ZERO
	collision_layer = 0
	collision_mask = 0
	collision_shape.set_deferred(&"disabled", true)
	if _death_audio != null:
		_death_audio.play()
	died.emit(self)
	var tween := create_tween()
	tween.tween_method(_set_death_progress, 0.0, 1.0, 0.32)
	tween.tween_callback(queue_free)


func _set_death_progress(value: float) -> void:
	_death_progress = value
	queue_redraw()


func _build_audio() -> void:
	_hit_audio = AudioStreamPlayer2D.new()
	_hit_audio.bus = &"SFX"
	_hit_audio.stream = ToneFactory.create_tone(230.0, 0.055, 0.12)
	add_child(_hit_audio)
	_attack_audio = AudioStreamPlayer2D.new()
	_attack_audio.bus = &"SFX"
	_attack_audio.stream = ToneFactory.create_tone(72.0, 0.09, 0.18)
	add_child(_attack_audio)
	_death_audio = AudioStreamPlayer2D.new()
	_death_audio.bus = &"SFX"
	_death_audio.stream = ToneFactory.create_tone(115.0, 0.23, 0.18)
	add_child(_death_audio)


func _exit_tree() -> void:
	for audio in [_hit_audio, _attack_audio, _death_audio]:
		if is_instance_valid(audio):
			audio.stop()
			audio.stream = null


func _draw() -> void:
	var scale_factor := 1.0 - (_death_progress * 0.7)
	var body_colour := Color(1.0, 0.92, 0.72) if _hit_flash_remaining > 0.0 else Color(0.75, 0.18, 0.24)
	if _windup_remaining > 0.0:
		body_colour = Color(1.0, 0.55, 0.2)
	elif state == State.INVESTIGATE:
		body_colour = Color(1.0, 0.62, 0.18)
	elif state == State.SEARCH:
		body_colour = Color(0.9, 0.35, 0.72)
	var alpha := 1.0 - _death_progress
	body_colour.a = alpha
	draw_circle(Vector2.ZERO, 13.0 * scale_factor, Color(0.09, 0.015, 0.025, alpha))
	var points := PackedVector2Array([
		Vector2(13.0, 0.0), Vector2(5.0, 10.0), Vector2(-9.0, 8.0),
		Vector2(-13.0, 0.0), Vector2(-9.0, -8.0), Vector2(5.0, -10.0)
	])
	for point_index in points.size():
		points[point_index] *= scale_factor
	draw_colored_polygon(points, body_colour)
	draw_circle(Vector2(4.0, -3.0) * scale_factor, 2.5 * scale_factor, Color(0.9, 1.0, 0.35, alpha))

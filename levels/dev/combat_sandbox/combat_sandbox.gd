class_name CombatSandbox
extends Node2D

const WORLD_SIZE := Vector2(2000.0, 1200.0)
const PLAYER_SPAWN := Vector2(1000.0, 850.0)
const PLAYER_SCENE := preload("res://features/player/player.tscn")
const DRONE_SCENE := preload("res://features/enemies/drone/drone.tscn")
const AMMO_PICKUP_SCENE := preload("res://features/pickups/ammo/ammo_pickup.tscn")
const BOOTSTRAP_SCENE := "res://levels/dev/bootstrap.tscn"

@export_range(0, 50, 1) var initial_enemy_count: int = 7
@export var profile_mode: bool = false
@export_range(60, 3600, 60) var profile_frame_count: int = 600

@onready var actors: Node2D = $Actors
@onready var world: Node2D = $World
@onready var crosshair: CombatCrosshair = $Crosshair
@onready var hud: CombatHud = $CombatHud

var player: Player
var _status_update_remaining := 0.0
var _spawn_cursor := 0
var _player_dead := false
var _profile_frames := 0
var _profile_started_usec := 0

var _enemy_spawns: Array[Vector2] = [
	Vector2(280.0, 240.0),
	Vector2(620.0, 240.0),
	Vector2(1000.0, 210.0),
	Vector2(1420.0, 250.0),
	Vector2(1720.0, 330.0),
	Vector2(380.0, 820.0),
	Vector2(1190.0, 850.0),
	Vector2(1600.0, 850.0),
	Vector2(790.0, 610.0),
	Vector2(1780.0, 1040.0),
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	_build_arena()
	_spawn_player()
	for enemy_index in initial_enemy_count:
		spawn_drone(_enemy_spawns[enemy_index % _enemy_spawns.size()])
	_spawn_ammo(Vector2(540.0, 940.0))
	_spawn_ammo(Vector2(1500.0, 560.0))
	hud.resume_requested.connect(_resume_game)
	hud.restart_requested.connect(restart_sandbox)
	hud.quit_requested.connect(_quit_to_bootstrap)
	queue_redraw()
	print("Combat sandbox ready: %d Drones" % initial_enemy_count)
	if profile_mode:
		_profile_started_usec = Time.get_ticks_usec()


func _exit_tree() -> void:
	if is_instance_valid(get_tree()):
		get_tree().paused = false


func _process(delta: float) -> void:
	_status_update_remaining -= delta
	if _status_update_remaining <= 0.0 and is_instance_valid(player):
		_status_update_remaining = 0.25
		hud.update_status(get_tree().get_nodes_in_group(&"enemies").size(), Engine.get_frames_per_second(), player.invulnerable)
	if profile_mode:
		_profile_frames += 1
		if _profile_frames >= profile_frame_count:
			_finish_profile()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause") and not _player_dead:
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()
		get_viewport().set_input_as_handled()
		return
	if not OS.is_debug_build() or not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_F1:
			spawn_drone(_next_spawn_position())
		KEY_F2:
			spawn_drones(10)
		KEY_F3:
			clear_enemies()
		KEY_F4:
			player.set_invulnerable(not player.invulnerable)
		KEY_F5:
			player.restore_health()
		KEY_F6:
			player.refill_ammunition()
		KEY_F7:
			spawn_drones(50)


func spawn_drone(spawn_position: Vector2) -> Drone:
	var drone := DRONE_SCENE.instantiate() as Drone
	drone.global_position = spawn_position
	actors.add_child(drone)
	drone.set_target(player)
	return drone


func spawn_drones(count: int) -> void:
	for index in maxi(0, count):
		var base_position := _next_spawn_position()
		var offset := Vector2.from_angle(float(index) * 2.39996) * (18.0 + float(index % 5) * 8.0)
		spawn_drone(base_position + offset)


func clear_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group(&"enemies"):
		enemy.queue_free()


func restart_sandbox() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _spawn_player() -> void:
	player = PLAYER_SCENE.instantiate() as Player
	player.global_position = PLAYER_SPAWN
	actors.add_child(player)
	player.camera.reset_smoothing()
	player.died.connect(_on_player_died)
	crosshair.target = player
	hud.bind_player(player)


func _spawn_ammo(spawn_position: Vector2) -> void:
	var pickup := AMMO_PICKUP_SCENE.instantiate() as AmmoPickup
	pickup.global_position = spawn_position
	actors.add_child(pickup)


func _on_player_died() -> void:
	_player_dead = true
	hud.show_death()
	get_tree().paused = true


func _pause_game() -> void:
	hud.show_pause(true)
	get_tree().paused = true


func _resume_game() -> void:
	hud.show_pause(false)
	get_tree().paused = false


func _quit_to_bootstrap() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(BOOTSTRAP_SCENE)


func _next_spawn_position() -> Vector2:
	var position := _enemy_spawns[_spawn_cursor % _enemy_spawns.size()]
	_spawn_cursor += 1
	return position


func _build_arena() -> void:
	_create_wall(Rect2(0.0, 0.0, WORLD_SIZE.x, 32.0))
	_create_wall(Rect2(0.0, WORLD_SIZE.y - 32.0, WORLD_SIZE.x, 32.0))
	_create_wall(Rect2(0.0, 0.0, 32.0, WORLD_SIZE.y))
	_create_wall(Rect2(WORLD_SIZE.x - 32.0, 0.0, 32.0, WORLD_SIZE.y))

	_create_wall(Rect2(430.0, 380.0, 300.0, 32.0))
	_create_wall(Rect2(430.0, 380.0, 32.0, 230.0))
	_create_wall(Rect2(698.0, 380.0, 32.0, 120.0))
	_create_wall(Rect2(1240.0, 360.0, 330.0, 32.0))
	_create_wall(Rect2(1538.0, 360.0, 32.0, 250.0))
	_create_wall(Rect2(1240.0, 500.0, 32.0, 110.0))
	_create_wall(Rect2(800.0, 660.0, 400.0, 28.0))
	_create_wall(Rect2(800.0, 660.0, 28.0, 170.0))
	_create_wall(Rect2(1172.0, 660.0, 28.0, 170.0))
	_create_wall(Rect2(260.0, 900.0, 180.0, 36.0))
	_create_wall(Rect2(1580.0, 900.0, 170.0, 36.0))


func _create_wall(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = rect.get_center()
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	body.add_child(collision)
	var visual := Polygon2D.new()
	var half_size := rect.size * 0.5
	visual.polygon = PackedVector2Array([
		Vector2(-half_size.x, -half_size.y), Vector2(half_size.x, -half_size.y),
		Vector2(half_size.x, half_size.y), Vector2(-half_size.x, half_size.y),
	])
	visual.color = Color(0.12, 0.18, 0.20)
	body.add_child(visual)
	var inner := Line2D.new()
	inner.width = 2.0
	inner.default_color = Color(0.26, 0.7, 0.65, 0.55)
	inner.closed = true
	inner.points = visual.polygon
	body.add_child(inner)
	world.add_child(body)


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, WORLD_SIZE), Color(0.025, 0.045, 0.052), true)
	for x in range(0, int(WORLD_SIZE.x), 64):
		draw_line(Vector2(x, 0.0), Vector2(x, WORLD_SIZE.y), Color(0.08, 0.14, 0.15, 0.35), 1.0)
	for y in range(0, int(WORLD_SIZE.y), 64):
		draw_line(Vector2(0.0, y), Vector2(WORLD_SIZE.x, y), Color(0.08, 0.14, 0.15, 0.35), 1.0)
	draw_rect(Rect2(760.0, 1020.0, 480.0, 90.0), Color(0.07, 0.15, 0.16, 0.65), true)
	draw_string(ThemeDB.fallback_font, Vector2(795.0, 1075.0), "DECK 07  //  COMBAT EVALUATION CHAMBER", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.3, 0.75, 0.68, 0.7))


func _finish_profile() -> void:
	var elapsed_ms := float(Time.get_ticks_usec() - _profile_started_usec) / 1000.0
	var average_ms := elapsed_ms / float(_profile_frames)
	print(
		"PROFILE combat_stress: frames=%d drones=%d average_process_ms=%.3f nodes=%d" % [
			_profile_frames,
			get_tree().get_nodes_in_group(&"enemies").size(),
			average_ms,
			Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		]
	)
	get_tree().quit()

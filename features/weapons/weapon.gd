class_name Weapon
extends Node2D

signal ammo_changed(current: int, reserve: int)
signal fired
signal dry_fired
signal reload_started
signal reload_finished

@export var definition: WeaponDefinition
@export var projectile_scene: PackedScene

var current_magazine: int = 0
var reserve_ammo: int = 0
var cooldown_remaining: float = 0.0
var reload_remaining: float = 0.0
var is_reloading: bool = false

var _muzzle_flash_remaining: float = 0.0
var _wielder: Node
var _shot_audio: AudioStreamPlayer2D
var _reload_audio: AudioStreamPlayer2D
var _dry_audio: AudioStreamPlayer2D


func _ready() -> void:
	_build_audio()
	if definition != null:
		configure(definition)
	queue_redraw()


func configure(p_definition: WeaponDefinition) -> void:
	definition = p_definition
	assert(definition != null and definition.is_valid(), "WeaponDefinition is invalid")
	current_magazine = definition.magazine_size
	reserve_ammo = definition.reserve_ammo
	cooldown_remaining = 0.0
	reload_remaining = 0.0
	is_reloading = false
	ammo_changed.emit(current_magazine, reserve_ammo)


func _process(delta: float) -> void:
	advance(delta)


func advance(delta: float) -> void:
	var safe_delta := maxf(delta, 0.0)
	cooldown_remaining = maxf(0.0, cooldown_remaining - safe_delta)
	if is_zero_approx(cooldown_remaining):
		cooldown_remaining = 0.0
	_muzzle_flash_remaining = maxf(0.0, _muzzle_flash_remaining - safe_delta)
	if is_reloading:
		reload_remaining = maxf(0.0, reload_remaining - safe_delta)
		if is_zero_approx(reload_remaining):
			_finish_reload()
	queue_redraw()


func try_fire(aim_direction: Vector2, wielder: Node = null) -> bool:
	if definition == null or is_reloading or cooldown_remaining > 0.0:
		return false
	if current_magazine <= 0:
		dry_fired.emit()
		if _dry_audio != null:
			_dry_audio.play()
		cooldown_remaining = 0.16
		return false
	if aim_direction.is_zero_approx():
		return false

	_wielder = wielder
	current_magazine -= 1
	cooldown_remaining = 1.0 / definition.rounds_per_second
	_muzzle_flash_remaining = 0.055
	for projectile_index in definition.projectiles_per_shot:
		var spread := deg_to_rad(randf_range(-definition.spread_degrees, definition.spread_degrees))
		_spawn_projectile(aim_direction.normalized().rotated(spread))
	if _shot_audio != null:
		_shot_audio.pitch_scale = randf_range(0.96, 1.04)
		_shot_audio.play()
	fired.emit()
	ammo_changed.emit(current_magazine, reserve_ammo)
	queue_redraw()
	return true


func start_reload() -> bool:
	if definition == null or is_reloading:
		return false
	if current_magazine >= definition.magazine_size or reserve_ammo <= 0:
		return false
	is_reloading = true
	reload_remaining = definition.reload_duration
	if _reload_audio != null:
		_reload_audio.play()
	reload_started.emit()
	if is_zero_approx(reload_remaining):
		_finish_reload()
	return true


func add_reserve_ammo(amount: int) -> int:
	var accepted := maxi(0, amount)
	reserve_ammo += accepted
	ammo_changed.emit(current_magazine, reserve_ammo)
	return accepted


func refill_ammunition() -> void:
	if definition == null:
		return
	current_magazine = definition.magazine_size
	reserve_ammo = definition.reserve_ammo
	is_reloading = false
	reload_remaining = 0.0
	ammo_changed.emit(current_magazine, reserve_ammo)


func stop_actions() -> void:
	is_reloading = false
	reload_remaining = 0.0


func _finish_reload() -> void:
	if not is_reloading or definition == null:
		return
	var missing := definition.magazine_size - current_magazine
	var transfer := mini(missing, reserve_ammo)
	current_magazine += transfer
	reserve_ammo -= transfer
	is_reloading = false
	reload_remaining = 0.0
	reload_finished.emit()
	ammo_changed.emit(current_magazine, reserve_ammo)


func _spawn_projectile(projectile_direction: Vector2) -> void:
	if projectile_scene == null or not is_inside_tree():
		return
	var projectile := projectile_scene.instantiate() as Projectile
	if projectile == null:
		return
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = to_global(Vector2(25.0, 0.0))
	projectile.configure(
		projectile_direction,
		definition.damage,
		definition.projectile_speed,
		definition.projectile_lifetime,
		_wielder
	)


func _build_audio() -> void:
	_shot_audio = AudioStreamPlayer2D.new()
	_shot_audio.bus = &"SFX"
	_shot_audio.stream = ToneFactory.create_tone(165.0, 0.075, 0.28)
	add_child(_shot_audio)
	_reload_audio = AudioStreamPlayer2D.new()
	_reload_audio.bus = &"SFX"
	_reload_audio.stream = ToneFactory.create_tone(510.0, 0.12, 0.12)
	add_child(_reload_audio)
	_dry_audio = AudioStreamPlayer2D.new()
	_dry_audio.bus = &"SFX"
	_dry_audio.stream = ToneFactory.create_tone(85.0, 0.04, 0.12)
	add_child(_dry_audio)


func _draw() -> void:
	draw_rect(Rect2(0.0, -3.0, 24.0, 6.0), Color(0.28, 0.35, 0.39), true)
	draw_rect(Rect2(4.0, -2.0, 14.0, 4.0), Color(0.45, 0.95, 0.92), true)
	if _muzzle_flash_remaining > 0.0:
		var flash := PackedVector2Array([Vector2(23.0, -7.0), Vector2(35.0, 0.0), Vector2(23.0, 7.0)])
		draw_colored_polygon(flash, Color(0.8, 1.0, 0.75, 0.9))

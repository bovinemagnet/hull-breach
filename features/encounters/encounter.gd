class_name Encounter
extends Node

signal started(encounter_id: StringName)
signal enemy_spawned(enemy: Node2D)
signal wave_completed(index: int)
signal completed(encounter_id: StringName)

@export var definition: EncounterDefinition
@export var spawn_points_root_path: NodePath
@export var enemy_parent_path: NodePath
@export var target_path: NodePath
@export var noise_system_path: NodePath

var active := false
var is_complete := false
var current_wave := -1
var _wave_delay := 0.0
var _spawn_remaining := 0.0
var _spawn_queue: Array[Dictionary] = []
var _spawn_points: Dictionary[StringName, EnemySpawnPoint] = {}
var _living_enemies: Array[Node2D] = []
var _enemy_parent: Node
var _target: Node2D
var _noise_system: NoiseSystem


func _ready() -> void:
	_configure_from_scene()
	if definition != null and definition.auto_start:
		start()


func configure(spawn_points: Array[EnemySpawnPoint], enemy_parent: Node, target: Node2D, noise_system: NoiseSystem = null) -> void:
	_spawn_points.clear()
	for point in spawn_points:
		_spawn_points[point.id] = point
	_enemy_parent = enemy_parent
	_target = target
	_noise_system = noise_system


func _configure_from_scene() -> void:
	if spawn_points_root_path.is_empty() or enemy_parent_path.is_empty():
		return
	var root_node := get_node_or_null(spawn_points_root_path)
	var enemy_parent := get_node_or_null(enemy_parent_path)
	if root_node == null or enemy_parent == null:
		push_warning("Encounter scene paths are incomplete")
		return
	var points: Array[EnemySpawnPoint] = []
	_collect_spawn_points(root_node, points)
	var scene_target := get_node_or_null(target_path) as Node2D if not target_path.is_empty() else null
	if scene_target == null and get_tree() != null:
		scene_target = get_tree().get_first_node_in_group(&"player") as Node2D
	var scene_noise := get_node_or_null(noise_system_path) as NoiseSystem if not noise_system_path.is_empty() else null
	configure(points, enemy_parent, scene_target, scene_noise)


func _collect_spawn_points(node: Node, output: Array[EnemySpawnPoint]) -> void:
	for child in node.get_children():
		if child is EnemySpawnPoint:
			output.append(child as EnemySpawnPoint)
		_collect_spawn_points(child, output)


func start() -> bool:
	if active or is_complete or definition == null or not definition.validation_errors().is_empty():
		return false
	active = true
	started.emit(definition.id)
	_begin_wave(0)
	return true


func _process(delta: float) -> void:
	advance(delta)


func advance(delta: float) -> void:
	if not active:
		return
	_living_enemies = _living_enemies.filter(func(enemy: Node2D) -> bool: return is_instance_valid(enemy))
	if _wave_delay > 0.0:
		_wave_delay -= delta
		return
	_spawn_remaining -= delta
	var spawned_this_frame := 0
	while not _spawn_queue.is_empty() and _spawn_remaining <= 0.0 and spawned_this_frame < definition.maximum_spawn_per_frame and _living_enemies.size() < definition.maximum_active_enemies:
		_spawn_from_entry(_spawn_queue.pop_front())
		spawned_this_frame += 1
		_spawn_remaining = definition.waves[current_wave].spawn_interval
	if not _spawn_queue.is_empty():
		return
	var wave := definition.waves[current_wave]
	if _living_enemies.size() > wave.minimum_alive_before_next:
		return
	wave_completed.emit(current_wave)
	if current_wave + 1 < definition.waves.size():
		_begin_wave(current_wave + 1)
	elif _living_enemies.is_empty():
		active = false
		is_complete = true
		completed.emit(definition.id)


func living_count() -> int:
	return _living_enemies.size()


func _begin_wave(index: int) -> void:
	current_wave = index
	var wave := definition.waves[index]
	_wave_delay = wave.delay
	_spawn_remaining = 0.0
	_spawn_queue.clear()
	for entry_index in wave.enemy_scenes.size():
		for count_index in wave.counts[entry_index]:
			_spawn_queue.append({
				"point_id": StringName(wave.spawn_point_ids[entry_index]),
				"scene": wave.enemy_scenes[entry_index],
			})


func _spawn_from_entry(entry: Dictionary) -> void:
	var point: EnemySpawnPoint = _spawn_points.get(entry.point_id)
	if point == null:
		push_warning("Encounter %s missing spawn point %s" % [definition.id, entry.point_id])
		return
	var enemy := point.spawn(entry.scene, _enemy_parent, _target)
	if enemy == null:
		return
	if "perception_enabled" in enemy:
		enemy.perception_enabled = true
	if _noise_system != null and "noise_listener" in enemy:
		_noise_system.register_listener(enemy.noise_listener)
	_living_enemies.append(enemy)
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died)
	enemy_spawned.emit(enemy)


func _on_enemy_died(enemy: Node2D) -> void:
	_living_enemies.erase(enemy)

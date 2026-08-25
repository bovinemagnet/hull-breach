class_name CampaignContentMission
extends Node2D

const PLAYER_SCENE := preload("res://features/player/player.tscn")
const COMBAT_HUD_SCENE := preload("res://ui/hud/combat_hud.tscn")
const MISSION_HUD_SCENE := preload("res://ui/mission/mission_hud.tscn")
const MOBILE_CONTROLS_SCENE := preload("res://ui/mobile/mobile_controls.tscn")
const HEALTH_PICKUP_SCENE := preload("res://features/pickups/health/health_pickup.tscn")
const AMMO_PICKUP_SCENE := preload("res://features/pickups/ammo/ammo_pickup.tscn")

@export var profile: CampaignMissionProfile

var player: Player
var mission: MissionController
var checkpoint_manager: CheckpointManager
var noise_system: NoiseSystem
var power_grid: PowerGrid
var combat_hud: CombatHud
var mission_hud: MissionHud
var mobile_controls: MobileControls
var enemies: Node2D
var objective_zones: Array[Area2D] = []
var resource_pickups: Dictionary = {}
var collected_pickups := PackedStringArray()
var elapsed_time := 0.0
var enemies_killed := 0
var _completed := false


func _ready() -> void:
	assert(profile != null and profile.is_valid(), "CampaignMissionProfile is invalid")
	_build_world()
	_build_runtime()
	_connect_systems()
	_restore_or_start()
	mission_hud.notify("%02d  %s — %s" % [profile.campaign_index, profile.theme_name.to_upper(), profile.briefing], 5.0)
	queue_redraw()


func _process(delta: float) -> void:
	elapsed_time += delta
	if combat_hud != null:
		combat_hud.update_status(get_tree().get_nodes_in_group(&"enemies").size(), Engine.get_frames_per_second(), player.invulnerable)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		_set_paused(not get_tree().paused)
		get_viewport().set_input_as_handled()


func _build_world() -> void:
	var world := Node2D.new()
	world.name = "World"
	add_child(world)
	var map_rect := Rect2(60.0, 60.0, 1480.0, 780.0)
	RuntimeLevelBuilder.add_wall(world, Vector2(800, 45), Vector2(1520, 30))
	RuntimeLevelBuilder.add_wall(world, Vector2(800, 855), Vector2(1520, 30))
	RuntimeLevelBuilder.add_wall(world, Vector2(45, 450), Vector2(30, 840))
	RuntimeLevelBuilder.add_wall(world, Vector2(1555, 450), Vector2(30, 840))
	for divider_x in [430.0, 790.0, 1150.0]:
		RuntimeLevelBuilder.add_wall(world, Vector2(divider_x, 245), Vector2(20, 260))
		RuntimeLevelBuilder.add_wall(world, Vector2(divider_x, 700), Vector2(20, 250))
	var navigation := NavigationRegion2D.new()
	navigation.name = "NavigationRegion"
	navigation.navigation_polygon = RuntimeLevelBuilder.rectangular_navigation(map_rect)
	world.add_child(navigation)
	var light_zone := LightZone.new()
	light_zone.position = Vector2(910, 450)
	light_zone.illumination_level = 0.85 if profile.mission_id != &"research_sector" else 0.75
	var light_shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(360, 300)
	light_shape.shape = rectangle
	light_zone.add_child(light_shape)
	world.add_child(light_zone)
	for index in profile.objective_positions.size():
		var zone := Area2D.new()
		zone.name = "Objective_%02d_%s" % [index + 1, profile.mission_definition.objective_ids[index]]
		zone.position = profile.objective_positions[index]
		zone.collision_layer = 0
		zone.collision_mask = 2
		var shape_node := CollisionShape2D.new()
		var shape := CircleShape2D.new()
		shape.radius = 44.0
		shape_node.shape = shape
		zone.add_child(shape_node)
		zone.body_entered.connect(func(body: Node) -> void: _on_objective_entered(index, body))
		world.add_child(zone)
		objective_zones.append(zone)
		if index > 0 and index < profile.objective_positions.size() - 1:
			_add_resource_pickup(world, index, position + Vector2(0, 88))


func _add_resource_pickup(world: Node2D, index: int, position: Vector2) -> void:
	var pickup_id := "%s_supply_%02d" % [profile.mission_id, index]
	var packed := HEALTH_PICKUP_SCENE if index % 3 == 0 else AMMO_PICKUP_SCENE
	var pickup := packed.instantiate() as Area2D
	pickup.name = pickup_id
	pickup.position = position
	pickup.tree_exiting.connect(func() -> void:
		if is_inside_tree() and not collected_pickups.has(pickup_id):
			collected_pickups.append(pickup_id)
	)
	world.add_child(pickup)
	resource_pickups[pickup_id] = pickup


func _build_runtime() -> void:
	enemies = Node2D.new()
	enemies.name = "Enemies"
	add_child(enemies)
	noise_system = NoiseSystem.new()
	noise_system.name = "NoiseSystem"
	add_child(noise_system)
	power_grid = PowerGrid.new()
	power_grid.name = "PowerGrid"
	add_child(power_grid)
	checkpoint_manager = CheckpointManager.new()
	checkpoint_manager.name = "CheckpointManager"
	add_child(checkpoint_manager)
	mission = MissionController.new()
	mission.name = "Mission"
	mission.definition = profile.mission_definition
	add_child(mission)
	player = PLAYER_SCENE.instantiate() as Player
	player.name = "Player"
	player.position = Vector2(120, 450)
	add_child(player)
	player.camera.limit_left = 60
	player.camera.limit_top = 60
	player.camera.limit_right = 1540
	player.camera.limit_bottom = 840
	combat_hud = COMBAT_HUD_SCENE.instantiate() as CombatHud
	add_child(combat_hud)
	mission_hud = MISSION_HUD_SCENE.instantiate() as MissionHud
	add_child(mission_hud)
	mobile_controls = MOBILE_CONTROLS_SCENE.instantiate() as MobileControls
	add_child(mobile_controls)
	var ambience := AudioStreamPlayer.new()
	ambience.name = "MissionAmbience"
	ambience.bus = &"Ambience"
	ambience.stream = ToneFactory.create_tone(45.0 + profile.campaign_index * 4.0, 2.4, 0.025)
	add_child(ambience)
	ambience.play()


func _connect_systems() -> void:
	player.weapon_inventory.noise_requested.connect(noise_system.emit_noise)
	player.died.connect(_on_player_died)
	player.interaction_detector.prompt_changed.connect(mission_hud.set_prompt)
	mission.active_objective_changed.connect(mission_hud.set_objective)
	mission.objective_completed.connect(_on_objective_completed)
	mission.timed_objective_failed.connect(_on_timed_objective_failed)
	mission.objective_timer_changed.connect(_on_objective_timer_changed)
	mission.mission_completed.connect(_on_mission_completed)
	combat_hud.bind_player(player)
	mission_hud.bind_mission(mission)
	mobile_controls.bind_player(player)
	combat_hud.resume_requested.connect(func() -> void: _set_paused(false))
	combat_hud.restart_requested.connect(_restart_checkpoint)
	combat_hud.restart_mission_requested.connect(_restart_mission)
	combat_hud.quit_requested.connect(_return_to_menu)
	mission_hud.replay_requested.connect(_continue_campaign)
	mission_hud.quit_requested.connect(_return_to_menu)
	mobile_controls.pause_requested.connect(func() -> void: _set_paused(not get_tree().paused))
	var platform := get_node_or_null("/root/PlatformService") as PlatformServiceNode
	if platform != null:
		platform.pause_requested.connect(func(reason: String) -> void: _set_paused(true, reason))
	var saves := get_node_or_null("/root/SaveService") as SaveServiceNode
	if saves != null:
		saves.save_failed.connect(func(_message: String) -> void: mission_hud.notify("SAVE FAILED — PROGRESS NOT WRITTEN", 5.0))
	var active := mission.get_active_objective()
	if active != null:
		mission_hud.set_objective(active.title, active.details, 1, mission.objectives.size())
	mission_hud.set_power(profile.mission_id not in [&"research_sector", &"evacuation"])


func _restore_or_start() -> void:
	var pending := checkpoint_manager.consume_pending()
	if pending != null:
		_restore_checkpoint(pending)
		return
	var session := _session()
	var persisted := session.checkpoint_for(profile.mission_id) if session != null else {}
	if not persisted.is_empty():
		_restore_checkpoint(CheckpointState.from_dictionary(persisted))
	else:
		if session != null and not session.campaign_loadout().is_empty():
			player.weapon_inventory.restore(session.campaign_loadout())
		_save_checkpoint(&"start")
	_spawn_beat(0)


func _on_objective_entered(index: int, body: Node) -> void:
	if body != player or _completed or mission.active_index != index:
		return
	var event_id := StringName(profile.mission_definition.objective_events[index])
	mission.notify_event(event_id)
	call_deferred("_after_objective", index)
	queue_redraw()


func _after_objective(index: int) -> void:
	_apply_weapon_unlock(index)
	if profile.checkpoint_objectives.has(index):
		_save_checkpoint(StringName("%s_%02d" % [profile.mission_id, index + 1]))
	_spawn_beat(index + 1)


func _spawn_beat(beat: int) -> void:
	if profile.enemy_scene_paths.is_empty():
		return
	var roster_index := mini(beat, profile.enemy_scene_paths.size() - 1)
	var enemy_scene := load(profile.enemy_scene_paths[roster_index]) as PackedScene
	if enemy_scene == null:
		return
	var count := profile.enemies_per_beat[roster_index]
	if count <= 0:
		return
	var anchor := profile.objective_positions[mini(beat, profile.objective_positions.size() - 1)]
	for enemy_index in count:
		var enemy := enemy_scene.instantiate() as Drone
		if enemy == null:
			continue
		enemy.position = anchor + Vector2(90.0 + (enemy_index % 4) * 25.0, -65.0 + (enemy_index / 4) * 28.0)
		enemy.set_target(player)
		enemies.add_child(enemy)
		noise_system.register_listener(enemy.noise_listener)
		enemy.died.connect(func(_dead: Drone) -> void: enemies_killed += 1)


func _apply_weapon_unlock(index: int) -> void:
	for entry in profile.weapon_unlocks:
		var parts := entry.split(":", false, 1)
		if parts.size() != 2 or int(parts[0]) != index:
			continue
		var weapon_path: String = WeaponInventory.WEAPON_CATALOG.get(StringName(parts[1]), "")
		if not weapon_path.is_empty() and player.weapon_inventory.add_weapon_scene(load(weapon_path) as PackedScene):
			mission_hud.notify("WEAPON ACQUIRED — %s" % parts[1].replace("_", " ").to_upper(), 3.0)


func _on_objective_completed(_objective_id: StringName, title: String) -> void:
	mission_hud.notify("OBJECTIVE COMPLETE  •  %s" % title.to_upper())


func _on_objective_timer_changed(_objective_id: StringName, remaining: float) -> void:
	if int(remaining) % 10 == 0:
		mission_hud.set_power(false)


func _on_timed_objective_failed(_objective_id: StringName) -> void:
	mission_hud.notify("WINDOW MISSED — EMERGENCY ROUTE OPENED", 3.5)
	player.receive_damage(DamageInfo.new(8.0))


func _on_mission_completed() -> void:
	if _completed:
		return
	_completed = true
	player.input_enabled = false
	var result := MissionResult.new()
	result.mission_id = profile.mission_id
	result.completed = true
	result.completion_time = elapsed_time
	result.enemies_killed = enemies_killed
	var session := _session()
	if session != null:
		result.difficulty = session.difficulty_id
		session.save_loadout(player.weapon_inventory.snapshot())
		session.complete_mission(result)
	var final_text := "Outbreak contained. Evacuation confirmed." if profile.mission_id == &"evacuation" else "%s secured. The next sector is unlocked." % profile.theme_name
	mission_hud.show_complete("%s COMPLETE" % profile.mission_definition.display_name.to_upper(), final_text, "View Credits" if profile.mission_id == &"evacuation" else "Continue")


func _save_checkpoint(checkpoint_id: StringName) -> void:
	if player == null or mission == null:
		return
	var state := CheckpointState.new()
	state.checkpoint_id = checkpoint_id
	state.player_position = player.global_position
	state.player_health = player.health_component.current_health
	state.weapon_states = player.weapon_inventory.snapshot()
	state.credentials = player.access_inventory.snapshot()
	state.mission_state = mission.snapshot()
	state.power_state = power_grid.snapshot()
	state.world_flags = {"collected_pickups": Array(collected_pickups)}
	checkpoint_manager.save(state)
	var session := _session()
	if get_tree().current_scene == self and session != null:
		session.save_checkpoint(profile.mission_id, state.to_dictionary())
	mission_hud.notify("CHECKPOINT SAVED", 1.2)


func _restore_checkpoint(state: CheckpointState) -> void:
	state.sanitize(player.global_position, player.health_component.maximum_health)
	checkpoint_manager.save(state)
	player.global_position = state.player_position
	player.restore_health()
	var damage := player.health_component.maximum_health - state.player_health
	if damage > 0.0:
		player.health_component.apply_damage(DamageInfo.new(damage))
	player.weapon_inventory.restore(state.weapon_states)
	player.access_inventory.restore(state.credentials)
	mission.restore(state.mission_state)
	power_grid.restore(state.power_state)
	collected_pickups = PackedStringArray(state.world_flags.get("collected_pickups", []))
	for pickup_id in collected_pickups:
		var pickup: Node = resource_pickups.get(pickup_id)
		if is_instance_valid(pickup):
			pickup.queue_free()
	_grant_checkpoint_grace()


func debug_complete() -> void:
	if not OS.is_debug_build():
		return
	while not mission.is_complete:
		var objective := mission.get_active_objective()
		if objective == null:
			break
		mission.notify_event(objective.event_id)


func _continue_campaign() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	var session := _session()
	if session != null:
		session.transition_to_next_mission(profile.mission_id)


func _return_to_menu() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	var session := _session()
	if session != null:
		session.transition_to_scene("res://ui/menus/main_menu.tscn")


func _on_player_died() -> void:
	get_tree().paused = true
	combat_hud.show_death()


func _set_paused(enabled: bool, reason := "PAUSED") -> void:
	get_tree().paused = enabled
	combat_hud.show_pause(enabled, reason, mission_hud.objective_summary())


func _restart_checkpoint() -> void:
	get_tree().paused = false
	if checkpoint_manager.prepare_restart():
		get_tree().reload_current_scene()


func _restart_mission() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	var session := _session()
	if session != null:
		session.clear_checkpoint(profile.mission_id)
	get_tree().reload_current_scene()


func _grant_checkpoint_grace() -> void:
	player.set_invulnerable(true)
	get_tree().create_timer(1.0).timeout.connect(func() -> void:
		if is_instance_valid(player) and not player.health_component.is_dead:
			player.set_invulnerable(false)
	, CONNECT_ONE_SHOT)


func _session() -> GameSessionState:
	return get_node_or_null("/root/GameSession") as GameSessionState


func _draw() -> void:
	draw_rect(Rect2(60, 60, 1480, 780), profile.floor_colour, true)
	for index in profile.objective_positions.size():
		var position := profile.objective_positions[index]
		var active := mission != null and mission.active_index == index
		var colour := profile.accent_colour if active else profile.accent_colour.darkened(0.55)
		draw_circle(position, 32.0, Color(colour, 0.18))
		draw_arc(position, 32.0, 0.0, TAU, 24, colour, 3.0 if active else 1.0)
		draw_string(ThemeDB.fallback_font, position + Vector2(-26, -42), "M%02d_%02d" % [profile.campaign_index, index + 1], HORIZONTAL_ALIGNMENT_CENTER, 52.0, 12, colour)
	draw_string(ThemeDB.fallback_font, Vector2(90, 105), "%02d  %s  •  %s" % [profile.campaign_index, profile.theme_name.to_upper(), profile.ambience_cue.to_upper()], HORIZONTAL_ALIGNMENT_LEFT, -1, 18, profile.accent_colour)

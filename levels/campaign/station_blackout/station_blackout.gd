class_name StationBlackout
extends Node2D

const MAP_RECT := Rect2(40.0, 40.0, 1520.0, 920.0)
const DOOR_SCENE := preload("res://features/doors/door.tscn")
const TERMINAL_SCENE := preload("res://features/terminals/terminal.tscn")
const CREDENTIAL_SCENE := preload("res://features/pickups/credentials/credential_pickup.tscn")
const HEALTH_SCENE := preload("res://features/pickups/health/health_pickup.tscn")
const AMMO_SCENE := preload("res://features/pickups/ammo/ammo_pickup.tscn")
const DRONE_SCENE := preload("res://features/enemies/drone/drone.tscn")

@onready var player: Player = $Player
@onready var mission: MissionController = $Mission
@onready var power_grid: PowerGrid = $PowerGrid
@onready var noise_system: NoiseSystem = $NoiseSystem
@onready var checkpoint_manager: CheckpointManager = $CheckpointManager
@onready var navigation_region: NavigationRegion2D = $World/NavigationRegion
@onready var doors: Node2D = $World/Interactive/Doors
@onready var terminals: Node2D = $World/Interactive/Terminals
@onready var pickups: Node2D = $World/Interactive/Pickups
@onready var triggers: Node2D = $MissionTriggers
@onready var enemies: Node2D = $Enemies
@onready var extraction: ExtractionZone = $World/Interactive/Extraction
@onready var canvas_modulate: CanvasModulate = $Lighting/CanvasModulate
@onready var combat_hud: CombatHud = $CombatHud
@onready var mission_hud: MissionHud = $MissionHud
@onready var mobile_controls: MobileControls = $MobileControls

var engineering_door: Door
var shortcut_door: Door
var communications_terminal: Terminal
var power_terminal: Terminal
var credential_pickup: CredentialPickup
var world_flags: Dictionary = {
	"credential_collected": false,
	"power_restored": false,
	"distress_transmitted": false,
}
var _alarm_active := false
var _alarm_timer := 0.0
var _ambient_audio: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_tile_layers()
	_build_navigation()
	_build_collision()
	_build_interactables()
	_build_lighting()
	_build_triggers()
	_build_pickups()
	_build_audio()
	_connect_ui()
	_spawn_initial_enemies()
	player.camera.limit_left = int(MAP_RECT.position.x)
	player.camera.limit_top = int(MAP_RECT.position.y)
	player.camera.limit_right = int(MAP_RECT.end.x)
	player.camera.limit_bottom = int(MAP_RECT.end.y)
	player.weapon_inventory.noise_requested.connect(noise_system.emit_noise)
	player.died.connect(_on_player_died)
	player.interaction_detector.prompt_changed.connect(mission_hud.set_prompt)
	player.access_inventory.credential_added.connect(_on_credential_added)
	mission.active_objective_changed.connect(mission_hud.set_objective)
	mission.objective_completed.connect(_on_objective_completed)
	mission.mission_completed.connect(_on_mission_completed)
	power_grid.circuit_changed.connect(_on_power_changed)
	combat_hud.bind_player(player)
	mobile_controls.bind_player(player)
	$DevelopmentDebugOverlay.bind(player, mission, power_grid, checkpoint_manager)
	var objective := mission.get_active_objective()
	if objective != null:
		mission_hud.set_objective(objective.title, objective.details, mission.active_index + 1, mission.objectives.size())
	mission_hud.set_power(power_grid.is_powered(&"main"))
	var pending := checkpoint_manager.consume_pending()
	if pending != null:
		_restore_checkpoint(pending)
	elif get_tree().current_scene == self and _session() != null and not _session().checkpoint_for(&"station_blackout").is_empty():
		_restore_checkpoint(CheckpointState.from_dictionary(_session().checkpoint_for(&"station_blackout")))
	else:
		_save_checkpoint(&"mission_start")
	queue_redraw()


func _build_tile_layers() -> void:
	var floor_layer := $World/Floor as TileMapLayer
	var floor_detail_layer := $World/FloorDetail as TileMapLayer
	var walls_layer := $World/Walls as TileMapLayer
	var wall_detail_layer := $World/WallDetail as TileMapLayer
	var decoration_layer := $World/Decoration as TileMapLayer
	var foreground_layer := $World/Foreground as TileMapLayer
	floor_layer.tile_set = _create_runtime_tile_set(Color(0.025, 0.055, 0.065, 0.52), Color(0.08, 0.18, 0.19, 0.55))
	floor_detail_layer.tile_set = _create_runtime_tile_set(Color(0.0, 0.0, 0.0, 0.0), Color(0.12, 0.35, 0.32, 0.35))
	walls_layer.tile_set = _create_runtime_tile_set(Color(0.16, 0.23, 0.25, 0.96), Color(0.3, 0.48, 0.47, 0.8))
	wall_detail_layer.tile_set = _create_runtime_tile_set(Color(0.0, 0.0, 0.0, 0.0), Color(0.7, 0.28, 0.18, 0.55))
	decoration_layer.tile_set = _create_runtime_tile_set(Color(0.04, 0.12, 0.12, 0.45), Color(0.28, 0.68, 0.56, 0.62))
	foreground_layer.tile_set = _create_runtime_tile_set(Color(0.02, 0.04, 0.045, 0.42), Color(0.2, 0.32, 0.33, 0.5))
	for y in range(1, 24):
		for x in range(1, 39):
			floor_layer.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
			if (x * 3 + y * 5) % 13 == 0:
				floor_detail_layer.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
	for x in range(1, 39):
		walls_layer.set_cell(Vector2i(x, 1), 0, Vector2i.ZERO)
		walls_layer.set_cell(Vector2i(x, 23), 0, Vector2i.ZERO)
	for y in range(1, 24):
		walls_layer.set_cell(Vector2i(1, y), 0, Vector2i.ZERO)
		walls_layer.set_cell(Vector2i(38, y), 0, Vector2i.ZERO)
		if y not in [14, 15, 20, 21]:
			walls_layer.set_cell(Vector2i(26, y), 0, Vector2i.ZERO)
		if y % 4 == 0:
			wall_detail_layer.set_cell(Vector2i(1, y), 0, Vector2i.ZERO)
			wall_detail_layer.set_cell(Vector2i(38, y), 0, Vector2i.ZERO)
	for cell in [Vector2i(4, 5), Vector2i(11, 4), Vector2i(12, 12), Vector2i(20, 10), Vector2i(34, 14), Vector2i(6, 21)]:
		decoration_layer.set_cell(cell, 0, Vector2i.ZERO)
	for x in range(1, 39, 6):
		foreground_layer.set_cell(Vector2i(x, 23), 0, Vector2i.ZERO)


func _create_runtime_tile_set(base_colour: Color, line_colour: Color) -> TileSet:
	return RuntimeLevelBuilder.create_tile_set(base_colour, line_colour)


func _process(delta: float) -> void:
	if _alarm_active and not get_tree().paused:
		_alarm_timer -= delta
		if _alarm_timer <= 0.0:
			noise_system.emit_noise(NoiseEvent.new(Vector2(430.0, 180.0), 1100.0, &"alarm", self, 1.4))
			_alarm_timer = 1.4
	combat_hud.update_status(get_tree().get_nodes_in_group(&"enemies").size(), Engine.get_frames_per_second(), player.invulnerable)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		_set_paused(not get_tree().paused)
	if not OS.is_debug_build():
		return
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.physical_keycode:
		KEY_F2:
			player.access_inventory.grant(&"engineering")
		KEY_F3:
			_set_main_power(not power_grid.is_powered(&"main"))
		KEY_F4:
			noise_system.emit_noise(NoiseEvent.new(player.global_position, 500.0, &"debug", player))
		KEY_F5:
			_trigger_alarm()
		KEY_F6:
			mission.skip_current()
		KEY_F7:
			_restart_checkpoint()
		KEY_F8:
			mobile_controls.toggle_debug_visibility()


func _build_navigation() -> void:
	var polygon := NavigationPolygon.new()
	var columns := PackedFloat32Array([50.0, 1030.0, 1050.0, 1550.0])
	var rows := PackedFloat32Array([50.0, 540.0, 630.0, 800.0, 890.0, 950.0])
	var vertices := PackedVector2Array()
	for y in rows:
		for x in columns:
			vertices.append(Vector2(x, y))
	polygon.vertices = vertices
	for row_index in rows.size() - 1:
		_add_navigation_cell(polygon, row_index, 0, columns.size())
		_add_navigation_cell(polygon, row_index, 2, columns.size())
		if row_index in [1, 3]:
			_add_navigation_cell(polygon, row_index, 1, columns.size())
	navigation_region.navigation_polygon = polygon


func _add_navigation_cell(polygon: NavigationPolygon, row: int, column: int, width: int) -> void:
	var top_left := row * width + column
	var top_right := top_left + 1
	var bottom_left := (row + 1) * width + column
	var bottom_right := bottom_left + 1
	polygon.add_polygon(PackedInt32Array([top_left, top_right, bottom_right, bottom_left]))


func _build_collision() -> void:
	_add_wall(Vector2(800.0, 40.0), Vector2(1520.0, 20.0))
	_add_wall(Vector2(800.0, 960.0), Vector2(1520.0, 20.0))
	_add_wall(Vector2(40.0, 500.0), Vector2(20.0, 920.0))
	_add_wall(Vector2(1560.0, 500.0), Vector2(20.0, 920.0))
	# Engineering bulkhead: one credential door and one post-power shortcut.
	_add_wall(Vector2(1040.0, 270.0), Vector2(20.0, 460.0))
	_add_wall(Vector2(1040.0, 500.0), Vector2(20.0, 80.0))
	_add_wall(Vector2(1040.0, 715.0), Vector2(20.0, 170.0))
	_add_wall(Vector2(1040.0, 925.0), Vector2(20.0, 70.0))


func _add_wall(position: Vector2, size: Vector2) -> void:
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, position, size)


func _build_interactables() -> void:
	engineering_door = DOOR_SCENE.instantiate() as Door
	engineering_door.name = "EngineeringDoor"
	engineering_door.position = Vector2(1040.0, 585.0)
	engineering_door.definition = DoorDefinition.new()
	engineering_door.definition.access_credential = &"engineering"
	engineering_door.definition.locked_message = "ENGINEERING CLEARANCE REQUIRED"
	doors.add_child(engineering_door)
	_connect_interactable(engineering_door)

	shortcut_door = DOOR_SCENE.instantiate() as Door
	shortcut_door.name = "PoweredShortcutDoor"
	shortcut_door.position = Vector2(1040.0, 845.0)
	shortcut_door.definition = DoorDefinition.new()
	shortcut_door.definition.requires_power = true
	shortcut_door.definition.power_circuit = &"main"
	doors.add_child(shortcut_door)
	shortcut_door.bind_power_grid(power_grid)
	_connect_interactable(shortcut_door)

	communications_terminal = TERMINAL_SCENE.instantiate() as Terminal
	communications_terminal.name = "CommunicationsTerminal"
	communications_terminal.position = Vector2(430.0, 155.0)
	communications_terminal.terminal_id = &"communications"
	communications_terminal.display_name = "Transmit Distress Signal"
	communications_terminal.requires_power = true
	communications_terminal.power_circuit = &"communications"
	terminals.add_child(communications_terminal)
	communications_terminal.bind_power_grid(power_grid)
	communications_terminal.activated.connect(_on_terminal_activated)
	_connect_interactable(communications_terminal)

	power_terminal = TERMINAL_SCENE.instantiate() as Terminal
	power_terminal.name = "AuxiliaryPowerTerminal"
	power_terminal.position = Vector2(1380.0, 610.0)
	power_terminal.terminal_id = &"auxiliary_power"
	power_terminal.display_name = "Restore Auxiliary Power"
	terminals.add_child(power_terminal)
	power_terminal.activated.connect(_on_terminal_activated)
	_connect_interactable(power_terminal)
	_connect_interactable(extraction)
	extraction.extraction_requested.connect(func() -> void: mission.notify_event(&"extraction_reached"))


func _connect_interactable(interactable: Interactable) -> void:
	interactable.feedback_requested.connect(mission_hud.notify)
	if interactable is Door:
		(interactable as Door).noise_requested.connect(noise_system.emit_noise)


func _build_lighting() -> void:
	for light_data in [
		[Vector2(220, 180), &"emergency"], [Vector2(560, 180), &"main"],
		[Vector2(460, 500), &"emergency"], [Vector2(820, 420), &"main"],
		[Vector2(1220, 300), &"main"], [Vector2(1380, 650), &"main"],
		[Vector2(780, 820), &"main"], [Vector2(250, 850), &"emergency"],
	]:
		var light := PoweredLight.new()
		light.position = light_data[0]
		light.circuit = light_data[1]
		light.light_colour = Color(1.0, 0.25, 0.18) if light.circuit == &"emergency" else Color(0.48, 0.82, 1.0)
		$Lighting/PoweredLights.add_child(light)
		light.bind_power_grid(power_grid)


func _build_triggers() -> void:
	var communications_trigger := _add_trigger(Vector2(430.0, 180.0), Vector2(250.0, 190.0), &"communications")
	communications_trigger.one_shot = false
	communications_trigger.reached.connect(_on_communications_reached)
	var engineering_trigger := _add_trigger(Vector2(1310.0, 610.0), Vector2(300.0, 270.0), &"engineering_reached")
	engineering_trigger.reached.connect(func(event_id: StringName) -> void: mission.notify_event(event_id))


func _add_trigger(position: Vector2, size: Vector2, event_id: StringName) -> ReachTrigger:
	var trigger := ReachTrigger.new()
	trigger.position = position
	trigger.event_id = event_id
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = size
	shape.shape = rectangle
	trigger.add_child(shape)
	triggers.add_child(trigger)
	return trigger


func _build_pickups() -> void:
	credential_pickup = CREDENTIAL_SCENE.instantiate() as CredentialPickup
	credential_pickup.name = "EngineeringCredential"
	credential_pickup.position = Vector2(500.0, 505.0)
	pickups.add_child(credential_pickup)
	credential_pickup.credential_collected.connect(func(_id: StringName) -> void:
		world_flags.credential_collected = true
		mission.notify_event(&"engineering_access_collected")
		_save_checkpoint(&"engineering_access")
	)
	_connect_interactable(credential_pickup)
	for pickup_data in [[HEALTH_SCENE, Vector2(780, 480)], [HEALTH_SCENE, Vector2(1240, 760)], [AMMO_SCENE, Vector2(650, 250)], [AMMO_SCENE, Vector2(1340, 430)]]:
		var pickup := (pickup_data[0] as PackedScene).instantiate() as Area2D
		pickup.position = pickup_data[1]
		pickups.add_child(pickup)


func _build_audio() -> void:
	if DisplayServer.get_name() == "headless":
		return
	_ambient_audio = AudioStreamPlayer.new()
	_ambient_audio.name = "EmergencyAmbience"
	_ambient_audio.bus = &"Ambience"
	var stream := ToneFactory.create_tone(42.0, 2.0, 0.025, false)
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = stream.data.size() / 2
	_ambient_audio.stream = stream
	$Audio.add_child(_ambient_audio)
	_ambient_audio.play()


func _exit_tree() -> void:
	if is_instance_valid(_ambient_audio):
		_ambient_audio.stop()
		_ambient_audio.stream = null


func _connect_ui() -> void:
	combat_hud.resume_requested.connect(func() -> void: _set_paused(false))
	combat_hud.restart_requested.connect(_restart_checkpoint)
	combat_hud.quit_requested.connect(_quit_to_bootstrap)
	mission_hud.replay_requested.connect(_continue_campaign)
	mission_hud.quit_requested.connect(_quit_to_bootstrap)
	mobile_controls.pause_requested.connect(func() -> void: _set_paused(not get_tree().paused))


func _spawn_initial_enemies() -> void:
	for spawn_position in [Vector2(310, 235), Vector2(730, 390), Vector2(820, 520), Vector2(1230, 480), Vector2(1450, 710)]:
		_spawn_drone(spawn_position)


func _spawn_drone(spawn_position: Vector2) -> Drone:
	var drone := DRONE_SCENE.instantiate() as Drone
	drone.position = spawn_position
	drone.perception_enabled = true
	drone.set_target(player)
	enemies.add_child(drone)
	noise_system.register_listener(drone.noise_listener)
	return drone


func _on_communications_reached(_event_id: StringName) -> void:
	if mission.active_index == 0:
		mission_hud.notify("COMMUNICATIONS OFFLINE — NO FACILITY POWER")
		mission.notify_event(&"communications_offline")
	elif mission.active_index == 4 and power_grid.is_powered(&"communications"):
		mission.notify_event(&"communications_returned")


func _on_terminal_activated(terminal_id: StringName, _player: Player) -> void:
	if terminal_id == &"auxiliary_power" and mission.active_index == 3:
		_set_main_power(true)
		world_flags.power_restored = true
		mission.notify_event(&"power_restored")
		_save_checkpoint(&"power_restored")
	elif terminal_id == &"communications" and power_grid.is_powered(&"communications") and mission.active_index == 5:
		world_flags.distress_transmitted = true
		mission.notify_event(&"distress_transmitted")
		_save_checkpoint(&"communications")
		_trigger_alarm()


func _on_credential_added(credential_id: StringName) -> void:
	mission_hud.notify("%s ACCESS ACQUIRED" % String(credential_id).to_upper())


func _on_objective_completed(_objective_id: StringName, title: String) -> void:
	mission_hud.notify("OBJECTIVE COMPLETE  •  %s" % title.to_upper())


func _on_mission_completed() -> void:
	_alarm_active = false
	_set_combat_music(false)
	player.input_enabled = false
	var result := MissionResult.new()
	result.mission_id = &"station_blackout"
	result.completed = true
	if _session() != null:
		_session().complete_mission(result)
	mission_hud.show_complete("STATION BLACKOUT COMPLETE", "Distress signal transmitted. Medical Wing unlocked.", "Continue to Medical Wing")


func _set_main_power(enabled: bool) -> void:
	if enabled:
		power_grid.restore_main_power()
	else:
		power_grid.set_powered(&"main", false)
		power_grid.set_powered(&"communications", false)
	canvas_modulate.color = Color(0.68, 0.76, 0.8) if enabled else Color(0.20, 0.25, 0.30)
	mission_hud.set_power(enabled)


func _on_power_changed(circuit: StringName, powered: bool) -> void:
	if circuit == &"main":
		mission_hud.set_power(powered)


func _trigger_alarm() -> void:
	if _alarm_active:
		return
	_alarm_active = true
	_set_combat_music(true)
	_alarm_timer = 0.0
	extraction.set_active(true)
	mission_hud.notify("DISTRESS SIGNAL SENT — ALARM ACTIVE — REACH EXTRACTION", 4.0)
	for spawn_position in [Vector2(530, 300), Vector2(720, 700), Vector2(900, 240), Vector2(1180, 820), Vector2(1450, 250), Vector2(900, 900)]:
		_spawn_drone(spawn_position)


func _save_checkpoint(checkpoint_id: StringName) -> void:
	var state := CheckpointState.new()
	state.checkpoint_id = checkpoint_id
	state.player_position = player.global_position
	state.player_health = player.health_component.current_health
	state.magazine_ammo = player.weapon.current_magazine
	state.reserve_ammo = player.weapon.reserve_ammo
	state.weapon_states = player.weapon_inventory.snapshot()
	state.credentials = player.access_inventory.snapshot()
	state.mission_state = mission.snapshot()
	state.power_state = power_grid.snapshot()
	state.world_flags = world_flags.duplicate(true)
	state.door_states = {
		"engineering": engineering_door.is_open(),
		"shortcut": shortcut_door.is_open(),
	}
	checkpoint_manager.save(state)
	if get_tree().current_scene == self and _session() != null:
		_session().save_checkpoint(&"station_blackout", state.to_dictionary())


func _restore_checkpoint(state: CheckpointState) -> void:
	checkpoint_manager.save(state)
	player.global_position = state.player_position
	player.restore_health()
	var missing_health := player.health_component.maximum_health - state.player_health
	if missing_health > 0.0:
		player.health_component.apply_damage(DamageInfo.new(missing_health))
	if state.weapon_states.is_empty():
		player.weapon.current_magazine = state.magazine_ammo
		player.weapon.reserve_ammo = state.reserve_ammo
		player.weapon.ammo_changed.emit(state.magazine_ammo, state.reserve_ammo)
	else:
		player.weapon_inventory.restore(state.weapon_states)
	player.access_inventory.restore(state.credentials)
	mission.restore(state.mission_state)
	power_grid.restore(state.power_state)
	world_flags = state.world_flags.duplicate(true)
	credential_pickup.restore_collected(bool(world_flags.get("credential_collected", false)))
	engineering_door.restore_open(bool(state.door_states.get("engineering", false)))
	shortcut_door.restore_open(bool(state.door_states.get("shortcut", false)))
	_set_main_power(bool(state.power_state.get(&"main", false)))
	if bool(world_flags.get("distress_transmitted", false)):
		_trigger_alarm()


func _on_player_died() -> void:
	get_tree().paused = true
	combat_hud.show_death()


func _set_paused(enabled: bool) -> void:
	get_tree().paused = enabled
	combat_hud.show_pause(enabled)


func _restart_checkpoint() -> void:
	get_tree().paused = false
	if checkpoint_manager.prepare_restart():
		get_tree().reload_current_scene()


func _restart_mission() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	get_tree().reload_current_scene()


func _continue_campaign() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	if _session() != null:
		_session().transition_to_mission(&"medical_wing")
	else:
		get_tree().change_scene_to_file("res://levels/campaign/medical_wing/medical_wing.tscn")


func _quit_to_bootstrap() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	if _session() != null:
		_session().transition_to_scene("res://ui/menus/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")


func _session() -> GameSessionState:
	return get_node_or_null("/root/GameSession") as GameSessionState


func _set_combat_music(enabled: bool) -> void:
	var director: Node = get_node_or_null("/root/MusicDirector")
	if director != null:
		director.call("set_combat", enabled)


func _draw() -> void:
	draw_rect(MAP_RECT, Color(0.035, 0.065, 0.075), true)
	for x in range(80, 1560, 40):
		draw_line(Vector2(x, 40), Vector2(x, 960), Color(0.08, 0.13, 0.14, 0.42), 1.0)
	for y in range(80, 960, 40):
		draw_line(Vector2(40, y), Vector2(1560, y), Color(0.08, 0.13, 0.14, 0.42), 1.0)
	var zones := [
		[Rect2(90, 90, 230, 230), "RECEPTION"], [Rect2(340, 80, 300, 220), "COMMUNICATIONS"],
		[Rect2(330, 380, 310, 240), "SECURITY"], [Rect2(660, 300, 340, 350), "RESEARCH LABS"],
		[Rect2(1090, 350, 420, 390), "ENGINEERING"], [Rect2(90, 760, 300, 150), "EXTRACTION"],
	]
	for zone in zones:
		draw_rect(zone[0], Color(0.065, 0.11, 0.12, 0.82), true)
		draw_rect(zone[0], Color(0.18, 0.42, 0.4, 0.72), false, 3.0)
		draw_string(ThemeDB.fallback_font, zone[0].position + Vector2(14, 25), zone[1], HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(0.34, 0.78, 0.68, 0.72))
	for wall in [Rect2(30, 30, 1540, 20), Rect2(30, 950, 1540, 20), Rect2(30, 30, 20, 940), Rect2(1550, 30, 20, 940)]:
		draw_rect(wall, Color(0.18, 0.25, 0.27), true)
	draw_line(Vector2(1040, 40), Vector2(1040, 540), Color(0.28, 0.38, 0.4), 18.0)
	draw_line(Vector2(1040, 630), Vector2(1040, 800), Color(0.28, 0.38, 0.4), 18.0)
	draw_line(Vector2(1040, 890), Vector2(1040, 960), Color(0.28, 0.38, 0.4), 18.0)

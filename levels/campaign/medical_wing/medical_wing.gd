class_name MedicalWing
extends Node2D

const MAP_RECT := Rect2(40.0, 40.0, 1520.0, 920.0)
const DOOR_SCENE := preload("res://features/doors/door.tscn")
const TERMINAL_SCENE := preload("res://features/terminals/terminal.tscn")
const PICKUP_SCENE := preload("res://features/inventory/pickup.tscn")
const ELECTRICAL_SCENE := preload("res://features/hazards/electricity/electrical_hazard.tscn")
const GAS_SCENE := preload("res://features/hazards/gas/gas_hazard.tscn")
const FIRE_SCENE := preload("res://features/hazards/fire/fire_hazard.tscn")
const DRONE_SCENE := preload("res://features/enemies/drone/drone.tscn")
const HUNTER_SCENE := preload("res://features/enemies/hunter/hunter.tscn")
const SPITTER_SCENE := preload("res://features/enemies/spitter/spitter.tscn")
const MEDICAL_ACCESS := preload("res://resources/items/medical_access.tres")
const SHOTGUN_ITEM := preload("res://resources/items/shotgun.tres")
const SHELLS_ITEM := preload("res://resources/items/shotgun_shells.tres")

@onready var player: Player = $Player
@onready var mission: MissionController = $Mission
@onready var power_grid: PowerGrid = $PowerGrid
@onready var noise_system: NoiseSystem = $NoiseSystem
@onready var checkpoint_manager: CheckpointManager = $CheckpointManager
@onready var extraction: ExtractionZone = $World/Interactive/Extraction
@onready var combat_hud: CombatHud = $CombatHud
@onready var mission_hud: MissionHud = $MissionHud
@onready var mobile_controls: MobileControls = $MobileControls

var quarantine_door: Door
var hazard_terminal: Terminal
var archive_terminal: Terminal
var medical_pickup: ItemPickup
var shotgun_pickup: ItemPickup
var electrical_hazard: ElectricalHazard
var gas_hazard: GasHazard
var hunter_encounter: Encounter
var spitter_encounter: Encounter
var world_flags := {
	"medical_access": false,
	"hazard_cleared": false,
	"archive_reached": false,
	"data_recovered": false,
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_world()
	_build_interactables()
	_build_hazards()
	_build_triggers()
	_build_pickups()
	_build_encounters()
	_connect_systems()
	player.camera.limit_left = int(MAP_RECT.position.x)
	player.camera.limit_top = int(MAP_RECT.position.y)
	player.camera.limit_right = int(MAP_RECT.end.x)
	player.camera.limit_bottom = int(MAP_RECT.end.y)
	var restored := false
	var pending := checkpoint_manager.consume_pending()
	if pending != null:
		_restore_checkpoint(pending)
		restored = true
	elif get_tree().current_scene == self:
		var persisted := _session().checkpoint_for(&"medical_wing") if _session() != null else {}
		if not persisted.is_empty():
			_restore_checkpoint(CheckpointState.from_dictionary(persisted))
			restored = true
	if not restored:
		if _session() != null and not _session().campaign_loadout().is_empty():
			player.weapon_inventory.restore(_session().campaign_loadout())
		_save_checkpoint(&"mission_start")
	mission_hud.notify("MEDICAL WING — QUARANTINE FAILURE", 3.0)
	queue_redraw()


func _process(_delta: float) -> void:
	combat_hud.update_status(get_tree().get_nodes_in_group(&"enemies").size(), Engine.get_frames_per_second(), player.invulnerable)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		_set_paused(not get_tree().paused)
	if not OS.is_debug_build():
		return


func _build_world() -> void:
	var floor := $World/Floor as TileMapLayer
	var detail := $World/FloorDetail as TileMapLayer
	var walls := $World/Walls as TileMapLayer
	floor.tile_set = RuntimeLevelBuilder.create_tile_set(Color(0.045, 0.065, 0.06), Color(0.15, 0.28, 0.22, 0.55))
	detail.tile_set = RuntimeLevelBuilder.create_tile_set(Color.TRANSPARENT, Color(0.32, 0.68, 0.48, 0.25))
	walls.tile_set = RuntimeLevelBuilder.create_tile_set(Color(0.19, 0.23, 0.21), Color(0.55, 0.62, 0.52, 0.55))
	for y in range(1, 24):
		for x in range(1, 39):
			floor.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
			if (x + y * 7) % 17 == 0:
				detail.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
	for x in range(1, 39):
		walls.set_cell(Vector2i(x, 1), 0, Vector2i.ZERO)
		walls.set_cell(Vector2i(x, 23), 0, Vector2i.ZERO)
	for y in range(1, 24):
		walls.set_cell(Vector2i(1, y), 0, Vector2i.ZERO)
		walls.set_cell(Vector2i(38, y), 0, Vector2i.ZERO)
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(800, 40), Vector2(1520, 20))
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(800, 960), Vector2(1520, 20))
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(40, 500), Vector2(20, 920))
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(1560, 500), Vector2(20, 920))
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(690, 210), Vector2(20, 320))
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(690, 700), Vector2(20, 400))
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(1180, 190), Vector2(20, 300))
	RuntimeLevelBuilder.add_wall($World/StaticGeometry, Vector2(1180, 700), Vector2(20, 400))
	$World/NavigationRegion.navigation_polygon = RuntimeLevelBuilder.rectangular_navigation(MAP_RECT)


func _build_interactables() -> void:
	quarantine_door = DOOR_SCENE.instantiate() as Door
	quarantine_door.position = Vector2(690, 465)
	quarantine_door.definition = DoorDefinition.new()
	quarantine_door.definition.access_credential = &"medical"
	quarantine_door.definition.locked_message = "MEDICAL CLEARANCE REQUIRED"
	$World/Interactive/Doors.add_child(quarantine_door)
	_connect_interactable(quarantine_door)
	hazard_terminal = _add_terminal(&"hazard_control", "Cycle Quarantine Systems", Vector2(900, 720))
	archive_terminal = _add_terminal(&"research_archive", "Download Containment Archive", Vector2(1370, 250))
	_connect_interactable(extraction)
	extraction.extraction_requested.connect(func() -> void: mission.notify_event(&"extraction_reached"))


func _add_terminal(id: StringName, title: String, position: Vector2) -> Terminal:
	var terminal := TERMINAL_SCENE.instantiate() as Terminal
	terminal.position = position
	terminal.terminal_id = id
	terminal.display_name = title
	$World/Interactive/Terminals.add_child(terminal)
	terminal.activated.connect(_on_terminal_activated)
	_connect_interactable(terminal)
	return terminal


func _connect_interactable(interactable: Interactable) -> void:
	interactable.feedback_requested.connect(mission_hud.notify)
	if interactable is Door:
		(interactable as Door).noise_requested.connect(noise_system.emit_noise)


func _build_hazards() -> void:
	power_grid.set_powered(&"quarantine", true)
	power_grid.set_powered(&"ventilation", false)
	electrical_hazard = ELECTRICAL_SCENE.instantiate() as ElectricalHazard
	electrical_hazard.position = Vector2(770, 530)
	$World/Hazards.add_child(electrical_hazard)
	electrical_hazard.bind_power_grid(power_grid)
	gas_hazard = GAS_SCENE.instantiate() as GasHazard
	gas_hazard.position = Vector2(1010, 610)
	$World/Hazards.add_child(gas_hazard)
	gas_hazard.bind_power_grid(power_grid)
	var fire := FIRE_SCENE.instantiate() as FireHazard
	fire.position = Vector2(1270, 735)
	$World/Hazards.add_child(fire)


func _build_triggers() -> void:
	_add_trigger(Vector2(340, 280), Vector2(250, 210), &"triage_reached").reached.connect(_on_reach_event)
	_add_trigger(Vector2(790, 465), Vector2(150, 260), &"wards_entered").reached.connect(_on_reach_event)
	_add_trigger(Vector2(1300, 340), Vector2(220, 250), &"archive_reached").reached.connect(_on_reach_event)


func _add_trigger(position: Vector2, size: Vector2, id: StringName) -> ReachTrigger:
	var trigger := ReachTrigger.new()
	trigger.position = position
	trigger.event_id = id
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	trigger.add_child(collision)
	$MissionTriggers.add_child(trigger)
	return trigger


func _build_pickups() -> void:
	medical_pickup = _add_pickup(MEDICAL_ACCESS, 1, Vector2(465, 700))
	medical_pickup.item_collected.connect(func(_id: StringName, _quantity: int) -> void:
		world_flags.medical_access = true
		mission.notify_event(&"medical_access_collected")
		_save_checkpoint(&"medical_access")
	)
	shotgun_pickup = _add_pickup(SHOTGUN_ITEM, 1, Vector2(560, 690))
	_add_pickup(SHELLS_ITEM, 18, Vector2(1060, 810))
	_add_pickup(SHELLS_ITEM, 12, Vector2(1420, 510))


func _add_pickup(item: ItemDefinition, quantity: int, position: Vector2) -> ItemPickup:
	var pickup := PICKUP_SCENE.instantiate() as ItemPickup
	pickup.definition = item
	pickup.quantity = quantity
	pickup.position = position
	$World/Interactive/Pickups.add_child(pickup)
	_connect_interactable(pickup)
	return pickup


func _build_encounters() -> void:
	var points: Array[EnemySpawnPoint] = []
	for data in [[&"triage", Vector2(470, 320)], [&"ward_left", Vector2(820, 380)], [&"ward_right", Vector2(1060, 760)], [&"archive", Vector2(1390, 420)], [&"escape", Vector2(900, 850)]]:
		var point := EnemySpawnPoint.new()
		point.id = data[0]
		point.position = data[1]
		$SpawnPoints.add_child(point)
		points.append(point)
	hunter_encounter = _make_encounter(&"hunter_intro", [[&"ward_left", HUNTER_SCENE, 1], [&"ward_right", DRONE_SCENE, 2]], points)
	spitter_encounter = _make_encounter(&"archive_breach", [[&"archive", SPITTER_SCENE, 2], [&"escape", HUNTER_SCENE, 1], [&"ward_right", DRONE_SCENE, 2]], points)
	var opening := _make_encounter(&"triage_patrol", [[&"triage", DRONE_SCENE, 2]], points)
	opening.start()


func _make_encounter(id: StringName, entries: Array, points: Array[EnemySpawnPoint]) -> Encounter:
	var wave := WaveDefinition.new()
	for entry: Array in entries:
		wave.spawn_point_ids.append(String(entry[0]))
		wave.enemy_scenes.append(entry[1] as PackedScene)
		wave.counts.append(int(entry[2]))
	wave.spawn_interval = 0.32
	var definition := EncounterDefinition.new()
	definition.id = id
	definition.waves.append(wave)
	var encounter := Encounter.new()
	encounter.definition = definition
	encounter.configure(points, $Enemies, player, noise_system)
	$Encounters.add_child(encounter)
	encounter.started.connect(func(_id: StringName) -> void: _set_combat_music(true))
	encounter.completed.connect(func(_id: StringName) -> void: _set_combat_music(false))
	return encounter


func _connect_systems() -> void:
	player.weapon_inventory.noise_requested.connect(noise_system.emit_noise)
	player.died.connect(_on_player_died)
	player.interaction_detector.prompt_changed.connect(mission_hud.set_prompt)
	mission.active_objective_changed.connect(mission_hud.set_objective)
	mission.objective_completed.connect(func(_id: StringName, title: String) -> void: mission_hud.notify("OBJECTIVE COMPLETE  •  %s" % title.to_upper()))
	mission.mission_completed.connect(_on_mission_completed)
	combat_hud.bind_player(player)
	mobile_controls.bind_player(player)
	$DevelopmentDebugOverlay.bind(player, mission, power_grid, checkpoint_manager)
	combat_hud.resume_requested.connect(func() -> void: _set_paused(false))
	combat_hud.restart_requested.connect(_restart_checkpoint)
	combat_hud.quit_requested.connect(_return_to_menu)
	mission_hud.replay_requested.connect(_continue_campaign)
	mission_hud.quit_requested.connect(_return_to_menu)
	mobile_controls.pause_requested.connect(func() -> void: _set_paused(not get_tree().paused))
	var objective := mission.get_active_objective()
	if objective != null:
		mission_hud.set_objective(objective.title, objective.details, 1, mission.objectives.size())
	mission_hud.set_power(false)


func _on_reach_event(event_id: StringName) -> void:
	if not mission.notify_event(event_id):
		return
	if event_id == &"wards_entered":
		hunter_encounter.start()
		mission_hud.notify("MOVEMENT DETECTED — HUNTER SIGNATURE", 3.0)
	elif event_id == &"archive_reached":
		world_flags.archive_reached = true
		spitter_encounter.start()
		_save_checkpoint(&"research_archive")
		mission_hud.notify("RANGED BIOFORM DETECTED — KEEP MOVING", 3.0)


func _on_terminal_activated(terminal_id: StringName, _player: Player) -> void:
	if terminal_id == &"hazard_control" and mission.active_index == 3:
		power_grid.set_powered(&"quarantine", false)
		power_grid.set_powered(&"ventilation", true)
		world_flags.hazard_cleared = true
		mission.notify_event(&"hazard_cleared")
		_save_checkpoint(&"hazard_cleared")
		mission_hud.notify("CONDUIT ISOLATED — VENTILATION ONLINE", 3.0)
	elif terminal_id == &"research_archive" and mission.active_index == 5:
		world_flags.data_recovered = true
		extraction.set_active(true)
		mission.notify_event(&"data_recovered")
		_save_checkpoint(&"data_recovered")
		mission_hud.notify("ARCHIVE SECURED — FACILITY RESPONSE ACTIVE", 3.5)


func _save_checkpoint(id: StringName) -> void:
	var state := CheckpointState.new()
	state.checkpoint_id = id
	state.player_position = player.global_position
	state.player_health = player.health_component.current_health
	state.weapon_states = player.weapon_inventory.snapshot()
	state.credentials = player.access_inventory.snapshot()
	state.mission_state = mission.snapshot()
	state.power_state = power_grid.snapshot()
	state.world_flags = world_flags.duplicate(true)
	state.door_states = {"quarantine": quarantine_door.is_open(), "medical_pickup": medical_pickup.collected, "shotgun_pickup": shotgun_pickup.collected}
	checkpoint_manager.save(state)
	if get_tree().current_scene == self and _session() != null:
		_session().save_checkpoint(&"medical_wing", state.to_dictionary())
	mission_hud.notify("CHECKPOINT SAVED", 1.4)


func _restore_checkpoint(state: CheckpointState) -> void:
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
	world_flags = state.world_flags.duplicate(true)
	quarantine_door.restore_open(bool(state.door_states.get("quarantine", false)))
	medical_pickup.restore_collected(bool(state.door_states.get("medical_pickup", false)))
	shotgun_pickup.restore_collected(bool(state.door_states.get("shotgun_pickup", false)))
	if bool(world_flags.get("data_recovered", false)):
		extraction.set_active(true)
	elif mission.active_index >= 4:
		spitter_encounter.start()
	elif mission.active_index >= 2:
		hunter_encounter.start()


func _on_mission_completed() -> void:
	player.input_enabled = false
	_set_combat_music(false)
	var result := MissionResult.new()
	result.mission_id = &"medical_wing"
	result.completed = true
	if _session() != null:
		_session().complete_mission(result)
	mission_hud.show_complete("MEDICAL WING COMPLETE", "Containment archive recovered. Cargo Deck unlocked.", "Continue to Cargo Deck")


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


func _return_to_menu() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	if _session() != null:
		_session().transition_to_scene("res://ui/menus/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")


func _continue_campaign() -> void:
	get_tree().paused = false
	CheckpointManager.clear_pending()
	if _session() != null:
		_session().transition_to_next_mission(&"medical_wing")
	else:
		get_tree().change_scene_to_file("res://levels/campaign/cargo_deck/cargo_deck.tscn")


func _session() -> GameSessionState:
	return get_node_or_null("/root/GameSession") as GameSessionState


func _set_combat_music(enabled: bool) -> void:
	var director: Node = get_node_or_null("/root/MusicDirector")
	if director != null:
		director.call("set_combat", enabled)


func _draw() -> void:
	draw_rect(MAP_RECT, Color(0.025, 0.045, 0.04), true)
	for label_data in [[Vector2(155, 145), "ARRIVAL"], [Vector2(300, 260), "TRIAGE"], [Vector2(735, 185), "QUARANTINE WARDS"], [Vector2(1215, 160), "RESEARCH ARCHIVE"], [Vector2(180, 835), "EVAC"]]:
		draw_string(ThemeDB.fallback_font, label_data[0], label_data[1], HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.45, 0.95, 0.68, 0.72))
	for gurney in [Vector2(360, 410), Vector2(520, 280), Vector2(850, 280), Vector2(1050, 450), Vector2(1320, 620)]:
		draw_rect(Rect2(gurney - Vector2(22, 8), Vector2(44, 16)), Color(0.28, 0.38, 0.34), true)
		draw_circle(gurney + Vector2(-15, 11), 4, Color(0.12, 0.16, 0.15))
		draw_circle(gurney + Vector2(15, 11), 4, Color(0.12, 0.16, 0.15))

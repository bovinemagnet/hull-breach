class_name DevelopmentDebugOverlay
extends CanvasLayer

@onready var label: Label = %DebugText

var player: Player
var mission: MissionController
var power_grid: PowerGrid
var checkpoint_manager: CheckpointManager
var visible_state := false


func _ready() -> void:
	layer = 90
	visible = false
	if not OS.is_debug_build():
		queue_free()
		return
	set_process(true)


func bind(p_player: Player, p_mission: MissionController, p_power_grid: PowerGrid, p_checkpoints: CheckpointManager) -> void:
	player = p_player
	mission = p_mission
	power_grid = p_power_grid
	checkpoint_manager = p_checkpoints


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_F1:
		visible_state = not visible_state
		visible = visible_state


func _process(_delta: float) -> void:
	if not visible_state or player == null or mission == null:
		return
	var objective := mission.get_active_objective()
	var enemy_lines := PackedStringArray()
	for enemy in get_tree().get_nodes_in_group(&"enemies"):
		if enemy is Drone:
			var drone := enemy as Drone
			enemy_lines.append("%s:%s" % [drone.definition.id, Drone.State.keys()[drone.state]])
		if enemy_lines.size() >= 8:
			break
	var checkpoint_id := "none"
	if checkpoint_manager != null and checkpoint_manager.current_state != null:
		checkpoint_id = String(checkpoint_manager.current_state.checkpoint_id)
	label.text = "PLAYER  %.0f HP  %s %d/%d\nMISSION %s  OBJECTIVE %s\nPOWER %s\nCHECKPOINT %s  SAVE %s\nAI %s" % [
		player.health_component.current_health,
		player.weapon.definition.id,
		player.weapon.current_magazine,
		player.weapon.reserve_ammo,
		mission.definition.id,
		String(objective.id) if objective != null else "complete",
		JSON.stringify(power_grid.snapshot()) if power_grid != null else "{}",
		checkpoint_id,
		_save_status(),
		", ".join(enemy_lines),
	]


func _save_status() -> String:
	var service: Node = get_node_or_null("/root/SaveService")
	if service == null:
		return "unavailable"
	return "present" if bool(service.call("has_save")) else "empty"

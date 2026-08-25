class_name GameSessionState
extends Node

signal campaign_changed
signal transition_started(scene_path: String)

const MISSION_SCENES := {
	&"station_blackout": "res://levels/campaign/station_blackout/station_blackout.tscn",
	&"medical_wing": "res://levels/campaign/medical_wing/medical_wing.tscn",
}

var save_data: Dictionary = {}
var difficulty_id: StringName = &"standard"
var difficulty: DifficultyDefinition
var transition_in_progress := false


func _ready() -> void:
	load_campaign()


func load_campaign() -> bool:
	var service := _save_service()
	save_data = service.load() if service != null else {}
	if save_data.is_empty():
		save_data = service.default_data() if service != null else _fallback_data()
	difficulty_id = StringName(save_data.get("profile", {}).get("difficulty", "standard"))
	difficulty = DifficultyService.load_profile(difficulty_id)
	campaign_changed.emit()
	return service.has_save() if service != null else false


func new_game(selected_difficulty: StringName) -> void:
	difficulty_id = selected_difficulty if DifficultyService.PROFILES.has(selected_difficulty) else &"standard"
	difficulty = DifficultyService.load_profile(difficulty_id)
	var service := _save_service()
	save_data = service.default_data(difficulty_id) if service != null else _fallback_data(difficulty_id)
	if service != null:
		service.save(save_data)
	transition_to_mission(&"station_blackout")


func continue_campaign() -> bool:
	if not load_campaign() or _save_service() == null or not _save_service().has_save():
		return false
	var mission_id := StringName(save_data.get("campaign", {}).get("current_mission", "station_blackout"))
	transition_to_mission(mission_id)
	return true


func save_checkpoint(mission_id: StringName, checkpoint: Dictionary) -> bool:
	save_data.active_mission = {"id": String(mission_id), "checkpoint": checkpoint.duplicate(true)}
	save_data.campaign.current_mission = String(mission_id)
	return _save_service().save(save_data) if _save_service() != null else false


func checkpoint_for(mission_id: StringName) -> Dictionary:
	var active: Dictionary = save_data.get("active_mission", {})
	if StringName(active.get("id", "")) != mission_id:
		return {}
	return active.get("checkpoint", {}).duplicate(true)


func complete_mission(result: MissionResult) -> void:
	var completed: Array = save_data.campaign.get("completed_missions", [])
	var mission_text := String(result.mission_id)
	if not completed.has(mission_text):
		completed.append(mission_text)
	save_data.campaign.completed_missions = completed
	save_data.campaign.last_result = result.to_dictionary()
	save_data.active_mission = {}
	if result.mission_id == &"station_blackout":
		save_data.campaign.current_mission = "medical_wing"
	else:
		save_data.campaign.current_mission = "medical_wing"
	if _save_service() != null:
		_save_service().save(save_data)
	campaign_changed.emit()


func transition_to_mission(mission_id: StringName) -> void:
	var path: String = MISSION_SCENES.get(mission_id, MISSION_SCENES[&"station_blackout"])
	transition_to_scene(path)


func transition_to_scene(scene_path: String) -> void:
	if transition_in_progress:
		return
	transition_in_progress = true
	transition_started.emit(scene_path)
	var overlay := CanvasLayer.new()
	overlay.layer = 100
	var fade := ColorRect.new()
	fade.color = Color(0.0, 0.0, 0.0, 0.0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(fade)
	get_tree().root.add_child(overlay)
	var tween := create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.18)
	await tween.finished
	get_tree().paused = false
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		overlay.queue_free()
		transition_in_progress = false
		push_error("Unable to load scene: %s" % scene_path)
		return
	await get_tree().process_frame
	var fade_in := create_tween()
	fade_in.tween_property(fade, "color:a", 0.0, 0.18)
	await fade_in.finished
	overlay.queue_free()
	transition_in_progress = false


func _save_service() -> SaveServiceNode:
	return get_node_or_null("/root/SaveService") as SaveServiceNode


func _fallback_data(selected_difficulty: StringName = &"standard") -> Dictionary:
	return {
		"schema_version": SaveMigration.CURRENT_SCHEMA_VERSION,
		"game_version": GameVersion.as_string(),
		"profile": {"difficulty": String(selected_difficulty)},
		"campaign": {"completed_missions": [], "current_mission": "station_blackout"},
		"active_mission": {},
	}

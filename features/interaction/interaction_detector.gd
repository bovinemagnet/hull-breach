class_name InteractionDetector
extends Area2D

signal prompt_changed(text: String)
signal focused_interactable_changed(interactable: Interactable)

@export_range(16.0, 128.0, 1.0) var interaction_range: float = 56.0

var current_interactable: Interactable
var _candidates: Array[Interactable] = []
var _last_prompt := ""


func _ready() -> void:
	collision_layer = 0
	collision_mask = 64
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	_select_interactable()
	if Input.is_action_just_pressed(&"interact"):
		interact_current()


func interact_current() -> bool:
	if not is_instance_valid(current_interactable):
		return false
	return current_interactable.interact(get_parent() as Player)


func _select_interactable() -> void:
	var player := get_parent() as Player
	var best: Interactable
	var best_score := INF
	for candidate in _candidates:
		if not is_instance_valid(candidate):
			continue
		var offset := candidate.global_position - player.global_position
		var distance := offset.length()
		if distance > interaction_range or not _has_line_of_sight(player, candidate):
			continue
		var aim_penalty := 0.0
		if distance > 0.1:
			aim_penalty = (1.0 - player.aim_direction.dot(offset / distance)) * 18.0
		var score := distance + aim_penalty
		if score < best_score:
			best_score = score
			best = candidate
	if best != current_interactable:
		current_interactable = best
		focused_interactable_changed.emit(current_interactable)
	var prompt := current_interactable.get_interaction_text(player) if is_instance_valid(current_interactable) else ""
	if prompt != _last_prompt:
		_last_prompt = prompt
		prompt_changed.emit(prompt)


func _has_line_of_sight(player: Player, candidate: Interactable) -> bool:
	var query := PhysicsRayQueryParameters2D.create(player.global_position, candidate.global_position, 1)
	query.exclude = [player.get_rid()]
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()


func _on_area_entered(area: Area2D) -> void:
	if area is Interactable and not _candidates.has(area):
		_candidates.append(area)


func _on_area_exited(area: Area2D) -> void:
	if area is Interactable:
		_candidates.erase(area)

class_name Door
extends Interactable

signal state_changed(state: State)
signal noise_requested(event: NoiseEvent)

enum State { CLOSED, OPENING, OPEN, CLOSING, LOCKED, UNPOWERED, JAMMED, DESTROYED }

@export var definition: DoorDefinition
@export var vertical: bool = true

@onready var blocking_collision: CollisionShape2D = $BlockingBody/CollisionShape2D
@onready var interaction_collision: CollisionShape2D = $InteractionShape

var state := State.CLOSED
var open_progress := 0.0
var powered := true
var _auto_close_remaining := 0.0
var _power_consumer: PowerConsumer
var _door_audio: AudioStreamPlayer2D


func _ready() -> void:
	super._ready()
	assert(definition != null, "DoorDefinition is required")
	interaction_label = "Open Door"
	_configure_shapes()
	_door_audio = AudioStreamPlayer2D.new()
	_door_audio.bus = &"SFX"
	_door_audio.stream = ToneFactory.create_tone(118.0, 0.16, 0.12)
	add_child(_door_audio)
	powered = not definition.requires_power
	if not powered:
		state = State.UNPOWERED
	queue_redraw()


func bind_power_grid(grid: PowerGrid) -> void:
	if not definition.requires_power:
		powered = true
		return
	_power_consumer = PowerConsumer.new()
	_power_consumer.circuit = definition.power_circuit
	add_child(_power_consumer)
	_power_consumer.powered_changed.connect(_on_powered_changed)
	_power_consumer.bind(grid)


func can_interact(_player: Player) -> bool:
	return state not in [State.OPENING, State.CLOSING, State.JAMMED, State.DESTROYED]


func get_interaction_text(player: Player) -> String:
	if not powered:
		return "No Power"
	if not definition.access_credential.is_empty() and not player.access_inventory.has_access(definition.access_credential):
		return "%s Clearance Required" % String(definition.access_credential).capitalize()
	if state == State.OPEN:
		return "Close Door"
	return "Open Door"


func interact(player: Player) -> bool:
	if not can_interact(player):
		return false
	if not powered:
		feedback_requested.emit("NO POWER")
		return false
	if not definition.access_credential.is_empty() and not player.access_inventory.has_access(definition.access_credential):
		state = State.LOCKED
		feedback_requested.emit(definition.locked_message)
		state_changed.emit(state)
		queue_redraw()
		return false
	if state == State.OPEN:
		_begin_closing()
	else:
		_begin_opening()
	interaction_completed.emit(self, player)
	return true


func _process(delta: float) -> void:
	if state == State.OPENING:
		open_progress = minf(1.0, open_progress + delta / definition.open_duration)
		if open_progress >= 1.0:
			_set_state(State.OPEN)
			_auto_close_remaining = definition.auto_close_delay
	elif state == State.CLOSING:
		open_progress = maxf(0.0, open_progress - delta / definition.open_duration)
		if open_progress <= 0.0:
			_set_state(State.CLOSED)
	elif state == State.OPEN and definition.auto_close:
		_auto_close_remaining -= delta
		if _auto_close_remaining <= 0.0:
			_begin_closing()
	blocking_collision.disabled = open_progress >= 0.82
	queue_redraw()


func is_open() -> bool:
	return state == State.OPEN or state == State.OPENING


func restore_open(opened: bool) -> void:
	open_progress = 1.0 if opened else 0.0
	blocking_collision.set_deferred(&"disabled", opened)
	_set_state(State.OPEN if opened else State.CLOSED)


func _begin_opening() -> void:
	_set_state(State.OPENING)
	_door_audio.pitch_scale = 1.12
	_door_audio.play()
	noise_requested.emit(NoiseEvent.new(global_position, 160.0, &"door", self))


func _begin_closing() -> void:
	_set_state(State.CLOSING)
	_door_audio.pitch_scale = 0.82
	_door_audio.play()
	noise_requested.emit(NoiseEvent.new(global_position, 120.0, &"door", self))


func _set_state(new_state: State) -> void:
	if state == new_state:
		return
	state = new_state
	state_changed.emit(state)
	queue_redraw()


func _on_powered_changed(enabled: bool) -> void:
	powered = enabled
	if not powered and not is_open():
		_set_state(State.UNPOWERED)
	elif powered and state == State.UNPOWERED:
		_set_state(State.CLOSED)


func _configure_shapes() -> void:
	var blocking_shape := RectangleShape2D.new()
	blocking_shape.size = Vector2(18.0, 92.0) if vertical else Vector2(92.0, 18.0)
	blocking_collision.shape = blocking_shape
	var interaction_shape := RectangleShape2D.new()
	interaction_shape.size = Vector2(68.0, 112.0) if vertical else Vector2(112.0, 68.0)
	interaction_collision.shape = interaction_shape


func _exit_tree() -> void:
	if is_instance_valid(_door_audio):
		_door_audio.stop()
		_door_audio.stream = null


func _draw() -> void:
	var half_length := 45.0
	var panel_length := half_length * (1.0 - open_progress)
	var status_colour := Color(0.25, 0.95, 0.65) if is_open() else Color(0.95, 0.25, 0.22)
	if not powered:
		status_colour = Color(0.32, 0.36, 0.38)
	elif state == State.LOCKED:
		status_colour = Color(1.0, 0.65, 0.15)
	if vertical:
		draw_rect(Rect2(-9.0, -half_length, 18.0, panel_length), Color(0.22, 0.3, 0.32), true)
		draw_rect(Rect2(-9.0, half_length - panel_length, 18.0, panel_length), Color(0.22, 0.3, 0.32), true)
		draw_circle(Vector2(0.0, -half_length - 8.0), 4.0, status_colour)
	else:
		draw_rect(Rect2(-half_length, -9.0, panel_length, 18.0), Color(0.22, 0.3, 0.32), true)
		draw_rect(Rect2(half_length - panel_length, -9.0, panel_length, 18.0), Color(0.22, 0.3, 0.32), true)
		draw_circle(Vector2(-half_length - 8.0, 0.0), 4.0, status_colour)

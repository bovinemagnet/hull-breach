class_name Hazard
extends Area2D

signal enabled_changed(enabled: bool)
signal target_damaged(target: Node2D, amount: float)

@export var definition: HazardDefinition

var enabled := true
var _targets: Array[Node2D] = []
var _damage_remaining := 0.0
var _consumer: PowerConsumer
var _audio: AudioStreamPlayer2D


func _ready() -> void:
	assert(definition != null and definition.validation_errors().is_empty(), "HazardDefinition is invalid")
	collision_layer = 128
	collision_mask = 2 | 4
	monitoring = true
	monitorable = false
	enabled = definition.starts_enabled
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_build_audio()
	queue_redraw()


func _physics_process(delta: float) -> void:
	advance(delta)


func advance(delta: float) -> void:
	if not enabled:
		return
	_damage_remaining -= maxf(delta, 0.0)
	if _damage_remaining > 0.0:
		return
	_damage_remaining = definition.damage_interval
	for target in _targets.duplicate():
		if not is_instance_valid(target):
			_targets.erase(target)
			continue
		_damage_target(target)


func set_enabled(value: bool) -> void:
	if enabled == value:
		return
	enabled = value
	_damage_remaining = 0.0
	enabled_changed.emit(enabled)
	if _audio != null:
		if enabled:
			_audio.play()
		else:
			_audio.stop()
	queue_redraw()


func bind_power_grid(grid: PowerGrid) -> void:
	if definition.power_circuit.is_empty():
		return
	_consumer = PowerConsumer.new()
	_consumer.circuit = definition.power_circuit
	add_child(_consumer)
	_consumer.powered_changed.connect(func(powered: bool) -> void: set_enabled(powered == definition.enabled_when_powered))
	_consumer.bind(grid)


func add_target_for_test(target: Node2D) -> void:
	_on_body_entered(target)


func _damage_target(target: Node2D) -> void:
	if not target.is_in_group(definition.affected_group) or not target.has_method("receive_damage"):
		return
	target.call("receive_damage", DamageInfo.new(definition.damage, self, target.global_position, Vector2.ZERO))
	target_damaged.emit(target, definition.damage)


func _on_body_entered(body: Node2D) -> void:
	if not _targets.has(body):
		_targets.append(body)


func _on_body_exited(body: Node2D) -> void:
	_targets.erase(body)


func _build_audio() -> void:
	if DisplayServer.get_name() == "headless":
		return
	_audio = AudioStreamPlayer2D.new()
	_audio.bus = &"Ambience"
	var frequency := 74.0 if definition.id == &"fire" else 118.0
	var stream := ToneFactory.create_tone(frequency, 1.2, 0.025, false)
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = stream.data.size() / 2
	_audio.stream = stream
	add_child(_audio)
	if enabled:
		_audio.play()


func _exit_tree() -> void:
	if is_instance_valid(_audio):
		_audio.stop()
		_audio.stream = null

class_name MusicDirectorNode
extends Node

enum State { SILENT, AMBIENT, COMBAT }

var state := State.SILENT
var _player: AudioStreamPlayer


func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	_player = AudioStreamPlayer.new()
	_player.bus = &"Music"
	add_child(_player)
	set_state(State.AMBIENT)


func set_combat(enabled: bool) -> void:
	set_state(State.COMBAT if enabled else State.AMBIENT)


func set_state(next_state: State) -> void:
	if state == next_state:
		return
	state = next_state
	if _player == null:
		return
	_player.stop()
	if state == State.SILENT:
		return
	var frequency := 58.0 if state == State.AMBIENT else 92.0
	var volume := 0.025 if state == State.AMBIENT else 0.045
	var stream := ToneFactory.create_tone(frequency, 2.0, volume, false)
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = stream.data.size() / 2
	_player.stream = stream
	_player.play()


func _exit_tree() -> void:
	if is_instance_valid(_player):
		_player.stop()
		_player.stream = null

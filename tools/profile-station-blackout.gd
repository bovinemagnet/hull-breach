extends SceneTree

const TARGET_ENEMIES := 20
const PROFILE_FRAMES := 300


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	var packed := load("res://levels/campaign/station_blackout/station_blackout.tscn") as PackedScene
	var station := packed.instantiate() as StationBlackout
	root.add_child(station)
	current_scene = station
	await process_frame
	while get_nodes_in_group(&"enemies").size() < TARGET_ENEMIES:
		var index := get_nodes_in_group(&"enemies").size()
		station._spawn_drone(Vector2(180.0 + (index % 5) * 260.0, 220.0 + (index / 5) * 190.0))
	var started := Time.get_ticks_usec()
	for frame in PROFILE_FRAMES:
		if frame % 30 == 0:
			station.noise_system.emit_noise(NoiseEvent.new(station.player.global_position, 900.0, &"stress", station.player))
		if frame % 8 == 0:
			station.player.weapon.try_fire(Vector2.RIGHT, station.player)
		await process_frame
	var elapsed_ms := float(Time.get_ticks_usec() - started) / 1000.0
	var average_ms := elapsed_ms / PROFILE_FRAMES
	print("Station Blackout profile: %d enemies, %d frames, %.3f ms average process time" % [TARGET_ENEMIES, PROFILE_FRAMES, average_ms])
	current_scene = null
	station.queue_free()
	for cleanup_frame in 30:
		await process_frame
	quit(0 if average_ms < 16.667 else 1)

extends SceneTree

const PROFILE_FRAMES := 120
const FRAME_BUDGET_MS := 16.667


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	var worst_average := 0.0
	var worst_mission: StringName
	for mission_id in CampaignCatalog.MISSION_IDS:
		CheckpointManager.clear_pending()
		var packed := load(CampaignCatalog.scene_for(mission_id)) as PackedScene
		var scene := packed.instantiate()
		root.add_child(scene)
		current_scene = scene
		await process_frame
		var frame_times: Array[float] = []
		for _frame in PROFILE_FRAMES:
			var frame_started := Time.get_ticks_usec()
			await process_frame
			frame_times.append(float(Time.get_ticks_usec() - frame_started) / 1000.0)
		frame_times.sort()
		var total := 0.0
		for frame_time in frame_times:
			total += frame_time
		var average_ms := total / frame_times.size()
		var p95 := frame_times[clampi(int(ceil(frame_times.size() * 0.95)) - 1, 0, frame_times.size() - 1)]
		var p99 := frame_times[clampi(int(ceil(frame_times.size() * 0.99)) - 1, 0, frame_times.size() - 1)]
		var memory_mb := Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0)
		print("Campaign profile: %s avg %.3f ms  p95 %.3f ms  p99 %.3f ms  memory %.1f MiB" % [mission_id, average_ms, p95, p99, memory_mb])
		if average_ms > worst_average:
			worst_average = average_ms
			worst_mission = mission_id
		current_scene = null
		scene.queue_free()
		for _cleanup_frame in 4:
			await process_frame
	print("Campaign worst: %s %.3f ms average (budget %.3f ms)" % [worst_mission, worst_average, FRAME_BUDGET_MS])
	quit(0 if worst_average < FRAME_BUDGET_MS else 1)

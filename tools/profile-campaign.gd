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
		var started := Time.get_ticks_usec()
		for _frame in PROFILE_FRAMES:
			await process_frame
		var average_ms := (float(Time.get_ticks_usec() - started) / 1000.0) / PROFILE_FRAMES
		print("Campaign profile: %s %.3f ms average" % [mission_id, average_ms])
		if average_ms > worst_average:
			worst_average = average_ms
			worst_mission = mission_id
		current_scene = null
		scene.queue_free()
		for _cleanup_frame in 4:
			await process_frame
	print("Campaign worst: %s %.3f ms average (budget %.3f ms)" % [worst_mission, worst_average, FRAME_BUDGET_MS])
	quit(0 if worst_average < FRAME_BUDGET_MS else 1)

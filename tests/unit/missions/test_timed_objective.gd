extends GdUnitTestSuite


func test_timed_objective_reports_timeout_without_instant_game_over() -> void:
	var objective := auto_free(TimedObjective.new()) as TimedObjective
	objective.configure_timer(2.0)
	assert_bool(objective.activate()).is_true()
	assert_bool(objective.advance(1.0)).is_false()
	assert_float(objective.remaining).is_equal(1.0)
	assert_bool(objective.advance(1.0)).is_true()
	assert_bool(objective.fail()).is_true()
	assert_int(objective.state).is_equal(MissionObjective.State.FAILED)


func test_mission_snapshot_restores_timed_remaining() -> void:
	var definition := MissionDefinition.new()
	definition.id = &"timed_test"
	definition.display_name = "Timed Test"
	definition.objective_ids = PackedStringArray(["valve", "escape"])
	definition.objective_titles = PackedStringArray(["Valve", "Escape"])
	definition.objective_details = PackedStringArray(["Open it", "Leave"])
	definition.objective_events = PackedStringArray(["valve_open", "escaped"])
	definition.objective_kinds = PackedInt32Array([MissionDefinition.ObjectiveKind.TIMED, MissionDefinition.ObjectiveKind.EXTRACTION])
	definition.objective_time_limits = PackedFloat32Array([10.0, 0.0])
	var mission := auto_free(MissionController.new()) as MissionController
	mission.configure(definition)
	(mission.get_active_objective() as TimedObjective).advance(3.0)
	var restored := auto_free(MissionController.new()) as MissionController
	restored.configure(definition)
	restored.restore(mission.snapshot())
	assert_float((restored.get_active_objective() as TimedObjective).remaining).is_equal(7.0)

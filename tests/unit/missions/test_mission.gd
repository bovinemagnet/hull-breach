extends GdUnitTestSuite


func _definition() -> MissionDefinition:
	var definition := MissionDefinition.new()
	definition.id = &"test"
	definition.display_name = "Test"
	definition.objective_ids = PackedStringArray(["first", "second"])
	definition.objective_titles = PackedStringArray(["First", "Second"])
	definition.objective_details = PackedStringArray(["Do first", "Do second"])
	definition.objective_events = PackedStringArray(["first_done", "second_done"])
	definition.objective_kinds = PackedInt32Array([MissionDefinition.ObjectiveKind.REACH, MissionDefinition.ObjectiveKind.INTERACT])
	return definition


func test_objectives_progress_sequentially_and_complete() -> void:
	var mission := auto_free(MissionController.new()) as MissionController
	mission.configure(_definition())
	assert_int(mission.active_index).is_equal(0)
	assert_int(mission.get_active_objective().state).is_equal(MissionObjective.State.ACTIVE)
	assert_bool(mission.notify_event(&"second_done")).is_false()
	assert_bool(mission.notify_event(&"first_done")).is_true()
	assert_int(mission.active_index).is_equal(1)
	assert_bool(mission.notify_event(&"second_done")).is_true()
	assert_bool(mission.is_complete).is_true()


func test_snapshot_restores_active_objective() -> void:
	var mission := auto_free(MissionController.new()) as MissionController
	mission.configure(_definition())
	mission.notify_event(&"first_done")
	var state := mission.snapshot()
	var restored := auto_free(MissionController.new()) as MissionController
	restored.configure(_definition())
	restored.restore(state)
	assert_int(restored.active_index).is_equal(1)
	assert_int(restored.get_active_objective().state).is_equal(MissionObjective.State.ACTIVE)

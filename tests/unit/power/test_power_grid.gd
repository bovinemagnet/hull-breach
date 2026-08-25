extends GdUnitTestSuite


func test_consumer_tracks_power_transition() -> void:
	var grid := auto_free(PowerGrid.new()) as PowerGrid
	var consumer := auto_free(PowerConsumer.new()) as PowerConsumer
	consumer.circuit = &"main"
	consumer.bind(grid)
	assert_bool(consumer.powered).is_false()
	assert_bool(grid.set_powered(&"main", true)).is_true()
	assert_bool(consumer.powered).is_true()
	assert_bool(grid.set_powered(&"main", true)).is_false()


func test_power_snapshot_restores_main_and_communications() -> void:
	var grid := auto_free(PowerGrid.new()) as PowerGrid
	grid.restore_main_power()
	var snapshot := grid.snapshot()
	grid.set_powered(&"main", false)
	grid.set_powered(&"communications", false)
	grid.restore(snapshot)
	assert_bool(grid.is_powered(&"main")).is_true()
	assert_bool(grid.is_powered(&"communications")).is_true()

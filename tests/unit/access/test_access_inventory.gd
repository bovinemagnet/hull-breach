extends GdUnitTestSuite


func test_credentials_are_unique_and_specific() -> void:
	var inventory := auto_free(AccessInventory.new()) as AccessInventory
	assert_bool(inventory.has_access(&"engineering")).is_false()
	assert_bool(inventory.grant(&"engineering")).is_true()
	assert_bool(inventory.grant(&"engineering")).is_false()
	assert_bool(inventory.has_access(&"engineering")).is_true()
	assert_bool(inventory.has_access(&"medical")).is_false()
	assert_int(inventory.snapshot().size()).is_equal(1)


func test_snapshot_round_trip_restores_access() -> void:
	var source := auto_free(AccessInventory.new()) as AccessInventory
	var restored := auto_free(AccessInventory.new()) as AccessInventory
	source.grant(&"engineering")
	restored.restore(source.snapshot())
	assert_bool(restored.has_access(&"engineering")).is_true()

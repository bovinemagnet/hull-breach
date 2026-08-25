extends GdUnitTestSuite


func test_organic_barrier_opens_after_all_nodes_are_destroyed() -> void:
	var barrier := auto_free(OrganicBarrier.new()) as OrganicBarrier
	barrier.required_node_ids = PackedStringArray(["left", "right"])
	barrier.notify_node_destroyed(&"left")
	assert_bool(barrier.is_open).is_false()
	barrier.notify_node_destroyed(&"right")
	assert_bool(barrier.is_open).is_true()


func test_nest_node_uses_standard_damage_contract() -> void:
	var node := auto_free(NestNode.new()) as NestNode
	node.maximum_health = 20.0
	add_child(node)
	await await_idle_frame()
	node.receive_damage(DamageInfo.new(20.0))
	assert_bool(node.is_destroyed).is_true()

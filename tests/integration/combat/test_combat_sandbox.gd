extends GdUnitTestSuite


func test_sandbox_loads_with_player_enemies_and_hud() -> void:
	var sandbox := await _spawn_sandbox()
	assert_object(sandbox.player).is_not_null()
	assert_object(sandbox.get_node("CombatHud")).is_not_null()
	assert_int(sandbox.get_tree().get_nodes_in_group(&"enemies").size()).is_equal(7)


func test_three_projectile_hits_kill_a_drone() -> void:
	var sandbox := await _spawn_sandbox()
	var drone := sandbox.spawn_drone(Vector2(1000.0, 300.0))
	drone.receive_damage(DamageInfo.new(20.0, sandbox.player, drone.global_position, Vector2.RIGHT))
	drone.receive_damage(DamageInfo.new(20.0, sandbox.player, drone.global_position, Vector2.RIGHT))
	assert_bool(drone.health_component.is_dead).is_false()
	drone.receive_damage(DamageInfo.new(20.0, sandbox.player, drone.global_position, Vector2.RIGHT))
	assert_bool(drone.health_component.is_dead).is_true()
	assert_int(drone.state).is_equal(Drone.State.DEAD)


func test_physical_projectile_applies_damage_to_drone() -> void:
	var sandbox := await _spawn_sandbox()
	var drone := sandbox.spawn_drone(Vector2(1100.0, 850.0))
	drone.set_target(null)
	var projectile_scene := load("res://features/combat/projectiles/projectile.tscn") as PackedScene
	var projectile := projectile_scene.instantiate() as Projectile
	projectile.global_position = Vector2(1040.0, 850.0)
	projectile.configure(Vector2.RIGHT, 20.0, 700.0, 1.0, sandbox.player)
	sandbox.add_child(projectile)
	await await_millis(150)
	assert_float(drone.health_component.current_health).is_equal(30.0)


func test_stress_spawn_supports_fifty_active_drones() -> void:
	var sandbox := await _spawn_sandbox()
	sandbox.spawn_drones(50)
	await await_idle_frame()
	assert_int(sandbox.get_tree().get_nodes_in_group(&"enemies").size()).is_greater_equal(50)
	sandbox.clear_enemies()


func _spawn_sandbox() -> CombatSandbox:
	var packed_scene := load("res://levels/dev/combat_sandbox/combat_sandbox.tscn") as PackedScene
	assert_object(packed_scene).is_not_null()
	var sandbox := auto_free(packed_scene.instantiate()) as CombatSandbox
	add_child(sandbox)
	await await_idle_frame()
	return sandbox

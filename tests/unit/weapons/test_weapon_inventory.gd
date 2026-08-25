extends GdUnitTestSuite


func test_player_loadout_switches_and_round_trips_ammo() -> void:
	var scene := load("res://features/player/player.tscn") as PackedScene
	var player := auto_free(scene.instantiate()) as Player
	add_child(player)
	await await_idle_frame()
	assert_int(player.weapon_inventory.weapons.size()).is_equal(2)
	assert_str(String(player.weapon.definition.id)).is_equal("hb4_pulse_rifle")
	player.weapon_inventory.cycle(1)
	assert_str(String(player.weapon.definition.id)).is_equal("sidearm")
	player.weapon.current_magazine = 4
	var snapshot := player.weapon_inventory.snapshot()
	player.weapon.current_magazine = 1
	player.weapon_inventory.restore(snapshot)
	assert_int(player.weapon.current_magazine).is_equal(4)


func test_shotgun_has_multi_projectile_spread() -> void:
	var definition := load("res://features/weapons/shotgun/shotgun.tres") as WeaponDefinition
	assert_bool(definition.is_valid()).is_true()
	assert_int(definition.projectiles_per_shot).is_greater(1)
	assert_float(definition.spread_degrees).is_greater(0.0)


func test_restore_recreates_acquired_weapon_in_fresh_player() -> void:
	var scene := load("res://features/player/player.tscn") as PackedScene
	var first := auto_free(scene.instantiate()) as Player
	add_child(first)
	await await_idle_frame()
	first.weapon_inventory.add_weapon_scene(load("res://features/weapons/shotgun/shotgun.tscn") as PackedScene)
	first.weapon.current_magazine = 2
	var snapshot := first.weapon_inventory.snapshot()
	var restored := auto_free(scene.instantiate()) as Player
	add_child(restored)
	await await_idle_frame()
	restored.weapon_inventory.restore(snapshot)
	assert_int(restored.weapon_inventory.weapons.size()).is_equal(3)
	assert_str(String(restored.weapon.definition.id)).is_equal("shotgun")
	assert_int(restored.weapon.current_magazine).is_equal(2)

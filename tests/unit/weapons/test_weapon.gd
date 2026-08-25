extends GdUnitTestSuite


func _new_definition() -> WeaponDefinition:
	var definition := WeaponDefinition.new()
	definition.damage = 20.0
	definition.rounds_per_second = 8.0
	definition.magazine_size = 3
	definition.reserve_ammo = 5
	definition.reload_duration = 1.0
	definition.projectile_speed = 700.0
	definition.projectile_lifetime = 1.5
	definition.projectiles_per_shot = 1
	return definition


func _new_weapon() -> Weapon:
	var weapon := auto_free(Weapon.new()) as Weapon
	weapon.configure(_new_definition())
	return weapon


func test_fire_consumes_one_round() -> void:
	var weapon := _new_weapon()
	assert_bool(weapon.try_fire(Vector2.RIGHT)).is_true()
	assert_int(weapon.current_magazine).is_equal(2)


func test_fire_rate_is_enforced() -> void:
	var weapon := _new_weapon()
	assert_bool(weapon.try_fire(Vector2.RIGHT)).is_true()
	assert_bool(weapon.try_fire(Vector2.RIGHT)).is_false()
	weapon.advance(0.124)
	assert_bool(weapon.try_fire(Vector2.RIGHT)).is_false()
	weapon.advance(0.001)
	assert_bool(weapon.try_fire(Vector2.RIGHT)).is_true()


func test_empty_magazine_cannot_fire() -> void:
	var weapon := _new_weapon()
	for shot_index in 3:
		assert_bool(weapon.try_fire(Vector2.RIGHT)).is_true()
		weapon.advance(0.125)
	assert_bool(weapon.try_fire(Vector2.RIGHT)).is_false()
	assert_int(weapon.current_magazine).is_equal(0)


func test_reload_transfers_only_missing_ammunition() -> void:
	var weapon := _new_weapon()
	weapon.try_fire(Vector2.RIGHT)
	weapon.advance(0.125)
	weapon.try_fire(Vector2.RIGHT)
	assert_bool(weapon.start_reload()).is_true()
	weapon.advance(1.0)
	assert_int(weapon.current_magazine).is_equal(3)
	assert_int(weapon.reserve_ammo).is_equal(3)
	assert_bool(weapon.is_reloading).is_false()


func test_reload_does_not_make_reserve_negative() -> void:
	var weapon := _new_weapon()
	weapon.current_magazine = 0
	weapon.reserve_ammo = 1
	weapon.start_reload()
	weapon.advance(1.0)
	assert_int(weapon.current_magazine).is_equal(1)
	assert_int(weapon.reserve_ammo).is_equal(0)


func test_full_magazine_does_not_reload() -> void:
	var weapon := _new_weapon()
	assert_bool(weapon.start_reload()).is_false()

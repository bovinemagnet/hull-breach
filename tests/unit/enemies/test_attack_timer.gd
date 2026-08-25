extends GdUnitTestSuite


func test_attack_is_unavailable_until_cooldown_expires() -> void:
	var timer := AttackTimer.new(0.8)
	assert_bool(timer.try_consume()).is_true()
	assert_bool(timer.try_consume()).is_false()
	timer.advance(0.79)
	assert_bool(timer.is_ready()).is_false()
	timer.advance(0.01)
	assert_bool(timer.is_ready()).is_true()
	assert_bool(timer.try_consume()).is_true()


func test_negative_delta_does_not_advance_timer() -> void:
	var timer := AttackTimer.new(1.0)
	timer.try_consume()
	timer.advance(-2.0)
	assert_float(timer.remaining).is_equal(1.0)

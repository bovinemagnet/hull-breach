extends GdUnitTestSuite


class DamageReceiver extends Node2D:
	var damage_received := 0.0

	func receive_damage(info: DamageInfo) -> void:
		damage_received += info.amount


func test_hazard_uses_standard_damage_and_can_be_disabled() -> void:
	var definition := HazardDefinition.new()
	definition.damage = 7.0
	definition.damage_interval = 0.5
	var hazard := auto_free(Hazard.new()) as Hazard
	hazard.definition = definition
	add_child(hazard)
	var receiver := auto_free(DamageReceiver.new()) as DamageReceiver
	receiver.add_to_group(&"player")
	add_child(receiver)
	hazard.add_target_for_test(receiver)
	hazard.advance(0.5)
	assert_float(receiver.damage_received).is_equal(7.0)
	hazard.set_enabled(false)
	hazard.advance(1.0)
	assert_float(receiver.damage_received).is_equal(7.0)


func test_power_link_inverts_gas_hazard_state() -> void:
	var packed := load("res://features/hazards/gas/gas_hazard.tscn") as PackedScene
	var hazard := auto_free(packed.instantiate()) as GasHazard
	var grid := auto_free(PowerGrid.new()) as PowerGrid
	add_child(grid)
	add_child(hazard)
	hazard.bind_power_grid(grid)
	assert_bool(hazard.enabled).is_true()
	grid.set_powered(&"ventilation", true)
	assert_bool(hazard.enabled).is_false()

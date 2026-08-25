class_name PowerGrid
extends Node

signal circuit_changed(circuit: StringName, powered: bool)

var _circuits: Dictionary[StringName, bool] = {
	&"emergency": true,
	&"main": false,
	&"communications": false,
	&"engineering": true,
}


func is_powered(circuit: StringName) -> bool:
	return _circuits.get(circuit, false)


func set_powered(circuit: StringName, powered: bool) -> bool:
	if is_powered(circuit) == powered:
		return false
	_circuits[circuit] = powered
	circuit_changed.emit(circuit, powered)
	return true


func restore_main_power() -> void:
	set_powered(&"main", true)
	set_powered(&"communications", true)
	set_powered(&"engineering", true)


func snapshot() -> Dictionary:
	return _circuits.duplicate(true)


func restore(circuits: Dictionary) -> void:
	for circuit: StringName in circuits:
		set_powered(circuit, bool(circuits[circuit]))

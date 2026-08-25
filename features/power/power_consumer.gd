class_name PowerConsumer
extends Node

signal powered_changed(powered: bool)

@export var circuit: StringName = &"main"

var powered := false
var _grid: PowerGrid


func bind(grid: PowerGrid) -> void:
	if is_instance_valid(_grid) and _grid.circuit_changed.is_connected(_on_circuit_changed):
		_grid.circuit_changed.disconnect(_on_circuit_changed)
	_grid = grid
	_grid.circuit_changed.connect(_on_circuit_changed)
	_set_powered(_grid.is_powered(circuit))


func _on_circuit_changed(changed_circuit: StringName, enabled: bool) -> void:
	if changed_circuit == circuit:
		_set_powered(enabled)


func _set_powered(enabled: bool) -> void:
	if powered == enabled:
		return
	powered = enabled
	powered_changed.emit(powered)

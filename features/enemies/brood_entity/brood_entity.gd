class_name BroodEntity
extends Drone

signal phase_changed(phase: int)

var phase := 1


func receive_damage(info: DamageInfo) -> void:
	super.receive_damage(info)
	if not is_node_ready() or state == State.DEAD:
		return
	var ratio := health_component.current_health / health_component.maximum_health
	var next_phase := 3 if ratio <= 0.34 else (2 if ratio <= 0.67 else 1)
	if next_phase > phase:
		phase = next_phase
		phase_changed.emit(phase)


func is_core_exposed() -> bool:
	return phase >= 3

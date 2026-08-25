class_name TimedObjective
extends MissionObjective

var duration := 0.0
var remaining := 0.0


func configure_timer(seconds: float) -> void:
	duration = maxf(0.0, seconds)
	remaining = duration


func activate() -> bool:
	var activated_now := super.activate()
	if activated_now and remaining <= 0.0:
		remaining = duration
	return activated_now


func advance(delta: float) -> bool:
	if state != State.ACTIVE or duration <= 0.0:
		return false
	remaining = maxf(0.0, remaining - maxf(delta, 0.0))
	progress_changed.emit(ceili(duration - remaining), ceili(duration))
	return is_zero_approx(remaining)

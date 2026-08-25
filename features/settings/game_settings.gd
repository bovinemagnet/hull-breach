class_name GameSettings
extends RefCounted

var master_volume := 1.0
var music_volume := 0.8
var ambience_volume := 0.8
var sfx_volume := 0.85
var ui_volume := 0.9
var vsync_enabled := true
var target_fps := 60
var fullscreen_enabled := false
var effects_quality := 1
var mouse_sensitivity := 1.0
var controller_sensitivity := 1.0
var controller_deadzone := 0.2
var mobile_stick_size := 1.0
var mobile_stick_opacity := 0.72
var touch_sensitivity := 1.0
var screen_shake_intensity := 1.0
var flash_intensity := 1.0
var aim_assist_strength := 0.0
var ui_scale := 1.0
var vibration_intensity := 1.0
var subtitles_enabled := true


func to_dictionary() -> Dictionary:
	return {
		"audio": {
			"master": master_volume,
			"music": music_volume,
			"ambience": ambience_volume,
			"sfx": sfx_volume,
			"ui": ui_volume,
		},
		"video": {
			"vsync": vsync_enabled,
			"target_fps": target_fps,
			"fullscreen": fullscreen_enabled,
			"effects_quality": effects_quality,
		},
		"controls": {
			"mouse_sensitivity": mouse_sensitivity,
			"controller_sensitivity": controller_sensitivity,
			"controller_deadzone": controller_deadzone,
			"mobile_stick_size": mobile_stick_size,
			"mobile_stick_opacity": mobile_stick_opacity,
			"touch_sensitivity": touch_sensitivity,
		},
		"accessibility": {
			"screen_shake": screen_shake_intensity,
			"flash_intensity": flash_intensity,
			"aim_assist": aim_assist_strength,
			"ui_scale": ui_scale,
			"vibration_intensity": vibration_intensity,
			"subtitles": subtitles_enabled,
		},
	}


static func from_dictionary(data: Dictionary) -> GameSettings:
	var settings := GameSettings.new()
	var audio: Dictionary = data.get("audio", {})
	settings.master_volume = _unit(audio.get("master", settings.master_volume))
	settings.music_volume = _unit(audio.get("music", settings.music_volume))
	settings.ambience_volume = _unit(audio.get("ambience", settings.ambience_volume))
	settings.sfx_volume = _unit(audio.get("sfx", settings.sfx_volume))
	settings.ui_volume = _unit(audio.get("ui", settings.ui_volume))
	var video: Dictionary = data.get("video", {})
	settings.vsync_enabled = bool(video.get("vsync", settings.vsync_enabled))
	settings.target_fps = clampi(int(video.get("target_fps", settings.target_fps)), 30, 240)
	settings.fullscreen_enabled = bool(video.get("fullscreen", settings.fullscreen_enabled))
	settings.effects_quality = clampi(int(video.get("effects_quality", settings.effects_quality)), 0, 1)
	var controls: Dictionary = data.get("controls", {})
	settings.mouse_sensitivity = clampf(float(controls.get("mouse_sensitivity", 1.0)), 0.1, 3.0)
	settings.controller_sensitivity = clampf(float(controls.get("controller_sensitivity", 1.0)), 0.1, 3.0)
	settings.controller_deadzone = clampf(float(controls.get("controller_deadzone", 0.2)), 0.0, 0.9)
	settings.mobile_stick_size = clampf(float(controls.get("mobile_stick_size", 1.0)), 0.7, 1.5)
	settings.mobile_stick_opacity = _unit(controls.get("mobile_stick_opacity", 0.72))
	settings.touch_sensitivity = clampf(float(controls.get("touch_sensitivity", 1.0)), 0.25, 2.0)
	var accessibility: Dictionary = data.get("accessibility", {})
	settings.screen_shake_intensity = _unit(accessibility.get("screen_shake", 1.0))
	settings.flash_intensity = _unit(accessibility.get("flash_intensity", 1.0))
	settings.aim_assist_strength = _unit(accessibility.get("aim_assist", 0.0))
	settings.ui_scale = clampf(float(accessibility.get("ui_scale", 1.0)), 0.75, 1.5)
	settings.vibration_intensity = _unit(accessibility.get("vibration_intensity", 1.0))
	settings.subtitles_enabled = bool(accessibility.get("subtitles", true))
	return settings


static func _unit(value: Variant) -> float:
	return clampf(float(value), 0.0, 1.0)

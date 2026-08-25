class_name GameVersion
extends RefCounted

const MAJOR := 1
const MINOR := 0
const PATCH := 0
const PRERELEASE := "rc.1"
const CHANNEL := "Release Candidate"
const BUILD_METADATA_PATH := "res://core/utilities/build_metadata.generated.cfg"


static func as_string() -> String:
	var version := "%d.%d.%d" % [MAJOR, MINOR, PATCH]
	return "%s-%s" % [version, PRERELEASE] if not PRERELEASE.is_empty() else version


static func build_commit() -> String:
	return _metadata_value("commit", "HULL_BREACH_BUILD_ID", "local")


static func build_date() -> String:
	return _metadata_value("date", "HULL_BREACH_BUILD_DATE", "local")


static func display_string() -> String:
	return "%s %s (%s)" % [as_string(), CHANNEL, build_commit()]


static func support_string() -> String:
	return "Version: %s | Commit: %s | Build Date: %s | Channel: %s" % [
		as_string(),
		build_commit(),
		build_date(),
		CHANNEL,
	]


static func is_release_candidate() -> bool:
	return PRERELEASE.begins_with("rc.") and CHANNEL == "Release Candidate"


static func _metadata_value(key: String, environment_key: String, fallback: String) -> String:
	var configured := OS.get_environment(environment_key).strip_edges()
	if not configured.is_empty():
		return configured
	var config := ConfigFile.new()
	if config.load(BUILD_METADATA_PATH) == OK:
		var embedded := String(config.get_value("build", key, "")).strip_edges()
		if not embedded.is_empty():
			return embedded
	return fallback

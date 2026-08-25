class_name GameVersion
extends RefCounted

const MAJOR := 0
const MINOR := 8
const PATCH := 0
const CHANNEL := "Beta"


static func as_string() -> String:
	return "%d.%d.%d" % [MAJOR, MINOR, PATCH]


static func build_id() -> String:
	var configured := OS.get_environment("HULL_BREACH_BUILD_ID").strip_edges()
	return configured if not configured.is_empty() else "local"


static func display_string() -> String:
	return "%s %s (%s)" % [as_string(), CHANNEL, build_id()]

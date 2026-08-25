class_name GameVersion
extends RefCounted

const MAJOR := 0
const MINOR := 3
const PATCH := 0


static func as_string() -> String:
	return "%d.%d.%d" % [MAJOR, MINOR, PATCH]

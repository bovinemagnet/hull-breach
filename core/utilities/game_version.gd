class_name GameVersion
extends RefCounted

const MAJOR := 0
const MINOR := 0
const PATCH := 1


static func as_string() -> String:
	return "%d.%d.%d" % [MAJOR, MINOR, PATCH]

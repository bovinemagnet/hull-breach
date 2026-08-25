class_name AccessInventory
extends Node

signal credential_added(credential_id: StringName)

var _credentials: Dictionary[StringName, bool] = {}


func grant(credential_id: StringName) -> bool:
	if credential_id.is_empty() or has_access(credential_id):
		return false
	_credentials[credential_id] = true
	credential_added.emit(credential_id)
	return true


func has_access(credential_id: StringName) -> bool:
	return credential_id.is_empty() or _credentials.has(credential_id)


func snapshot() -> PackedStringArray:
	var credentials := PackedStringArray()
	for credential_id: StringName in _credentials:
		credentials.append(String(credential_id))
	credentials.sort()
	return credentials


func restore(credentials: PackedStringArray) -> void:
	_credentials.clear()
	for credential_id in credentials:
		if not credential_id.is_empty():
			_credentials[StringName(credential_id)] = true

class_name EnemySpawnPoint
extends Marker2D

@export var id: StringName
@export var spawn_group: StringName = &"default"


func spawn(scene: PackedScene, parent: Node, target: Node2D = null) -> Node2D:
	if scene == null or parent == null:
		return null
	var enemy := scene.instantiate() as Node2D
	if enemy == null:
		return null
	parent.add_child(enemy)
	enemy.global_position = global_position
	var effect := ImpactEffect.new()
	effect.configure(Color(0.85, 0.28, 0.22))
	parent.add_child(effect)
	effect.global_position = global_position
	if target != null and enemy.has_method("set_target"):
		enemy.call("set_target", target)
	return enemy

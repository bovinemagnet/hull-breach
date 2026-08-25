class_name Projectile
extends Area2D

var direction := Vector2.RIGHT
var speed := 700.0
var damage := 20.0
var remaining_lifetime := 1.5
var source: Node
var _resolved := false


func configure(
	p_direction: Vector2,
	p_damage: float,
	p_speed: float,
	p_lifetime: float,
	p_source: Node
) -> void:
	direction = p_direction.normalized()
	damage = p_damage
	speed = p_speed
	remaining_lifetime = p_lifetime
	source = p_source
	rotation = direction.angle()


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	remaining_lifetime -= delta
	if remaining_lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if _resolved or body == source:
		return
	_resolved = true
	if body.has_method("receive_damage"):
		var info := DamageInfo.new(damage, source, global_position, direction)
		body.call("receive_damage", info)
	_spawn_impact(Color(0.25, 0.95, 1.0) if body.has_method("receive_damage") else Color(1.0, 0.72, 0.28))
	queue_free()


func _spawn_impact(colour: Color) -> void:
	if not is_inside_tree():
		return
	var effect := ImpactEffect.new()
	effect.configure(colour)
	var effect_parent := get_tree().current_scene
	if effect_parent == null:
		effect_parent = get_parent()
	if effect_parent == null:
		effect.queue_free()
		return
	effect_parent.add_child(effect)
	effect.global_position = global_position


func _draw() -> void:
	draw_line(Vector2(-8.0, 0.0), Vector2(3.0, 0.0), Color(0.15, 0.75, 1.0, 0.5), 4.0)
	draw_circle(Vector2(3.0, 0.0), 3.0, Color(0.7, 1.0, 1.0))

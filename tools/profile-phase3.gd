extends SceneTree

const TARGET_ENEMIES := 50
const TARGET_PROJECTILES := 100
const PROFILE_FRAMES := 300
const ENEMY_SCENES: Array[PackedScene] = [
	preload("res://features/enemies/drone/drone.tscn"),
	preload("res://features/enemies/hunter/hunter.tscn"),
	preload("res://features/enemies/spitter/spitter.tscn"),
]
const PROJECTILE_SCENE := preload("res://features/combat/projectiles/projectile.tscn")
const HAZARD_SCENES: Array[PackedScene] = [
	preload("res://features/hazards/electricity/electrical_hazard.tscn"),
	preload("res://features/hazards/fire/fire_hazard.tscn"),
	preload("res://features/hazards/gas/gas_hazard.tscn"),
]


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	var packed := load("res://levels/dev/combat_sandbox/combat_sandbox.tscn") as PackedScene
	var sandbox := packed.instantiate() as CombatSandbox
	sandbox.initial_enemy_count = 0
	root.add_child(sandbox)
	current_scene = sandbox
	await process_frame
	for index in TARGET_ENEMIES:
		var enemy := ENEMY_SCENES[index % ENEMY_SCENES.size()].instantiate() as Drone
		enemy.position = Vector2(170 + (index % 10) * 165, 150 + (index / 10) * 175)
		enemy.perception_enabled = true
		enemy.set_target(sandbox.player)
		sandbox.actors.add_child(enemy)
	for index in HAZARD_SCENES.size():
		var hazard := HAZARD_SCENES[index].instantiate() as Hazard
		hazard.position = Vector2(620 + index * 380, 560)
		sandbox.world.add_child(hazard)
	for index in TARGET_PROJECTILES:
		var projectile := PROJECTILE_SCENE.instantiate() as Projectile
		sandbox.add_child(projectile)
		projectile.position = Vector2(180 + (index % 20) * 65, 120 + (index / 20) * 150)
		projectile.configure(Vector2.from_angle(float(index) * 0.37), 0.1, 120.0, 8.0, sandbox.player)
	var started := Time.get_ticks_usec()
	for frame in PROFILE_FRAMES:
		if frame % 30 == 0:
			for enemy in get_nodes_in_group(&"enemies"):
				if enemy is Drone:
					(enemy as Drone).hear_noise(NoiseEvent.new(sandbox.player.global_position, 1200.0, &"stress", sandbox.player))
		await process_frame
	var elapsed_ms := float(Time.get_ticks_usec() - started) / 1000.0
	var average_ms := elapsed_ms / PROFILE_FRAMES
	print("Phase 3 profile: %d mixed enemies, %d projectiles, %d frames, %.3f ms average" % [TARGET_ENEMIES, TARGET_PROJECTILES, PROFILE_FRAMES, average_ms])
	current_scene = null
	sandbox.queue_free()
	for cleanup_frame in 30:
		await process_frame
	quit(0 if average_ms < 16.667 else 1)

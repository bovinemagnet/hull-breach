class_name CombatHud
extends CanvasLayer

signal resume_requested
signal restart_requested
signal quit_requested

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel
@onready var ammo_label: Label = %AmmoLabel
@onready var ammo_title: Label = %AmmoTitle
@onready var reload_label: Label = %ReloadLabel
@onready var status_label: Label = %StatusLabel
@onready var pause_overlay: Control = %PauseOverlay
@onready var death_overlay: Control = %DeathOverlay
@onready var resume_button: Button = %ResumeButton
@onready var pause_restart_button: Button = %PauseRestartButton
@onready var quit_button: Button = %QuitButton
@onready var death_restart_button: Button = %DeathRestartButton

var _weapon: Weapon


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(func() -> void: resume_requested.emit())
	pause_restart_button.pressed.connect(func() -> void: restart_requested.emit())
	quit_button.pressed.connect(func() -> void: quit_requested.emit())
	death_restart_button.pressed.connect(func() -> void: restart_requested.emit())
	pause_overlay.hide()
	death_overlay.hide()
	reload_label.hide()


func bind_player(player: Player) -> void:
	player.health_component.health_changed.connect(_on_health_changed)
	player.weapon_changed.connect(_on_weapon_changed)
	_on_weapon_changed(player.weapon, player.weapon_inventory.current_slot)
	_on_health_changed(player.health_component.current_health, player.health_component.maximum_health)


func _on_weapon_changed(weapon: Weapon, slot: int) -> void:
	if _weapon != null:
		if _weapon.ammo_changed.is_connected(_on_ammo_changed):
			_weapon.ammo_changed.disconnect(_on_ammo_changed)
		if _weapon.reload_started.is_connected(_on_reload_started):
			_weapon.reload_started.disconnect(_on_reload_started)
		if _weapon.reload_finished.is_connected(_on_reload_finished):
			_weapon.reload_finished.disconnect(_on_reload_finished)
	_weapon = weapon
	_weapon.ammo_changed.connect(_on_ammo_changed)
	_weapon.reload_started.connect(_on_reload_started)
	_weapon.reload_finished.connect(_on_reload_finished)
	ammo_title.text = "%d  %s" % [slot + 1, _weapon.definition.display_name.to_upper()]
	reload_label.hide()
	_on_ammo_changed(_weapon.current_magazine, _weapon.reserve_ammo)


func show_pause(visible: bool) -> void:
	pause_overlay.visible = visible
	if visible:
		resume_button.grab_focus()


func show_death() -> void:
	pause_overlay.hide()
	death_overlay.show()
	death_restart_button.grab_focus()


func update_status(enemy_count: int, fps: float, invulnerable: bool) -> void:
	var invulnerability_text := "  INVULNERABLE" if invulnerable else ""
	status_label.text = "HOSTILES %02d   FPS %03d%s" % [enemy_count, int(fps), invulnerability_text]


func _on_health_changed(current: float, maximum: float) -> void:
	health_bar.max_value = maximum
	health_bar.value = current
	health_label.text = "%03d / %03d" % [int(current), int(maximum)]


func _on_ammo_changed(current: int, reserve: int) -> void:
	ammo_label.text = "%02d  /  %03d" % [current, reserve]


func _on_reload_started() -> void:
	reload_label.text = "RELOADING"
	reload_label.show()


func _on_reload_finished() -> void:
	reload_label.hide()

# Hull Breach — Phase 1 Product Requirements and Implementation Plan

**Phase:** 1 — Combat Sandbox
**Project:** Hull Breach
**Status:** Proposed
**Engine:** Godot 4.7.2 Standard
**Language:** GDScript
**Renderer:** Compatibility
**Depends On:** Phase 0 complete
**Target Version:** `0.1.0`
**Estimated Effort:** 1–2 focused development weeks

---

# 1. Purpose

Phase 1 proves the fundamental gameplay question:

> **Is moving around and shooting aliens fun?**

The phase produces a small combat sandbox containing:

* player movement;
* independent aiming;
* mouse/keyboard controls;
* controller controls;
* one firearm;
* ammunition;
* reload;
* projectiles;
* one basic enemy;
* enemy movement;
* enemy attack;
* player health;
* enemy health;
* player death;
* enemy death;
* restart;
* basic HUD;
* basic audio/visual combat feedback.

No campaign or mission systems are required.

The end result must feel like a small playable game rather than a collection of disconnected technical demonstrations.

---

# 2. Phase 1 Product Goal

At the end of Phase 1, the player should be able to launch:

```text
res://levels/dev/combat_sandbox.tscn
```

and immediately:

1. move around a room;
2. aim independently of movement;
3. fire a pulse rifle;
4. reload;
5. fight aliens;
6. take damage;
7. kill aliens;
8. die;
9. restart;
10. play using either mouse/keyboard or controller.

The phase should answer:

> Is the foundation of Hull Breach enjoyable enough to justify building the vertical slice?

---

# 3. Success Criteria

Phase 1 succeeds when:

* movement feels responsive;
* aiming feels precise;
* shooting has satisfying audiovisual feedback;
* enemies provide enough pressure to make movement meaningful;
* controller gameplay feels viable;
* the player understands health and ammunition without explanation;
* twenty or more enemies can operate simultaneously at 60 FPS;
* no major combat system is tightly coupled to a specific scene;
* a second weapon or enemy could be added without rewriting the existing systems.

---

# 4. Non-Goals

Phase 1 explicitly does **not** implement:

* campaign;
* missions;
* access cards;
* doors;
* terminals;
* power systems;
* noise-driven AI;
* advanced enemy perception;
* stealth;
* save games;
* persistent inventory;
* armour;
* environmental hazards;
* mobile controls;
* final lighting;
* procedural generation;
* bosses;
* multiplayer;
* achievements;
* Steam integration;
* final artwork;
* final sound;
* sophisticated pathfinding behaviours.

Some supporting architecture may anticipate these systems, but Phase 1 must not build them.

---

# 5. Core Gameplay Loop

The Phase 1 loop is deliberately simple:

```text
Move
  ↓
Acquire target
  ↓
Aim
  ↓
Shoot
  ↓
Avoid enemies
  ↓
Reload
  ↓
Kill enemy
  ↓
Continue fighting
```

The player should have to make basic tactical decisions:

```text
shoot
move
reload
create distance
use obstacles
```

The sandbox must be large enough that movement matters.

---

# 6. Phase 1 Deliverables

Phase 1 must deliver:

* combat sandbox scene;
* player scene;
* player movement;
* player aiming;
* player animation baseline;
* controller input;
* mouse input;
* camera behaviour;
* health component;
* damage abstraction;
* weapon definition resource;
* weapon runtime component;
* projectile;
* ammunition;
* reload;
* muzzle flash;
* impact effect;
* one enemy scene;
* enemy definition resource;
* basic enemy AI;
* melee attack;
* enemy death;
* player death;
* restart flow;
* minimal HUD;
* test coverage for deterministic combat logic;
* debug controls useful during development;
* profiling baseline;
* Phase 1 documentation.

---

# 7. Recommended Repository Additions

After Phase 1 the relevant repository should resemble:

```text
res://

features/
├── combat/
│   ├── damage/
│   │   ├── damage_info.gd
│   │   └── health_component.gd
│   │
│   └── projectiles/
│       ├── projectile.gd
│       └── projectile.tscn
│
├── player/
│   ├── player.gd
│   ├── player.tscn
│   ├── player_config.gd
│   └── player_config.tres
│
├── weapons/
│   ├── weapon.gd
│   ├── weapon_definition.gd
│   ├── weapon_definition.tres
│   └── pulse_rifle/
│       ├── pulse_rifle.tscn
│       └── pulse_rifle.tres
│
├── enemies/
│   ├── common/
│   │   ├── enemy.gd
│   │   └── enemy_definition.gd
│   │
│   └── drone/
│       ├── drone.gd
│       ├── drone.tscn
│       └── drone.tres
│
└── pickups/
    └── ammo/
        ├── ammo_pickup.gd
        └── ammo_pickup.tscn

levels/
└── dev/
    └── combat_sandbox/
        ├── combat_sandbox.gd
        └── combat_sandbox.tscn

ui/
└── hud/
    ├── combat_hud.gd
    └── combat_hud.tscn

resources/
└── difficulty/

audio/
├── weapons/
├── enemies/
└── player/

tests/
├── unit/
│   ├── combat/
│   └── weapons/
│
└── integration/
    └── combat/
```

Avoid creating folders solely because they might someday be needed.

---

# 8. Architectural Principles

Phase 1 should establish several patterns that subsequent phases can reuse.

---

# 8.1 Composition Over Inheritance

Do not create:

```text
Actor
→ LivingActor
→ ArmedActor
→ PlayerActor
```

or:

```text
Enemy
→ MeleeEnemy
→ FastMeleeEnemy
→ Drone
```

Prefer composition.

Example player:

```text
Player
├── Sprite
├── CollisionShape2D
├── WeaponPivot
├── HealthComponent
└── Camera2D
```

Example enemy:

```text
Drone
├── Sprite
├── CollisionShape2D
├── HealthComponent
├── AttackArea
└── NavigationAgent2D
```

---

# 8.2 Configuration Separate From Behaviour

Game tuning values should live primarily in custom Resources.

Examples:

```text
PlayerConfig
WeaponDefinition
EnemyDefinition
```

Behaviour remains in scripts.

This allows balancing without changing code.

---

# 8.3 Signals for State Changes

Use signals for meaningful state changes.

For example:

```gdscript
signal health_changed(current: float, maximum: float)
signal died
```

Weapon:

```gdscript
signal ammo_changed(current: int, reserve: int)
signal fired
signal reload_started
signal reload_finished
```

HUD observes these signals.

The weapon should not contain code such as:

```gdscript
hud.update_ammo(...)
```

---

# 8.4 Avoid Global Managers

Do not create a global:

```text
CombatManager
EnemyManager
PlayerManager
BulletManager
```

unless a demonstrated requirement appears.

Phase 1 does not need them.

---

# 9. Collision Layers

Define collision layers intentionally before adding multiple game objects.

Recommended initial layout:

| Layer | Name             |
| ----: | ---------------- |
|     1 | World            |
|     2 | Player           |
|     3 | Enemy            |
|     4 | PlayerProjectile |
|     5 | EnemyProjectile  |
|     6 | Pickup           |
|     7 | Interaction      |
|     8 | Hazard           |

Phase 1 primarily uses:

```text
World
Player
Enemy
PlayerProjectile
Pickup
```

---

# 10. Collision Matrix

Recommended behaviour:

### Player

Collides with:

* World;
* Enemy.

Does not collide physically with:

* player projectiles;
* pickups.

Pickups use areas.

---

### Enemy

Collides with:

* World;
* Player;
* other enemies where appropriate.

Exact enemy-vs-enemy collision behaviour should be evaluated during Phase 1.

Too much rigid collision between enemies often causes undesirable clumping.

---

### Player Projectile

Detects:

* World;
* Enemy.

Does not detect:

* Player;
* Pickup.

---

# 11. Player Scene

Create:

```text
features/player/player.tscn
```

Suggested structure:

```text
Player (CharacterBody2D)
├── CollisionShape2D
├── Visuals
│   └── AnimatedSprite2D
│
├── WeaponPivot (Node2D)
│   ├── WeaponAnchor (Marker2D)
│   └── AimMarker (Marker2D)
│
├── HealthComponent
├── Hurtbox
├── Camera2D
└── Audio
    ├── DamageAudio
    └── DeathAudio
```

The exact sprite setup depends on the prototype artwork.

---

# 12. Player Configuration Resource

Create:

```text
features/player/player_config.gd
```

Example:

```gdscript
class_name PlayerConfig
extends Resource

@export var move_speed: float = 180.0
@export var acceleration: float = 1600.0
@export var deceleration: float = 1800.0

@export var max_health: float = 100.0

@export var controller_aim_deadzone: float = 0.20
@export var controller_move_deadzone: float = 0.15
```

Create:

```text
player_config.tres
```

Do not bury tuning constants throughout `player.gd`.

---

# 13. Player Movement

Movement uses:

```gdscript
Input.get_vector(
    "move_left",
    "move_right",
    "move_up",
    "move_down"
)
```

Movement must support:

* keyboard;
* analogue controller.

---

# 14. Movement Behaviour

Player movement should initially use acceleration rather than instantaneous velocity changes.

Concept:

```gdscript
var direction := Input.get_vector(
    "move_left",
    "move_right",
    "move_up",
    "move_down"
)

var target_velocity := direction * config.move_speed

if direction != Vector2.ZERO:
    velocity = velocity.move_toward(
        target_velocity,
        config.acceleration * delta
    )
else:
    velocity = velocity.move_toward(
        Vector2.ZERO,
        config.deceleration * delta
    )

move_and_slide()
```

The exact values must be tuned by feel.

---

# 15. Movement Requirements

Player movement must:

* be frame-rate independent;
* support eight-direction keyboard movement;
* support analogue magnitude;
* prevent diagonal movement from being faster than cardinal movement;
* react quickly enough for combat;
* stop predictably;
* slide correctly against walls;
* not become stuck on ordinary corners.

---

# 16. Sprint

Do **not** implement sprint during the first movement task.

First make normal movement feel good.

Sprint may be introduced late in Phase 1 only if it clearly improves gameplay.

If sprint is added, initially keep it simple:

```text
hold sprint
→ movement speed multiplier
```

Do not yet implement stamina.

Stamina belongs in later balancing work.

---

# 17. Player Aim Model

Aim must be completely independent from movement.

This is a foundational Hull Breach design requirement.

The player can:

```text
move west
```

while:

```text
shoot east
```

---

# 18. Mouse Aiming

For mouse:

```gdscript
var aim_direction := (
    get_global_mouse_position() - global_position
).normalized()
```

Weapon pivot points toward:

```text
aim_direction
```

---

# 19. Controller Aiming

Controller uses:

```text
aim_left
aim_right
aim_up
aim_down
```

via:

```gdscript
Input.get_vector(
    "aim_left",
    "aim_right",
    "aim_up",
    "aim_down"
)
```

If vector magnitude is less than the aim dead zone:

```text
retain previous aim direction
```

rather than snapping to zero.

This is important.

The player should continue looking in the last aimed direction when the right stick is released.

---

# 20. Aim Direction Ownership

Maintain:

```gdscript
var aim_direction: Vector2 = Vector2.RIGHT
```

as player state.

Mouse updates it continuously.

Controller updates it only when stick magnitude exceeds the dead zone.

Weapon uses this direction.

---

# 21. Input Device Switching

Phase 1 should tolerate seamlessly switching:

```text
mouse
→ controller
→ mouse
```

without entering a settings screen.

Do not require a manually selected input mode.

Later UI prompts may track the latest active input device.

---

# 22. Player Facing

Player sprite orientation is separate from weapon orientation.

Prototype options:

### Option A

Entire character rotates toward aim.

Fastest to implement.

### Option B

Character uses eight-direction aiming animations.

Better visual result.

### Recommendation for Phase 1

Start with:

```text
rotate toward aim
```

or very simple directional sprites.

Do not spend days producing animation state logic before testing combat.

---

# 23. Camera

Use:

```text
Camera2D
```

attached to player initially.

Requirements:

* smooth enough to avoid harsh movement;
* responsive enough that combat does not feel delayed;
* no cinematic effects yet.

---

# 24. Camera Look-Ahead

Optional Phase 1 enhancement:

Offset camera slightly in aim direction.

Concept:

```text
player
    ↓
       ───────────→ aim

camera centre
        ↓
slightly ahead
```

Maximum offset should be modest.

Example:

```text
30–60 logical pixels
```

This can improve visibility in the firing direction.

Do not implement until basic combat works.

---

# 25. Health Component

Create reusable:

```text
features/combat/damage/health_component.gd
```

Responsibilities:

* maximum health;
* current health;
* damage;
* healing;
* death state;
* relevant signals.

It should know nothing about:

* HUD;
* player;
* aliens;
* sound;
* animation.

---

# 26. Health Component Interface

Suggested:

```gdscript
class_name HealthComponent
extends Node

signal health_changed(current: float, maximum: float)
signal damage_received(amount: float)
signal healed(amount: float)
signal died

@export var maximum_health: float = 100.0

var current_health: float
var is_dead: bool = false
```

Functions:

```gdscript
func apply_damage(amount: float) -> void
func heal(amount: float) -> void
func reset() -> void
func health_ratio() -> float
```

---

# 27. Health Rules

Damage:

```text
current_health =
max(0, current_health - damage)
```

Death occurs exactly once.

Repeated damage after death must not emit repeated death events.

Healing cannot exceed maximum health.

Negative damage is rejected or ignored.

---

# 28. Damage Information

Do not make damage merely a raw float everywhere.

Introduce a small value object:

```text
DamageInfo
```

Example:

```gdscript
class_name DamageInfo
extends RefCounted

var amount: float
var source: Node
var hit_position: Vector2
var direction: Vector2
```

Potential future fields:

```text
damage_type
critical
status_effect
knockback
```

Do not add them until needed.

---

# 29. Why `DamageInfo`

Future systems will want to know:

* what caused damage;
* where impact occurred;
* which direction force should apply;
* whether sound/effects should spawn.

Passing a structured value now prevents awkward method changes later.

But keep it minimal.

---

# 30. Player Damage

Player damage response should initially provide:

* brief visual flash;
* hit sound;
* optional small camera shake;
* health HUD update.

No invulnerability frames unless playtesting demonstrates a need.

---

# 31. Player Death

On player health reaching zero:

1. disable gameplay input;
2. stop weapon firing;
3. play death effect;
4. show death overlay;
5. offer restart.

Phase 1 restart can simply reload:

```text
combat_sandbox.tscn
```

No checkpoint system is required.

---

# 32. Weapon Architecture

Create:

```text
WeaponDefinition
```

as a custom Resource.

This is one of the most important Phase 1 architecture decisions.

Weapons should be mostly data driven.

---

# 33. Weapon Definition

Create:

```text
features/weapons/weapon_definition.gd
```

Suggested initial fields:

```gdscript
class_name WeaponDefinition
extends Resource

@export var id: StringName
@export var display_name: String

@export var damage: float = 10.0
@export var rounds_per_second: float = 5.0

@export var magazine_size: int = 30
@export var reserve_ammo: int = 120
@export var reload_duration: float = 1.5

@export var projectile_speed: float = 600.0
@export var projectile_lifetime: float = 1.5

@export var spread_degrees: float = 0.0
@export var projectiles_per_shot: int = 1

@export var automatic: bool = true
```

Later fields may include:

```text
noise radius
recoil
screen shake
ammo type
penetration
impact effect
muzzle effect
sound
```

Phase 1 can introduce some of these if needed for weapon feel.

---

# 34. Pulse Rifle

Phase 1 weapon:

```text
HB-4 Pulse Rifle
```

Working starting values:

| Property         | Initial Value |
| ---------------- | ------------: |
| Damage           |            20 |
| Fire rate        |  8 rounds/sec |
| Magazine         |            30 |
| Reserve          |           120 |
| Reload           |       1.6 sec |
| Projectile speed |    700 px/sec |
| Spread           |            2° |
| Automatic        |           Yes |

These are tuning starting points only.

---

# 35. Weapon Runtime Scene

Create:

```text
features/weapons/weapon.gd
features/weapons/weapon.tscn
```

Suggested structure:

```text
Weapon
├── Sprite2D
├── Muzzle (Marker2D)
├── MuzzleFlash
└── AudioStreamPlayer2D
```

Runtime state:

```text
current_magazine
reserve_ammo
cooldown
is_reloading
```

---

# 36. Weapon Responsibilities

Weapon should:

* enforce rate of fire;
* consume ammunition;
* reload;
* instantiate projectiles;
* emit weapon signals;
* spawn muzzle effect;
* play firing sound.

Weapon should **not**:

* detect enemies;
* update HUD directly;
* decide player aim;
* modify mission state.

---

# 37. Fire Behaviour

If:

```text
fire pressed
AND
not reloading
AND
magazine > 0
AND
fire cooldown elapsed
```

then:

```text
spawn projectile
consume round
start cooldown
emit fired
```

For automatic weapon:

```text
Input.is_action_pressed("fire")
```

For future semi-automatic weapons:

```text
Input.is_action_just_pressed("fire")
```

Weapon Definition controls which behaviour applies.

---

# 38. Empty Magazine Behaviour

If fire attempted at zero magazine:

* do not fire;
* play dry-fire sound;
* optionally automatically initiate reload.

Recommendation:

Do **not** auto-reload initially.

Require explicit reload.

This makes resource state clearer during early testing.

Can be changed later.

---

# 39. Reload Behaviour

Reload begins when:

```text
reload pressed
AND
magazine < capacity
AND
reserve ammo > 0
AND
not already reloading
```

During reload:

* weapon cannot fire;
* reload duration runs;
* ammunition transfers on completion.

---

# 40. Reload Calculation

Example:

```text
missing = magazine_size - current_magazine

transfer = min(missing, reserve_ammo)

current_magazine += transfer
reserve_ammo -= transfer
```

Reload may be cancelled later.

Phase 1 does not require cancellation.

---

# 41. Projectile

Create:

```text
features/combat/projectiles/projectile.tscn
```

Suggested structure:

```text
Projectile (Area2D)
├── CollisionShape2D
├── Sprite2D
└── VisibleOnScreenNotifier2D
```

---

# 42. Projectile Behaviour

Projectile stores:

```text
velocity
damage_info
remaining_lifetime
```

Each physics frame:

```text
position += velocity * delta
```

or equivalent appropriate movement.

Projectile is destroyed when:

* enemy hit;
* world hit;
* lifetime expires.

---

# 43. Projectile Collision

When projectile contacts enemy:

```text
HealthComponent.apply_damage(...)
```

Then:

* spawn impact visual;
* play impact sound if appropriate;
* remove projectile.

World impact:

* spawn wall impact;
* remove projectile.

---

# 44. Hitscan vs Projectile

Use physical projectiles in Phase 1.

Reasons:

* visible pulse rifle rounds suit the style;
* projectile velocity creates interesting combat;
* implementation remains straightforward;
* later weapons can use hitscan independently.

Do not force every future weapon to use the same mechanism.

---

# 45. Projectile Pooling

Do **not** implement pooling immediately.

First:

```text
instantiate
→ use
→ queue_free
```

Profile.

Only add pooling if profiling shows allocations or node churn becoming meaningful.

At Phase 1 scale, premature pooling adds complexity without evidence.

---

# 46. Enemy Design

Phase 1 enemy:

```text
Drone
```

Characteristics:

* melee;
* straightforward pursuit;
* moderate speed;
* low health;
* short attack range.

Purpose:

> Provide a moving target and enough pressure to evaluate movement and shooting.

---

# 47. Drone Configuration

Create:

```text
EnemyDefinition
```

Example:

```gdscript
class_name EnemyDefinition
extends Resource

@export var id: StringName
@export var display_name: String

@export var maximum_health: float = 50.0
@export var move_speed: float = 90.0

@export var attack_damage: float = 10.0
@export var attack_range: float = 24.0
@export var attack_cooldown: float = 0.8

@export var detection_range: float = 500.0
```

---

# 48. Drone Starting Values

| Property       | Initial Value |
| -------------- | ------------: |
| Health         |            50 |
| Movement speed |            90 |
| Damage         |            10 |
| Attack range   |         24 px |
| Cooldown       |       0.8 sec |
| Detection      |        500 px |

The rifle therefore kills one Drone with roughly:

```text
3 hits
```

This is intentionally easy to understand while tuning.

---

# 49. Enemy Scene

Create:

```text
features/enemies/drone/drone.tscn
```

Suggested structure:

```text
Drone (CharacterBody2D)
├── CollisionShape2D
├── Visuals
│   └── AnimatedSprite2D
│
├── HealthComponent
├── Hurtbox
├── AttackArea
└── NavigationAgent2D
```

---

# 50. Phase 1 Enemy AI

Keep AI deliberately simple.

States:

```text
IDLE
CHASE
ATTACK
DEAD
```

Optionally:

```text
HIT_REACTION
```

if useful.

---

# 51. Basic State Flow

```text
             player detected
IDLE ─────────────────────────► CHASE
                                │
                                │ attack range
                                ▼
                              ATTACK
                                │
                                │ player leaves range
                                ▼
                              CHASE

ANY LIVING STATE
       │
       │ health <= 0
       ▼
      DEAD
```

---

# 52. Detection

For the combat sandbox, the enemy may simply locate the player if:

```text
distance <= detection_range
```

No line-of-sight requirement yet.

No hearing.

No patrol.

No search state.

Those belong to Phase 2.

---

# 53. Enemy Navigation

Initially:

```text
direction =
(global_player_position - global_position).normalized()
```

may be sufficient in a simple arena.

However, the sandbox should contain obstacles eventually.

Once direct steering is inadequate, introduce:

```text
NavigationAgent2D
```

Do not build custom A* pathfinding.

---

# 54. Navigation Decision

Recommended sequence:

### First implementation

Direct chase.

### Second implementation

Add walls/obstacles.

### If enemies get stuck

Introduce Godot navigation.

This avoids investing in navigation before there is a problem to solve.

---

# 55. Enemy Attack

When:

```text
distance <= attack_range
```

and:

```text
attack cooldown <= 0
```

enemy applies damage to player.

Phase 1 attack can be a simple melee strike.

Provide:

* attack animation or flash;
* attack sound;
* brief anticipation if useful.

---

# 56. Attack Telegraph

A tiny telegraph is preferable to instantaneous damage.

Example:

```text
0.15–0.25 second wind-up
```

This allows skilled movement to matter.

Exact timing must be tuned.

---

# 57. Enemy Death

When Drone dies:

* stop AI;
* disable collision or switch state appropriately;
* play death animation/effect;
* play sound;
* optionally spawn particles;
* remove after a short delay.

No corpse persistence system required.

---

# 58. Hit Feedback

Enemy hit feedback is essential.

Minimum:

* sprite flash;
* small hit effect;
* impact sound;
* optional short knockback.

Without feedback, combat will feel weak regardless of weapon statistics.

---

# 59. Knockback

Optional small knockback:

```text
enemy receives velocity impulse
```

Keep subtle.

Do not allow a pulse rifle to completely stunlock ordinary enemies unless intentionally designed.

---

# 60. Hit Stop

Experiment with extremely short hit stop:

```text
10–30 ms
```

on significant impacts.

But it must not interfere with responsive aiming.

This is a tuning experiment, not a required architecture.

---

# 61. Screen Shake

Add lightweight camera shake API if needed.

Pulse rifle:

```text
very small shake
```

Player damage:

```text
small-to-medium shake
```

Do not overuse.

Accessibility requires a later:

```text
screen shake intensity
```

setting.

Phase 1 can expose an internal debug scalar.

---

# 62. Muzzle Flash

Weapon must visually indicate firing.

Minimum:

```text
brief sprite/light/particle
```

Duration:

approximately:

```text
30–70 ms
```

Exact implementation may be:

* animated sprite;
* GPUParticles2D;
* PointLight2D;
* combination.

Start simple.

---

# 63. Weapon Sound

Phase 1 requires:

* rifle shot;
* reload;
* dry fire;
* enemy hit;
* enemy death;
* player hit.

Use CC0 or internally created placeholder sounds where available.

Record every third-party sound in:

```text
THIRD_PARTY_ASSETS.md
```

---

# 64. Temporary Art

Recommended Phase 1 visual approach:

### Player

Kenney top-down character.

### Enemy

CC0 alien sprite or simple temporary sprite.

### Environment

Warped Tech Lab tiles or simple blockout walls.

### Weapon

Kenney weapon sprite or simple placeholder.

The objective is consistency sufficient to judge gameplay.

Do not create production-quality art yet.

---

# 65. Combat Sandbox Level

Create:

```text
levels/dev/combat_sandbox/combat_sandbox.tscn
```

The sandbox should be larger than one screen.

Suggested logical size:

```text
~2000 × 1200 pixels
```

at a 640 × 360 viewport.

---

# 66. Sandbox Layout

Include:

* central open combat area;
* narrow corridor;
* several wall obstacles;
* two small side rooms;
* spawn positions;
* ammo pickup;
* player spawn;
* enemy spawn controls.

Example concept:

```text
┌────────────────────────────────────────────┐
│                                            │
│  Spawn A      ██████          Spawn B      │
│                                            │
│              █      █                      │
│              █      █                      │
│                                            │
│   ───────────── corridor ──────────────    │
│                                            │
│                PLAYER                      │
│                                            │
│       ███                     ███          │
│                                            │
│      ammo                                  │
│                                            │
└────────────────────────────────────────────┘
```

The arena must test both:

* open movement;
* fighting around obstacles.

---

# 67. Sandbox Enemy Spawning

Initial level may contain:

```text
5–10 pre-placed Drones
```

Add simple debug spawn functionality.

For example:

```text
F1 → spawn 1 Drone
F2 → spawn 10 Drones
F3 → clear enemies
```

Development-only commands should be guarded so they are not accidentally part of production input.

---

# 68. Debug Controls

Useful Phase 1 debug controls:

```text
F1 spawn enemy
F2 spawn 10 enemies
F3 clear enemies
F4 toggle invulnerability
F5 restore player health
F6 refill ammunition
```

These dramatically improve tuning speed.

Do not create a sophisticated developer console yet.

---

# 69. Ammo Pickup

Implement one simple pickup:

```text
AmmoPickup
```

Use:

```text
Area2D
```

When player overlaps:

```text
reserve ammo increases
pickup disappears
```

This proves pickup architecture without building inventory.

---

# 70. Ammo Pickup Configuration

Example:

```text
+60 rounds
```

HUD should immediately update.

No interaction key required for Phase 1.

Walk-over pickup is sufficient.

---

# 71. HUD

Create:

```text
ui/hud/combat_hud.tscn
```

Minimum HUD:

```text
Health
Magazine Ammo
Reserve Ammo
```

Example:

```text
┌────────────────────────────────────────┐
│                                        │
│                                        │
│                                        │
│                                        │
│ HEALTH  ████████░░       23 / 120      │
└────────────────────────────────────────┘
```

---

# 72. HUD Rules

HUD observes player/weapon state.

It should not poll arbitrary global state every frame.

Prefer signal-driven updates.

Example:

```text
HealthComponent.health_changed
        ↓
HUD updates health bar
```

Weapon:

```text
ammo_changed
        ↓
HUD updates ammunition
```

---

# 73. Crosshair

Mouse mode should have a simple crosshair.

Requirements:

* show aim location;
* remain readable over dark and light backgrounds.

Controller does not necessarily need a screen-space crosshair if weapon direction is obvious.

However, a small world-space targeting indicator may improve twin-stick readability.

Test both.

---

# 74. Pause

Phase 1 requires basic pause:

```text
Escape / Start
```

Display:

```text
PAUSED

Resume
Restart
Quit to Bootstrap
```

No settings menu required yet.

---

# 75. Restart

Restart reloads the sandbox.

This must work:

* after player death;
* from pause menu.

Do not build checkpoint restoration.

---

# 76. Audio Bus Baseline

Create buses:

```text
Master
Music
SFX
UI
```

Phase 1 mostly uses:

```text
SFX
```

This lays groundwork for settings later.

Do not build a full audio manager.

---

# 77. Animation Requirements

Minimum prototype animations:

Player:

* idle;
* moving.

Drone:

* moving;
* attack;
* hit or flash;
* death.

Weapon:

* firing feedback;
* reload feedback optional.

If available art does not support animations, substitute transforms/effects.

Gameplay verification matters more than animation fidelity.

---

# 78. Test Strategy

Phase 1 should add tests for logic with stable expected outcomes.

Do not attempt to automate subjective combat feel.

---

# 79. Health Tests

Test:

```text
health initialises to maximum
```

```text
damage reduces health
```

```text
health cannot fall below zero
```

```text
healing cannot exceed maximum
```

```text
death emits exactly once
```

```text
damage after death does not cause second death
```

---

# 80. Weapon Definition Tests

Validate:

```text
damage > 0
fire rate > 0
magazine size > 0
reload duration >= 0
projectile speed > 0
projectiles per shot >= 1
```

Invalid configuration should fail loudly during development.

---

# 81. Ammo Tests

Test:

```text
fire consumes one round
```

```text
cannot fire with empty magazine
```

```text
reload transfers correct ammunition
```

```text
reload cannot exceed magazine capacity
```

```text
reload cannot make reserve negative
```

---

# 82. Fire Rate Tests

Given a weapon firing:

```text
8 rounds / second
```

minimum interval is:

```text
0.125 seconds
```

Test that repeated fire requests cannot exceed configured rate.

---

# 83. Enemy Health Tests

Reuse HealthComponent tests.

Do not duplicate player-specific and enemy-specific damage logic.

That is one reason for the component.

---

# 84. Enemy Attack Tests

Where practical, test deterministic attack cooldown logic separately from scene navigation.

For example:

```text
attack unavailable before cooldown expires
```

```text
attack available after cooldown
```

---

# 85. Integration Test

Add an integration test that:

1. loads combat sandbox;
2. finds player;
3. instantiates a Drone;
4. applies projectile damage;
5. confirms enemy dies after expected damage.

Avoid testing precise animations.

---

# 86. Static Configuration Validation

Add development validation that checks Resources for impossible values.

For example:

```text
WeaponDefinition.damage <= 0
```

should produce an error.

Likewise:

```text
EnemyDefinition.maximum_health <= 0
```

should fail validation.

Bad configuration should fail during development rather than silently generating broken gameplay.

---

# 87. Performance Target

Phase 1 target:

```text
60 FPS minimum
```

with:

```text
20 active Drones
100 projectiles over a short burst
normal combat effects
```

on the main development machine.

This is not a minimum hardware specification.

It is a regression baseline.

---

# 88. Stress Test

Create a repeatable stress scenario:

```text
50 Drones
continuous firing
```

Observe:

* frame time;
* physics time;
* node count;
* memory growth;
* obvious garbage/allocation issues.

The stress test does not need to represent actual game balance.

Its purpose is exposing architectural problems early.

---

# 89. Profiling Rule

Do not optimise because code "looks inefficient."

Use Godot profiler.

Optimisation requires:

```text
measurement
→ identified bottleneck
→ change
→ measurement
```

Do not prematurely introduce:

* object pooling;
* spatial partition frameworks;
* ECS;
* native extensions.

---

# 90. Frame Rate Independence

Test:

```text
30 FPS
60 FPS
120 FPS
```

Player movement speed and weapon rate must remain approximately consistent.

Do not tie gameplay mechanics to rendered frames.

---

# 91. Controller Acceptance

Test at least one common controller.

Preferred:

* Xbox controller;
* PlayStation controller if available.

Verify:

* analogue movement;
* analogue aiming;
* dead zones;
* triggers;
* pause;
* reload;
* no stick drift causing aim rotation.

---

# 92. Controller Dead Zones

Do not rely solely on hardware defaults.

Provide configurable constants.

Starting values:

```text
movement: 0.15
aim: 0.20
```

Tune through testing.

Right-stick aim needs careful dead-zone treatment.

---

# 93. Mouse Acceptance

Mouse aiming must remain accurate when:

* camera moves;
* viewport scales;
* window changes size.

Aim calculation must use correct world coordinates.

---

# 94. Resolution Testing

Test sandbox at:

```text
1280 × 720
1920 × 1080
2560 × 1440
```

and at least one 16:10 resolution.

Ensure:

* HUD remains anchored;
* game world does not stretch;
* mouse aiming remains correct.

---

# 95. Phase 1 Art Review

At the end of the phase, explicitly mark all assets:

```text
PLACEHOLDER
PROTOTYPE
POSSIBLE FINAL
```

Do not allow prototype art to quietly become production art through inertia.

---

# 96. Combat Feel Review

Conduct deliberate tuning sessions.

Evaluate separately:

### Movement

* acceleration;
* deceleration;
* collision;
* speed.

### Aim

* mouse precision;
* controller dead zone;
* controller sensitivity.

### Weapon

* fire rate;
* damage;
* projectile speed;
* spread;
* recoil;
* sound;
* muzzle flash.

### Enemy

* speed;
* health;
* attack range;
* attack timing.

Do not change five systems simultaneously.

Tune one dimension at a time.

---

# 97. Recommended Tuning Baseline

Initial experimental values:

## Player

```text
Speed: 180
Acceleration: 1600
Deceleration: 1800
Health: 100
```

## Pulse Rifle

```text
Damage: 20
Fire rate: 8/sec
Magazine: 30
Reserve: 120
Reload: 1.6 sec
Projectile: 700 px/sec
Spread: 2°
```

## Drone

```text
Health: 50
Speed: 90
Damage: 10
Attack cooldown: 0.8 sec
```

Meaning:

```text
Drone requires ~3 rifle hits
```

and:

```text
player survives ~10 full enemy hits
```

These numbers provide a forgiving baseline.

Later phases can increase tension.

---

# 98. Game Feel Target

A single Drone should be easy.

Three Drones should require some movement.

Five should require deliberate positioning.

Ten should feel dangerous.

If twenty Drones can surround the player and the correct response remains:

```text
stand still and hold fire
```

the movement/combat relationship needs tuning.

---

# 99. Phase 1 Development Backlog

Recommended issue breakdown:

```text
P1-001 Create combat sandbox level

P1-002 Implement PlayerConfig

P1-003 Implement player movement

P1-004 Implement mouse aiming

P1-005 Implement controller aiming

P1-006 Add player camera

P1-007 Implement HealthComponent

P1-008 Implement DamageInfo

P1-009 Create WeaponDefinition

P1-010 Implement pulse rifle

P1-011 Implement projectile

P1-012 Add projectile/world collision

P1-013 Add enemy damage

P1-014 Implement Drone enemy

P1-015 Add Drone pursuit behaviour

P1-016 Add Drone melee attack

P1-017 Add player damage and death

P1-018 Add enemy death

P1-019 Add weapon reload

P1-020 Add ammunition pickup

P1-021 Add combat HUD

P1-022 Add combat audio feedback

P1-023 Add hit feedback

P1-024 Add pause/restart flow

P1-025 Add combat unit tests

P1-026 Add combat integration test

P1-027 Add enemy stress test

P1-028 Controller tuning

P1-029 Combat tuning pass

P1-030 Phase 1 clean-clone/build validation
```

---

# 100. Recommended Implementation Sequence

Do not attempt all systems simultaneously.

---

## Step 1 — Combat Sandbox

Create empty sandbox with:

* floor;
* walls;
* obstacles;
* spawn point.

No player logic yet.

---

## Step 2 — Player Movement

Implement:

* player scene;
* collision;
* keyboard movement;
* controller movement.

Acceptance:

> Player movement feels good without weapons.

Do not proceed if movement feels poor.

---

## Step 3 — Independent Aiming

Add:

* mouse aim;
* controller aim;
* weapon pivot placeholder.

Acceptance:

> Player can circle one direction while aiming another.

---

## Step 4 — Camera

Add:

* Camera2D;
* smoothing only if useful.

Verify mouse aim remains correct.

---

## Step 5 — Health Component

Create and test generic health.

No enemies needed yet.

---

## Step 6 — Weapon Definition

Create configurable pulse rifle data.

---

## Step 7 — Projectile

Create projectile scene.

Initially fire against walls/targets.

---

## Step 8 — Firing

Connect:

```text
input
→ weapon
→ projectile
```

Add:

* fire rate;
* magazine consumption.

At this point, firing should already have simple sound/flash.

---

## Step 9 — Target Dummy

Before implementing AI, create stationary damage target.

Confirm:

```text
shoot
→ damage
→ death
```

works.

This isolates weapon problems from AI problems.

---

## Step 10 — Drone

Replace target dummy with moving Drone.

Implement:

```text
IDLE
CHASE
```

---

## Step 11 — Drone Attack

Add:

```text
ATTACK
```

and player damage.

---

## Step 12 — Death / Restart

Player can:

```text
die
→ restart
```

Now a complete game loop exists.

---

## Step 13 — Reload

Implement magazine/reserve mechanics.

---

## Step 14 — HUD

Add:

```text
health
ammo
```

---

## Step 15 — Ammo Pickup

Add simple replenishment.

---

## Step 16 — Combat Feedback

Add:

* hit flash;
* muzzle flash;
* firing audio;
* impact effects;
* death feedback;
* minor screen shake if appropriate.

This is where combat should start feeling like a game.

---

## Step 17 — Controller Pass

Play exclusively with controller.

Do not merely verify that buttons technically work.

Tune until controller is enjoyable.

---

## Step 18 — Stress Test

Spawn:

```text
20
50
```

Drones.

Profile.

---

## Step 19 — Tuning

Tune:

```text
player speed
weapon damage
fire rate
reload
enemy speed
enemy health
attack timing
```

---

## Step 20 — Phase Review

Ask:

> Would I voluntarily play this combat sandbox for five minutes?

If not, do not move to Phase 2 yet.

---

# 101. Suggested Branch Sequence

Example:

```text
feature/player-movement
feature/player-aiming
feature/health-component
feature/pulse-rifle
feature/drone-enemy
feature/combat-hud
feature/combat-feedback
```

Small coherent PRs are preferred.

Avoid one:

```text
feature/phase-1
```

branch existing for two weeks.

---

# 102. Suggested Commit Examples

```text
feat: add player movement

feat: add twin-stick aiming

feat: add reusable health component

feat: add configurable pulse rifle

feat: add projectile damage

feat: add drone enemy

feat: add enemy melee attacks

feat: add combat HUD

feat: add reload and ammunition

feat: add combat feedback

test: cover health and ammunition rules

perf: profile combat sandbox under enemy load
```

---

# 103. Pull Request Testing

Every gameplay PR should include:

```text
Manual Test
```

Example:

```text
- Keyboard movement tested
- Xbox controller tested
- 1080p window tested
- 20 enemies tested
```

Visual changes should include:

```text
screenshot
```

or ideally:

```text
short gameplay capture
```

when useful.

---

# 104. Definition of Done — Player

* [ ] Player scene exists.
* [ ] Movement works with WASD.
* [ ] Movement works with controller.
* [ ] Diagonal speed is correct.
* [ ] Collision works against walls.
* [ ] Mouse aiming works.
* [ ] Controller aiming works.
* [ ] Aim persists when stick returns to centre.
* [ ] Camera follows player.
* [ ] Player can take damage.
* [ ] Player can die.
* [ ] Player can restart.

---

# 105. Definition of Done — Weapon

* [ ] WeaponDefinition exists.
* [ ] Pulse rifle configuration exists.
* [ ] Rifle fires projectiles.
* [ ] Fire rate is enforced.
* [ ] Magazine is consumed.
* [ ] Empty magazine cannot fire.
* [ ] Reload works.
* [ ] Reserve ammunition works.
* [ ] Projectile damages enemy.
* [ ] Projectile stops on world collision.
* [ ] Muzzle feedback exists.
* [ ] Fire sound exists.
* [ ] Ammo changes propagate to HUD.

---

# 106. Definition of Done — Enemy

* [ ] Drone scene exists.
* [ ] Drone configuration is data driven.
* [ ] Drone detects player.
* [ ] Drone pursues player.
* [ ] Drone attacks player.
* [ ] Attack cooldown works.
* [ ] Drone receives projectile damage.
* [ ] Hit feedback exists.
* [ ] Drone dies.
* [ ] Dead Drone no longer attacks.
* [ ] Multiple Drones work simultaneously.

---

# 107. Definition of Done — Sandbox

* [ ] Combat sandbox exists.
* [ ] Player spawn exists.
* [ ] Enemy spawns exist.
* [ ] Obstacles exist.
* [ ] Narrow and open combat areas exist.
* [ ] Ammo pickup exists.
* [ ] Pause works.
* [ ] Restart works.
* [ ] HUD works.
* [ ] Debug spawn commands work.
* [ ] Sandbox can be played without editor manipulation.

---

# 108. Definition of Done — Quality

* [ ] Relevant unit tests pass.
* [ ] Integration test passes.
* [ ] CI passes.
* [ ] No repeated runtime errors.
* [ ] No repeated runtime warnings.
* [ ] 20-enemy scenario maintains 60 FPS.
* [ ] 50-enemy stress scenario has been profiled.
* [ ] Keyboard/mouse feels usable.
* [ ] Controller feels usable.
* [ ] Combat has audible and visual feedback.
* [ ] Third-party asset licences recorded.

---

# 109. Phase 1 Acceptance Test

A developer performs:

```text
1. Clone repository.

2. Run tests.

3. Launch combat sandbox.

4. Move using WASD.

5. Aim with mouse.

6. Fire rifle.

7. Kill Drone.

8. Reload.

9. Collect ammunition.

10. Allow Drone to damage player.

11. Die.

12. Restart.

13. Switch to controller.

14. Move using left stick.

15. Aim using right stick.

16. Fire using trigger.

17. Spawn 20 Drones.

18. Complete a combat encounter.

19. Verify stable frame rate.

20. Produce debug export.
```

If this works without editor intervention, Phase 1 is technically complete.

---

# 110. Subjective Acceptance Test

Technical correctness alone is insufficient.

Before Phase 1 closes, perform several five-minute combat sessions.

Evaluate:

```text
Does movement feel immediate?
```

```text
Is aiming satisfying?
```

```text
Can the player tell when a shot hits?
```

```text
Does killing an alien feel satisfying?
```

```text
Does reloading create vulnerability?
```

```text
Does being surrounded create pressure?
```

```text
Does controller play feel natural?
```

If these answers are mostly no, the phase is not complete even if every automated test passes.

---

# 111. Phase 1 Metrics

Useful development metrics:

### Combat

```text
average Drone time-to-kill
player time-to-death
rifle rounds used per Drone
```

### Performance

```text
frame time with 20 Drones
frame time with 50 Drones
projectile count
node count
```

### Gameplay

```text
number of shots required to kill
reload frequency
enemy contact frequency
```

Do not build telemetry infrastructure.

Manual observation/debug output is enough.

---

# 112. Recommended Time Allocation

For a roughly two-week Phase 1:

| Area                     | Approximate Share |
| ------------------------ | ----------------: |
| Player/input             |               15% |
| Weapons/projectiles      |               20% |
| Health/damage            |               10% |
| Enemy AI                 |               20% |
| HUD/restart              |               10% |
| Combat feedback          |               15% |
| Testing/profiling/tuning |               10% |

Do not spend 50% of the phase on architecture.

---

# 113. Phase 1 Risks

## Risk — Movement feels sluggish

Mitigation:

Tune acceleration, deceleration and speed early.

Do not compensate with effects.

---

## Risk — Controller aim feels poor

Mitigation:

Test controller from the first week.

Tune:

* dead zone;
* sensitivity;
* response curve.

Do not postpone controller until mobile work.

---

## Risk — Combat feels weak

Likely causes:

* insufficient hit feedback;
* poor weapon audio;
* enemies too spongey;
* projectile velocity wrong;
* insufficient muzzle feedback.

Do not immediately add more weapons.

Make the first weapon good.

---

## Risk — Enemy clumping

Possible causes:

* collision between enemies;
* identical steering;
* direct pursuit.

Phase 1 fix can be simple:

* mild avoidance;
* slight target offsets;
* navigation avoidance.

Do not build sophisticated flocking yet.

---

## Risk — Architecture grows too quickly

Warning signs:

```text
CombatService
EntityRegistry
WeaponFactoryFactory
GlobalEventBus
DependencyContainer
```

before the rifle is fun.

Mitigation:

Prefer direct scene composition and signals.

---

# 114. Deliberate Technical Debt

The following shortcuts are acceptable during Phase 1:

* restart reloads entire sandbox;
* enemy sees player through walls;
* one ammo type;
* one weapon equipped;
* no weapon switching;
* no save state;
* direct player reference in sandbox-provided enemy context;
* placeholder sprite rotation;
* simple death effects;
* hard-coded sandbox enemy spawn locations.

These are conscious prototype decisions.

They should not be mistaken for final architecture.

---

# 115. Technical Debt That Is Not Acceptable

Do not:

* hard-code keyboard keys in player logic;
* directly manipulate HUD from combat classes;
* copy health logic into both player and enemy;
* hard-code all weapon statistics inside weapon script;
* make Drone-specific logic part of player code;
* use frame-dependent timers;
* put every gameplay system into one `game.gd`;
* use arbitrary global singletons for convenience;
* commit unlicensed assets;
* commit large generated Godot import files.

---

# 116. Phase 1 Exit Review

At completion, review four areas.

---

## Gameplay

Is the basic combat enjoyable?

---

## Architecture

Can Phase 2 add:

* doors;
* sound perception;
* objectives;
* power;
* additional enemies;

without fundamentally rebuilding Phase 1?

---

## Performance

Does the architecture comfortably handle expected small combat encounters?

---

## Development Speed

Can a new enemy or weapon be prototyped quickly?

If adding a second enemy appears to require days of infrastructure work, simplify the architecture.

---

# 117. Phase 1 Deliverable Version

Version:

```text
0.1.0
```

Tag:

```text
v0.1.0
```

Suggested release description:

```text
Hull Breach v0.1.0 — Combat Prototype

First playable combat sandbox.

Includes:

- twin-stick player movement
- mouse and controller aiming
- pulse rifle
- projectile combat
- ammunition and reload
- health and damage
- basic Drone enemy
- melee enemy attacks
- player and enemy death
- combat HUD
- combat feedback
- pause and restart
- automated combat tests
- performance stress scenario

No campaign or mission content.
```

---

# 118. Phase 1 Demonstration

The milestone demonstration should look approximately like:

```text
Launch
   ↓

Player enters industrial room
   ↓

Three Drones approach
   ↓

Player backs away while aiming independently
   ↓

Pulse rifle fires
   ↓

muzzle flash
projectiles
impact feedback
enemy hit reaction
   ↓

Drone dies
   ↓

Magazine empties
   ↓

Player retreats behind obstacle
   ↓

reload
   ↓

More Drones approach
   ↓

Player is hit
   ↓

health falls
   ↓

Player continues fighting
   ↓

eventually dies
   ↓

DEAD

Restart
```

That is the complete Phase 1 product.

---

# 119. Phase 1 Design Gate

Before starting Phase 2, answer:

### Movement

Would moving around an empty room still feel good?

### Shooting

Does firing the rifle feel satisfying before adding progression systems?

### Enemy Pressure

Does the Drone force the player to reposition?

### Twin-Stick Model

Does independent movement and aiming work naturally on both mouse and controller?

### Performance

Can the game handle considerably more enemies than a normal encounter requires?

### Architecture

Can a Shotgun and second enemy be introduced through configuration plus focused behaviour rather than rewrites?

If the answer to any major question is **no**, improve Phase 1 before introducing mission complexity.

---

# 120. First Work After Phase 1

Phase 2 should begin by turning the sandbox combat systems into a real environment.

The first Phase 2 sequence should be:

```text
real tiled room
   ↓
door
   ↓
interact action
   ↓
access-controlled door
   ↓
objective
   ↓
power state
   ↓
enemy noise perception
   ↓
small mission
```

The first major Phase 2 goal should not be:

```text
more guns
```

or:

```text
more enemy types
```

It should be proving that the combat system works inside the exploration/environmental gameplay that defines Hull Breach.

---

# 121. Phase 1 Core Principle

Phase 1 should end with a **small amount of polished gameplay**, not a large amount of unfinished functionality.

One good weapon is better than five mediocre weapons.

One believable enemy is better than six unfinished enemy classes.

One carefully tuned combat room is better than ten empty levels.

The purpose of Phase 1 is to discover whether the game's mechanical foundation deserves to become a complete product.

The milestone is complete when:

> **Moving, aiming, shooting, avoiding and killing a small group of aliens is fun even without missions, progression, story or rewards.**

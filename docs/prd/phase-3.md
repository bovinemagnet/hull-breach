# Hull Breach — Phase 3 Product Requirements and Implementation Plan

**Phase:** 3 — Production Systems
**Project:** Hull Breach
**Status:** Proposed
**Engine:** Godot 4.7.2 Standard
**Language:** GDScript
**Renderer:** Compatibility
**Depends On:** Phase 0, Phase 1 and Phase 2 complete
**Target Version:** `0.3.0`
**Estimated Effort:** 3–5 focused development weeks
**Primary Deliverable:** Production-ready reusable systems plus a second complete mission built primarily from those systems

---

# 1. Purpose

Phase 3 converts the Phase 2 vertical slice into an architecture suitable for producing the rest of the game.

Phase 2 answered:

> Is the intended Hull Breach gameplay loop enjoyable?

Phase 3 must answer:

> Can we build more of this game efficiently, reliably and consistently?

The focus shifts from proving individual mechanics to establishing:

* reusable level components;
* reusable enemy behaviours;
* scalable weapon architecture;
* persistent save/load;
* difficulty configuration;
* settings;
* spawning;
* environmental hazards;
* audio structure;
* mission transitions;
* production debugging tools;
* level-authoring conventions;
* content validation;
* a second mission.

The most important Phase 3 metric is:

> **How much custom code is required to build Mission 2?**

If Mission 2 requires another large collection of level-specific scripts, Phase 3 has failed.

---

# 2. Phase 3 Product Goal

At completion, the project should support a workflow approximately like:

```text
Create level
    ↓
paint TileMapLayers
    ↓
place reusable scenes
    ↓
configure Resources
    ↓
connect mission objectives
    ↓
place encounters
    ↓
configure power/access/hazards
    ↓
playtest
    ↓
tune data
```

rather than:

```text
Create level
    ↓
write custom mission controller
    ↓
write custom doors
    ↓
write custom enemy scripts
    ↓
write custom trigger code
    ↓
patch global state
    ↓
debug mysterious coupling
```

---

# 3. Phase 3 Core Principle

Phase 3 is not:

> Build every feature that might someday be useful.

It is:

> Generalise only the systems that the first two real missions demonstrate we need.

Avoid speculative architecture.

Every reusable abstraction must have at least one concrete production use case.

---

# 4. Primary Deliverables

Phase 3 must deliver:

* reviewed and refactored Phase 2 systems;
* production-ready level-authoring conventions;
* reusable encounter spawning;
* expanded enemy architecture;
* at least three meaningful enemy types;
* expanded weapon architecture;
* at least three usable weapons;
* reusable item/pickup architecture;
* environmental hazards;
* persistent save/load;
* save schema versioning;
* settings system;
* difficulty profiles;
* audio bus/settings integration;
* reusable mission transition system;
* level completion/results flow;
* development debug overlay;
* content validation tools;
* second complete mission;
* automated regression tests;
* updated documentation.

---

# 5. Phase 3 Success Criteria

Phase 3 succeeds when:

1. Mission 2 is completed primarily through editor configuration and reusable scenes.
2. At least three enemy archetypes share common components without copy/pasted logic.
3. At least three weapons use the same weapon framework.
4. Save/load persists campaign progress and settings across application restarts.
5. Difficulty modifies data, not duplicated levels.
6. Environmental hazards can be configured and placed without custom player code.
7. A designer can author a conventional room encounter without writing GDScript.
8. Invalid content is detected during development.
9. Existing Phase 2 gameplay remains intact.
10. Mission 2 takes materially less engineering effort than Station Blackout.

---

# 6. Non-Goals

Phase 3 does **not** require:

* the full campaign;
* all final enemies;
* all final weapons;
* final art;
* final soundtrack;
* multiplayer;
* procedural generation;
* modding;
* online services;
* achievements;
* Steam integration;
* cloud saves;
* leaderboards;
* localisation pipeline;
* final mobile polish;
* console certification;
* cinematic tooling;
* complex dialogue system.

Those are either later-phase items or intentionally out of scope for v1.

---

# 7. Phase 3 Design Review

Before implementing new systems, perform a structured review of Phase 2.

Classify issues as:

```text
KEEP
REFINE
REPLACE
DEFER
```

Review:

* Player
* Weapon
* Projectile
* HealthComponent
* Enemy
* Navigation
* Interaction
* Doors
* Access
* Power
* Noise
* Mission objectives
* Checkpoints
* HUD
* Mobile controls
* level structure
* debug tooling

Do not refactor merely because code could be "cleaner."

Refactor because:

* duplication exists;
* content creation is slow;
* dependencies are problematic;
* testing is difficult;
* future required behaviour cannot be expressed.

---

# 8. Phase 2 Technical Debt Register

Create:

```text
docs/development/technical_debt.md
```

Each item should include:

```text
ID
description
impact
priority
phase to resolve
```

Example:

```text
TD-001

Description:
Drone directly references StationBlackout player path.

Impact:
Enemy cannot be reused in another mission.

Priority:
High

Resolution:
Phase 3 enemy context refactor.
```

Do not attempt to remove every piece of technical debt.

Some debt is cheaper to keep.

---

# 9. Production Architecture Target

By the end of Phase 3, the runtime should roughly consist of:

```text
Game
│
├── Campaign / Session
│
├── Level
│   ├── Mission
│   ├── PowerGrid
│   ├── EncounterSystem
│   ├── Environment
│   └── Navigation
│
├── Player
│   ├── Health
│   ├── Weapons
│   ├── Access
│   └── Interaction
│
├── Enemies
│   ├── Perception
│   ├── Navigation
│   ├── Combat
│   └── State/Behaviour
│
├── UI
│
└── Persistence
```

These are logical boundaries.

They do not imply each box becomes a global singleton.

---

# 10. Repository Expansion

Recommended Phase 3 structure:

```text
features/
├── combat/
│   ├── damage/
│   ├── projectiles/
│   ├── status/
│   └── hit_effects/
│
├── player/
│
├── weapons/
│   ├── common/
│   ├── pistol/
│   ├── pulse_rifle/
│   └── shotgun/
│
├── enemies/
│   ├── common/
│   │   ├── perception/
│   │   ├── navigation/
│   │   ├── attacks/
│   │   └── behaviours/
│   ├── drone/
│   ├── hunter/
│   └── spitter/
│
├── encounters/
│   ├── encounter.gd
│   ├── encounter_definition.gd
│   ├── spawn_point.gd
│   └── wave_definition.gd
│
├── hazards/
│   ├── hazard.gd
│   ├── hazard_definition.gd
│   ├── fire/
│   ├── electricity/
│   └── gas/
│
├── inventory/
│   ├── item_definition.gd
│   ├── pickup.gd
│   └── pickup.tscn
│
├── persistence/
│   ├── save_game.gd
│   ├── save_service.gd
│   ├── save_migration.gd
│   └── serializers/
│
├── difficulty/
│   ├── difficulty_definition.gd
│   └── difficulty_service.gd
│
├── settings/
│   ├── game_settings.gd
│   ├── settings_service.gd
│   └── settings_defaults.tres
│
└── level_transition/
    ├── level_transition.gd
    └── mission_result.gd

levels/
├── campaign/
│   ├── station_blackout/
│   └── medical_wing/
│
└── shared/
    ├── components/
    ├── props/
    └── transitions/

resources/
├── difficulty/
├── enemies/
├── items/
└── weapons/

tools/
├── validation/
├── debug/
└── content/
```

---

# 11. Production-Level Authoring Goal

A typical level author should be able to place:

```text
Door
Terminal
Pickup
EnemySpawner
Encounter
MissionTrigger
Checkpoint
PowerConsumer
Hazard
ExtractionZone
```

and configure them from the Inspector.

The common case should require:

```text
0 lines of GDScript
```

for ordinary use.

Custom scripting remains available for genuinely unique events.

---

# 12. Scene Ownership Rule

Reusable gameplay scenes belong in:

```text
features/
```

or:

```text
levels/shared/
```

Mission-specific composition belongs under:

```text
levels/campaign/<mission>/
```

Do not copy reusable scenes into mission folders.

Example:

Good:

```text
features/doors/door.tscn
```

used by:

```text
station_blackout.tscn
medical_wing.tscn
```

Bad:

```text
station_blackout/door.tscn
medical_wing/door.tscn
```

with slightly different scripts.

---

# 13. Resource Ownership Rule

Reusable data definitions:

```text
resources/enemies/
resources/weapons/
resources/items/
```

Mission-specific encounter tuning may live alongside the mission.

Example:

```text
levels/campaign/medical_wing/encounters/
    morgue_encounter.tres
```

This separates:

```text
what a Drone is
```

from:

```text
which Drones appear in this room
```

---

# 14. Enemy Architecture Goal

Phase 3 must prove that enemy variety comes from combinations of reusable behaviours rather than copy/paste.

Initial production enemy roster:

```text
Drone
Hunter
Spitter
```

Optional fourth:

```text
Swarm
```

---

# 15. Common Enemy Scene

Consider a common enemy base composition:

```text
Enemy (CharacterBody2D)
├── Visuals
├── CollisionShape2D
├── HealthComponent
├── PerceptionComponent
├── NavigationComponent
├── AttackController
├── StatusEffectReceiver
├── Audio
└── BehaviourController
```

Enemy-specific scenes can inherit or instantiate this composition carefully.

Avoid a deep class inheritance chain.

---

# 16. EnemyDefinition Expansion

Expand:

```gdscript
class_name EnemyDefinition
extends Resource
```

Possible properties:

```text
id
display_name

maximum_health
move_speed
acceleration

vision_range
vision_angle
hearing_multiplier

attack_type
attack_damage
attack_range
attack_cooldown

preferred_range

mass / knockback resistance

contact_damage
```

Visual/audio resources may be stored separately where that keeps the definition manageable.

---

# 17. Enemy Behaviour Components

Reusable behavioural concepts may include:

```text
ChaseBehaviour
InvestigateBehaviour
SearchBehaviour
MeleeAttack
RangedAttack
MaintainDistanceBehaviour
FlankBehaviour
```

Do not build a generic behaviour-tree engine in Phase 3.

Simple explicit state machines remain preferable.

---

# 18. Drone

Role:

> Basic pressure enemy.

Behaviour:

```text
detect
→ approach
→ melee attack
```

Characteristics:

* moderate speed;
* low-to-medium health;
* common;
* easy to understand.

Drone remains the baseline enemy against which others are compared.

---

# 19. Hunter

Role:

> Fast flanking pressure.

Characteristics:

* faster than Drone;
* lower or similar health;
* longer investigate distance;
* attempts indirect approach;
* more responsive to noise.

A Hunter should feel different without simply being:

```text
Drone.speed * 1.5
```

---

# 20. Hunter Behaviour

Possible simple implementation:

When chasing:

```text
direct vector to player
        ↓
choose offset target left/right
        ↓
navigate to offset
        ↓
close from side
```

Do not implement tactical squad AI.

A small target offset is enough to produce different encounters.

---

# 21. Spitter

Role:

> Ranged positioning enemy.

Characteristics:

* maintains distance;
* ranged projectile;
* lower movement speed;
* forces player to move behind cover or close distance.

Spitter should try to remain within:

```text
preferred_min_range
preferred_max_range
```

---

# 22. Spitter Attack

Create reusable:

```text
RangedAttackComponent
```

or equivalent.

Configuration:

```text
projectile
damage
speed
cooldown
windup
```

Enemy ranged projectile should be visually distinct from player projectiles.

---

# 23. Enemy Telegraphing

All dangerous attacks should provide readable warning.

Examples:

Hunter:

```text
brief crouch / audio cue
→ lunge
```

Spitter:

```text
charge glow
→ projectile
```

Telegraphing becomes increasingly important as enemy variety grows.

---

# 24. Enemy Spawn System

Phase 2 likely used pre-placed enemies and bespoke activation.

Phase 3 introduces reusable spawning.

Create:

```text
SpawnPoint
```

with configuration such as:

```text
enemy_definition
initial_state
spawn_group
```

---

# 25. Encounter System

Create:

```text
Encounter
```

to manage a localized combat sequence.

Possible triggers:

```text
player enters area
mission objective activates
power changes
alarm starts
manual script signal
```

Possible completion conditions:

```text
all enemies dead
timer expired
player exits
specific enemy dead
```

---

# 26. EncounterDefinition

Suggested:

```gdscript
class_name EncounterDefinition
extends Resource

@export var id: StringName
@export var waves: Array[WaveDefinition]
@export var auto_start: bool
```

Do not add unnecessary complexity such as arbitrary scripting inside Resources.

---

# 27. WaveDefinition

Potential fields:

```text
delay
spawn_entries
minimum_alive_before_next
```

A spawn entry:

```text
spawn_point_id
enemy_definition
count
interval
```

---

# 28. Encounter Design Rule

Encounters should support:

```text
pre-placed enemies
+
dynamically spawned enemies
```

Do not force all enemies into wave spawning.

For a horror/exploration game, enemies already existing in the environment are often more believable.

---

# 29. Spawn Budget

Add optional limits:

```text
maximum_active_enemies
```

and:

```text
maximum_spawn_per_frame
```

to prevent spikes.

This becomes particularly useful on mobile.

---

# 30. Spawn Effects

Enemies should not visibly pop into existence near the player.

Valid spawn contexts:

* behind closed doors;
* ventilation shafts;
* incubators;
* darkness;
* off-camera corridors;
* elevators.

Spawn system should be independent of visual effect.

Level chooses the context.

---

# 31. Weapon Architecture Goal

Phase 1 proved one weapon.

Phase 3 must prove the weapon model supports genuinely different combat behaviour.

Required weapons:

```text
Sidearm
Pulse Rifle
Shotgun
```

Optional:

```text
Plasma Cutter
```

---

# 32. Sidearm

Role:

> Reliable fallback.

Suggested properties:

```text
medium damage
semi-automatic
small magazine
high accuracy
moderate noise
```

Potential design decision:

Infinite reserve ammunition.

Recommendation:

Do not make that decision until resource-pressure testing.

A small common ammo pool may be better.

---

# 33. Pulse Rifle

Role:

> General-purpose primary weapon.

Phase 1 values remain baseline.

Characteristics:

* automatic;
* medium damage;
* high ammo consumption;
* moderate noise.

---

# 34. Shotgun

Role:

> Emergency close-range control.

Characteristics:

* multiple pellets;
* large spread;
* high close-range damage;
* small magazine;
* slower reload;
* extremely loud.

Noise should make the shotgun especially interesting.

---

# 35. WeaponDefinition Expansion

Potential fields:

```text
id
display_name

fire_mode
damage
rounds_per_second

magazine_size
reload_duration

projectile_scene
projectile_speed
projectile_count
spread

ammo_type

noise_radius

recoil
camera_shake

muzzle_effect
fire_audio
dry_fire_audio
reload_audio
```

Keep most tuning data in Resources.

---

# 36. Fire Modes

Support:

```text
SEMI_AUTOMATIC
AUTOMATIC
```

Potential future:

```text
BURST
CHARGE
```

Do not implement future modes until a weapon needs them.

---

# 37. Ammo Types

Introduce simple ammo identifiers if multiple weapons require distinct ammunition.

Potential:

```text
ballistic
shells
energy
```

Avoid realistic cartridge complexity.

The player should understand ammo state immediately.

---

# 38. Weapon Inventory

Phase 3 may allow the player to carry multiple weapons.

Minimum:

```text
primary
secondary
```

or:

```text
up to 3 weapons
```

depending on desired final game design.

Recommendation:

Start with:

```text
3 weapon slots
```

because this maps well to desktop/controller/mobile UI.

---

# 39. Weapon Switching

Implement:

```text
weapon_next
weapon_previous
```

and optional direct slot keys.

Controller:

```text
LB / RB
```

Mobile:

weapon button cycles slots initially.

No radial wheel required in Phase 3.

---

# 40. Weapon Switching Requirements

Switching should:

* cancel firing;
* optionally cancel reload;
* update HUD;
* update player visuals;
* preserve each weapon's magazine state.

---

# 41. Item Architecture

Phase 2 used specific pickups.

Phase 3 should introduce reusable item definitions.

Create:

```text
ItemDefinition
```

for items such as:

```text
Medkit
RifleAmmo
ShotgunShells
AccessCredential
```

Not everything must use one universal inventory.

Access credentials may remain a specialized subsystem.

---

# 42. Generic Pickup

Create reusable:

```text
Pickup.tscn
```

configured by:

```text
ItemDefinition
quantity
```

On collection:

```text
player inventory receives item
```

or specialized callback depending on item type.

Do not build Diablo-style inventory.

---

# 43. Inventory Scope

Phase 3 inventory should support only gameplay needs:

* ammunition;
* consumables if introduced;
* weapon possession;
* access credentials.

No:

* weight;
* grid placement;
* item durability;
* crafting;
* rarity;
* vendor economy.

---

# 44. Environmental Hazards

Introduce at least two reusable hazards.

Recommended:

```text
Electrical Hazard
Fire
```

Optional third:

```text
Toxic Gas
```

---

# 45. Hazard Base

Create:

```text
Hazard
```

with configurable:

```text
damage
damage_interval
enabled
affected_groups
```

Hazards use the same damage infrastructure as weapons and enemies.

Do not create separate damage logic.

---

# 46. Electrical Hazard

Use cases:

* broken power cable;
* electrified floor;
* damaged panel.

Possible behaviour:

```text
power online
→ hazard enabled
```

This allows environmental state to create new risk after restoring power.

---

# 47. Fire Hazard

Behaviour:

```text
Area2D
→ periodic damage
```

Visual:

```text
particles
+
light
+
audio
```

No spreading fire simulation required.

---

# 48. Toxic Gas

If implemented:

```text
gas volume
→ periodic damage
```

Potentially disabled by:

```text
ventilation power
```

This becomes useful for later mission design.

Do not implement fluid simulation.

---

# 49. Environmental Interactions

Phase 3 should verify environmental systems can combine.

Example:

```text
restore power
    ↓
ventilation starts
    ↓
toxic gas clears
```

or:

```text
restore power
    ↓
damaged cable energises
    ↓
corridor becomes hazardous
```

This systemic combination is more valuable than isolated scripted events.

---

# 50. Status Effects

Do not build a large status-effect framework unless required.

If hazards require:

```text
burning
poison
stun
```

then introduce a minimal:

```text
StatusEffect
```

model.

Otherwise defer.

Direct periodic damage is sufficient for Phase 3.

---

# 51. Persistent Save System

Phase 2 checkpoints were in-memory.

Phase 3 must introduce persistence to disk.

Two categories:

```text
Profile Save
Mission Save
```

---

# 52. Profile Save

Persist:

```text
settings
difficulty
campaign progress
unlocked missions
basic statistics if desired
```

Potential:

```text
last selected weapon loadout
```

later.

---

# 53. Mission Save

Persist enough data to resume an active mission.

Minimum:

```text
mission_id
checkpoint_id
player health
weapon states
ammo
credentials
objective state
power state
world flags
```

Do not attempt to persist every enemy's precise transform unless required.

---

# 54. Save File Location

Use Godot:

```text
user://
```

Never write save files under:

```text
res://
```

Runtime content belongs in the user's writable application directory.

---

# 55. Save Data Format

Recommended Phase 3 format:

```text
JSON
```

for early development.

Advantages:

* inspectable;
* easy to debug;
* easy to test;
* easy to migrate.

For a small single-player game, JSON performance is more than sufficient.

Binary serialization can be reconsidered later.

---

# 56. Save Example

Conceptually:

```json
{
  "schema_version": 1,
  "game_version": "0.3.0",
  "profile": {
    "difficulty": "standard"
  },
  "campaign": {
    "completed_missions": [
      "station_blackout"
    ]
  },
  "active_mission": {
    "id": "medical_wing",
    "checkpoint": "checkpoint_2"
  }
}
```

Actual runtime state can contain more detail.

---

# 57. Save Schema Version

Every save must contain:

```text
schema_version
```

independent from game version.

Example:

```text
schema_version = 1
game_version = 0.3.0
```

Game release numbers and save schema versions serve different purposes.

---

# 58. Save Migration

Introduce:

```text
SaveMigration
```

architecture now.

It can initially contain no migrations.

Concept:

```text
schema 1
→ schema 2
→ schema 3
```

Do not write one giant:

```text
if old version...
```

function later.

---

# 59. Save Corruption Handling

If save cannot load:

* do not crash;
* preserve the corrupted file if practical;
* log clear error;
* offer new game / retry.

Development builds should provide more diagnostic information.

---

# 60. Atomic Save

Avoid overwriting the only save directly.

Recommended:

```text
write temp
→ validate
→ replace primary
```

Optionally retain:

```text
save.bak
```

This reduces corruption risk.

---

# 61. Save Slots

Recommendation for v1:

```text
3 campaign slots
```

or possibly:

```text
1 auto-save + New Game
```

Phase 3 only needs architecture supporting multiple profiles if desired.

Do not build a sophisticated save-browser UI yet.

---

# 62. Auto-Save

Save at:

* checkpoints;
* mission completion;
* settings change as appropriate.

Do not save every few seconds.

---

# 63. Save Indicator

When persistent save occurs:

```text
small SAVE icon
```

briefly appears.

Useful especially on mobile.

---

# 64. Settings System

Phase 3 introduces persistent user settings.

Minimum categories:

```text
Audio
Video
Controls
Gameplay
Accessibility
```

Not every setting requires a final UI yet.

---

# 65. Audio Settings

Required:

```text
Master volume
Music volume
SFX volume
UI volume
```

Values:

```text
0–100%
```

mapped to audio bus volume.

---

# 66. Video Settings — Desktop

Initial:

```text
Window mode
Resolution
VSync
```

Potential:

```text
screen shake
```

belongs under accessibility/gameplay.

Do not expose dozens of graphics settings for a simple 2D game.

---

# 67. Mobile Video Settings

Likely unnecessary:

```text
resolution selector
window mode
```

Mobile may instead expose:

```text
30 / 60 FPS
effects quality
```

only if profiling proves useful.

---

# 68. Control Settings

Phase 3 should support at least:

```text
mouse sensitivity
controller aim sensitivity
controller dead zone
mobile stick size
mobile stick opacity
```

Full input remapping can be Phase 3 or Phase 5.

Recommendation:

Implement keyboard/controller remapping during Phase 3 if the settings architecture is already being built.

---

# 69. Accessibility Settings

Introduce persistent configuration for:

```text
screen shake intensity
flash intensity / reduced flashes
aim assist
hold/toggle sprint if sprint exists
UI scale
```

Potential colour settings later.

---

# 70. Settings Persistence

Settings should save separately or in profile data.

Recommendation:

```text
user://settings.json
```

because settings apply before a campaign save may be loaded.

---

# 71. Settings Defaults

Use:

```text
GameSettings
```

resource or typed class defining defaults.

Do not scatter default values among UI controls.

---

# 72. Difficulty System

Create:

```text
DifficultyDefinition
```

Required profiles:

```text
Explorer
Standard
Survivor
```

---

# 73. DifficultyDefinition

Potential multipliers:

```text
enemy_health_multiplier
enemy_damage_multiplier
enemy_speed_multiplier
hearing_multiplier

ammo_quantity_multiplier
health_pickup_multiplier

aim_assist_strength
```

Avoid modifying every conceivable parameter.

Difficulty should remain understandable.

---

# 74. Difficulty Philosophy

Prefer changing:

```text
pressure
resources
forgiveness
```

rather than merely:

```text
enemy HP × 3
```

Survivor should not turn every enemy into a bullet sponge.

---

# 75. Explorer Mode

Potential configuration:

```text
enemy damage      0.7
enemy health      0.9
ammo quantity     1.4
health pickups    1.3
aim assist        stronger
```

---

# 76. Standard Mode

Baseline:

```text
all multipliers = 1.0
```

This is the intended experience.

---

# 77. Survivor Mode

Potential:

```text
enemy damage      1.25
enemy health      1.05
ammo quantity     0.75
health pickups    0.75
enemy hearing     1.15
```

This creates tension without turning enemies into massive health pools.

---

# 78. Difficulty Application

Do not modify saved Resources at runtime.

Calculate effective values:

```text
base value
×
difficulty multiplier
```

or copy runtime state where necessary.

Shared resource mutation can produce subtle bugs.

---

# 79. Mission Transition System

Phase 2 ends with a mission-complete screen.

Phase 3 must support campaign flow:

```text
Main Menu
   ↓
Mission
   ↓
Mission Complete
   ↓
Campaign Progress
   ↓
Next Mission
```

---

# 80. MissionResult

Create:

```text
MissionResult
```

Potential fields:

```text
mission_id
completed
completion_time
enemies_killed
shots_fired
damage_taken
difficulty
```

Statistics are optional but useful.

---

# 81. Level Transition

Create reusable transition sequence:

```text
fade out
→ unload current level
→ load next scene
→ position state
→ fade in
```

Do not add complex loading screens unless load times require them.

---

# 82. Main Menu Baseline

Phase 3 should introduce a basic real menu replacing the developer bootstrap as default launch.

Minimum:

```text
Continue
New Game
Mission Select / Continue Campaign
Settings
Quit
```

Mission Select can remain development-oriented until campaign structure is final.

---

# 83. New Game

New Game:

```text
choose difficulty
→ start Station Blackout
```

Optional:

save slot selection.

---

# 84. Continue

Continue loads:

```text
latest active mission checkpoint
```

or next mission after completed mission.

---

# 85. Campaign Progress

Minimal model:

```text
completed_missions
current_mission
```

No branching campaign required.

---

# 86. Audio Architecture

Phase 1 created audio buses.

Phase 3 formalises:

```text
Master
├── Music
├── Ambience
├── SFX
└── UI
```

Potential:

```text
Dialogue
```

later.

---

# 87. Ambience Bus

Separate:

```text
Ambience
```

from generic SFX.

This helps balance:

* machinery;
* ventilation;
* room tone;
* distant activity.

---

# 88. Music System

Phase 3 may introduce a minimal music controller.

Responsibilities:

```text
play track
crossfade track
stop
```

Do not build adaptive music middleware unless the game's music design requires it.

---

# 89. Combat Music

Recommendation:

Avoid constant combat-music transitions initially.

Hull Breach's tension may benefit more from ambience and subtle dynamic layers.

Evaluate after Mission 2.

---

# 90. Environmental Audio Components

Create reusable:

```text
AmbientEmitter
PoweredAudioEmitter
RandomAudioEmitter
```

if repeated enough.

Example:

```text
PoweredAudioEmitter
```

starts machinery sound when circuit is online.

---

# 91. Debug Overlay

Phase 3 should consolidate the growing Phase 1/2 debug tools.

Create a development-only overlay.

Potential sections:

```text
Player
Weapon
Enemy
Navigation
Noise
Mission
Power
Performance
Save
```

---

# 92. Debug Overlay — Player

Display:

```text
Position
Health
Current weapon
Magazine/reserve
Access credentials
Current objective
```

---

# 93. Debug Overlay — Performance

Display:

```text
FPS
frame time
physics frame time
enemy count
projectile count
node count
```

Do not build a custom profiler.

This is a quick operational view.

---

# 94. Debug Overlay — AI

When selecting or hovering enemy:

```text
enemy ID
state
health
target
last heard position
navigation target
```

This greatly speeds AI debugging.

---

# 95. Debug Commands

Consolidate development actions:

```text
God mode
Kill player
Refill ammo
Give all access
Spawn enemy type
Complete objective
Toggle power
Trigger encounter
Save
Load
Teleport checkpoint
```

Prefer a simple debug menu over consuming every function key.

---

# 96. Production Build Guard

Debug UI and debug controls must be disabled in production exports.

Use a clear:

```text
OS.is_debug_build()
```

or equivalent development gating strategy.

Do not rely on hiding the UI while leaving powerful inputs active.

---

# 97. Content Validation

Phase 3 should introduce validation scripts for Resources and scenes.

Examples:

WeaponDefinition:

```text
id non-empty
damage > 0
magazine_size > 0
```

EnemyDefinition:

```text
id non-empty
health > 0
movement >= 0
```

Mission:

```text
unique objective IDs
valid dependencies
valid extraction objective
```

---

# 98. Duplicate ID Validation

IDs such as:

```text
weapon
enemy
mission
objective
checkpoint
```

must be unique in their relevant scope.

Create development validation to catch duplicates.

---

# 99. Broken Reference Validation

Where practical, detect:

* missing Resource;
* missing spawn-point ID;
* invalid power circuit;
* objective referencing nonexistent node;
* missing item definition.

This is valuable because a growing campaign otherwise accumulates silent content errors.

---

# 100. CI Content Validation

Add:

```text
content validation
```

to CI.

Pipeline becomes:

```text
import
→ unit tests
→ integration tests
→ content validation
→ build
```

Broken Resource definitions should fail CI.

---

# 101. Production Enemy Tests

Tests should verify shared behaviour.

Examples:

```text
Drone uses melee attack
Hunter selects flank target
Spitter attempts preferred distance
```

Keep tests focused on deterministic decisions.

Do not test full pathfinding pixel-by-pixel.

---

# 102. Weapon Tests

For each weapon definition:

* valid configuration;
* correct fire mode;
* ammunition consumption;
* spread count;
* reload;
* switching state.

Shotgun test:

```text
one trigger pull
→ N projectiles
```

---

# 103. Difficulty Tests

Verify:

```text
Standard returns baseline
Explorer reduces enemy damage
Survivor reduces ammo allocation
```

Test that loading difficulty does not mutate base Resource definitions.

---

# 104. Save Tests

Required:

```text
save writes
load restores
invalid file handled
backup fallback
schema version read
unknown newer schema rejected gracefully
```

---

# 105. Save Round-Trip Test

Create:

```text
known game state
→ serialize
→ deserialize
→ compare
```

This is one of the most important Phase 3 regression tests.

---

# 106. Save Migration Test

Even with schema 1 only, create a test harness for future migrations.

When schema 2 eventually appears, migration tests already have a home.

---

# 107. Settings Tests

Test:

```text
defaults load
changes persist
invalid values clamp/fallback
audio bus values update
```

---

# 108. Encounter Tests

Verify:

```text
encounter starts from trigger
spawn count correct
waves progress
completion emits once
maximum active limit respected
```

---

# 109. Hazard Tests

Verify:

```text
hazard damages valid target
hazard ignores invalid target
disabled hazard causes no damage
power-linked hazard changes state
```

---

# 110. Mission 2

Phase 3 requires a second full mission.

Recommended:

# Medical Wing

Purpose:

> Prove that Phase 2 systems are reusable and introduce hazards plus new enemy behaviours.

Target duration:

```text
15–20 minutes
```

---

# 111. Medical Wing Premise

Following the C-12 distress signal, the player reaches a nearby medical/research facility where evacuation failed.

Primary objective:

> Recover the station's medical research archive and determine what caused the outbreak.

The mission should feel distinct from Station Blackout.

---

# 112. Medical Wing Design Pillars

Mission 1 focused on:

```text
power
doors
noise
```

Mission 2 should emphasize:

```text
hazards
enemy variety
route choice
resource pressure
```

while reusing Mission 1 systems.

---

# 113. Medical Wing Flow

Example:

```text
ARRIVAL
   ↓
TRIAGE
   ↓
QUARANTINE BLOCKED
   ↓
FIND MEDICAL ACCESS
   ↓
ENTER WARDS
   ↓
TOXIC / ELECTRICAL HAZARD
   ↓
RESTORE OR DISABLE SYSTEM
   ↓
RESEARCH ARCHIVE
   ↓
NEW ENEMY ENCOUNTER
   ↓
RECOVER DATA
   ↓
FACILITY RESPONSE / BREACH
   ↓
EXTRACTION
```

---

# 114. Mission 2 Reuse Target

At least:

```text
80%
```

of ordinary gameplay behaviour should come from reusable Phase 2/3 systems rather than mission-specific scripts.

This is not a strict source-code metric.

It expresses the intended authoring model.

---

# 115. Mission-Specific Code Budget

Ideally Mission 2 contains only:

```text
mission sequencing
unique scripted moment
optional special environmental event
```

No new:

```text
custom Door
custom Pickup
custom PowerGrid
custom checkpoint implementation
```

unless the existing systems genuinely need generalisation.

---

# 116. Medical Access

Reuse access system.

Credential:

```text
medical
```

No new access implementation.

This directly validates Phase 2 architecture.

---

# 117. Hazard Example — Quarantine Corridor

Possible scenario:

```text
main power online
        ↓
damaged electrical system
        ↓
corridor electrified
```

Player can:

```text
disable local circuit
```

or take another route.

This turns power into more than a simple "on is good" mechanic.

---

# 118. Hazard Example — Toxic Ward

Possible:

```text
toxic gas present
```

Player must:

```text
restore ventilation
```

to clear the area.

This validates reusable power consumers and hazard state.

---

# 119. Mission 2 Enemy Mix

Suggested:

```text
Drone
Hunter
Spitter
```

Progression:

Early:

```text
mostly Drones
```

Middle:

```text
introduce Hunter
```

Late:

```text
introduce Spitter
```

Avoid introducing both new enemies simultaneously.

---

# 120. Hunter Introduction

Design encounter where player hears movement around a corridor but does not immediately see attacker.

Hunter should flank.

The encounter teaches behaviour through experience.

---

# 121. Spitter Introduction

Introduce in a room with meaningful cover.

Player should immediately learn:

```text
standing still at range = bad
```

Do not introduce ranged enemy in a narrow corridor where its behaviour cannot be read.

---

# 122. Environmental Storytelling — Medical Wing

Examples:

* overturned gurneys;
* quarantine notices;
* failed containment;
* emergency triage;
* sealed patient rooms;
* broken specimen containers;
* medical logs;
* abandoned equipment.

Narrative should remain environmental and concise.

---

# 123. Mission 2 Checkpoints

Suggested:

```text
Mission start
Medical access obtained
Hazard cleared
Research archive reached
Final escape
```

Persistence must survive application restart.

---

# 124. Mission 2 Completion

On extraction:

```text
Medical Wing Complete
```

Campaign save updates:

```text
completed_missions += medical_wing
```

Next mission may remain unavailable until Phase 4 content exists.

---

# 125. Production Level Template

After two missions, create:

```text
levels/shared/mission_template/
```

or documented procedure.

Template should establish:

```text
World
Navigation
Mission
Power
Encounters
Lighting
Audio
SpawnPoints
PlayerSpawn
Extraction
```

Do not make a giant inherited level scene that becomes difficult to override.

A documented composition template may be safer than scene inheritance.

---

# 126. Level Authoring Checklist

Every new mission should define:

```text
mission ID
player spawn
navigation
objective chain
checkpoint locations
power circuits
access credentials
encounters
pickup budget
hazards
extraction
ambient audio
```

---

# 127. Encounter Authoring Workflow

A designer should be able to:

1. place spawn points;
2. assign IDs;
3. place Encounter node;
4. assign EncounterDefinition;
5. set trigger;
6. run level.

No custom GDScript for common combat encounters.

---

# 128. Pickup Budget

Introduce a simple level-design spreadsheet/document or Resource-based budget.

For each mission:

```text
expected ammo consumption
available ammo
health pickups
weapon pickups
```

Do not randomize critical resources yet.

---

# 129. Difficulty and Pickup Budget

Instead of manually placing three versions of every pickup:

```text
base quantity
×
difficulty multiplier
```

where appropriate.

Critical guaranteed pickups remain guaranteed.

---

# 130. Dynamic Difficulty

Do **not** implement adaptive difficulty in Phase 3.

Avoid silently changing enemies/ammo based on player performance.

Use explicit difficulty modes.

Predictability is preferable.

---

# 131. Performance Targets

Desktop normal encounter:

```text
60 FPS minimum
```

with:

```text
15 active enemies
dynamic lighting
multiple hazards
projectiles
audio
noise events
```

Target should remain comfortably above normal design load.

---

# 132. Stress Target

Repeatable test:

```text
50 standard enemies
+
100 projectiles
+
multiple lights
+
several hazards
```

Profile.

This remains an engineering stress case, not normal gameplay.

---

# 133. Mobile Performance

Mission 2 must be played on the same real mobile test device used in Phase 2.

Measure:

* frame rate;
* thermal behaviour;
* memory;
* loading;
* touch reliability.

Do not let production systems quietly make mobile unusable.

---

# 134. Loading Time

Measure:

```text
main menu → mission
checkpoint reload
mission transition
```

Target should feel quick.

For a 2D game, multi-second loading should be treated as something worth investigating.

No elaborate loading screen system unless measurements justify it.

---

# 135. Save Performance

Save should not visibly stall the game.

If JSON serialization becomes noticeable:

* reduce serialized state;
* write during transition/checkpoint moment;
* investigate threaded/file strategy later.

Do not optimize without measuring.

---

# 136. Memory Review

Phase 3 systems increase long-lived state.

Test repeated:

```text
load mission
complete
return menu
load mission
die
reload
```

Look for:

* leaked scene references;
* unfreed audio;
* persistent enemies;
* duplicate signal listeners;
* growing save objects.

---

# 137. Signal Ownership Review

Phase 3 should establish a simple rule:

> The object that connects a long-lived signal is responsible for understanding when that connection becomes invalid.

Prefer automatic connection lifecycle where Godot object ownership already handles it.

Be cautious with global/autoload emitters connected to short-lived level nodes.

---

# 138. Autoload Review

Potential legitimate autoloads by Phase 3:

```text
SettingsService
SaveService / GameSession
```

Possibly:

```text
Audio/music controller
```

if truly cross-scene.

Avoid:

```text
EnemyManager
DoorManager
MissionManager
PowerManager
```

as global singletons.

Those are generally level-scoped.

---

# 139. Game Session

Introduce a small cross-level:

```text
GameSession
```

only if required.

Responsibilities might include:

```text
current save slot
difficulty
current mission
campaign state
```

It should not become a god object containing every game system.

---

# 140. Event Architecture Review

Phase 2 may reveal signals crossing many systems.

Do not automatically create a global EventBus.

First prefer:

```text
local signals
parent scene coordination
explicit references
```

A global event mechanism should only be introduced for genuinely global events.

---

# 141. Mission Events

Examples of acceptable mission-local coordination:

```text
objective completed
→ Mission controller
→ activate encounter
```

or:

```text
PowerGrid state changed
→ PoweredHazard
```

Avoid generic strings such as:

```text
"THING_HAPPENED_42"
```

that erase type/ownership clarity.

---

# 142. Data IDs

Use stable `StringName` identifiers where practical.

Examples:

```text
station_blackout
medical_wing

drone
hunter
spitter

pulse_rifle
shotgun

engineering
medical
```

These IDs may appear in save files.

Once released, changing them requires migration.

---

# 143. Display Names vs IDs

Always distinguish:

```text
id = "pulse_rifle"
display_name = "HB-4 Pulse Rifle"
```

Save and logic use ID.

UI uses display name.

Do not save localized/display text as identity.

---

# 144. Content Localization Readiness

Full localisation is not required yet.

But avoid building logic around English strings.

Example:

Bad:

```text
if objective_name == "Restore Power":
```

Good:

```text
objective_id == &"restore_power"
```

---

# 145. Logging Improvements

Introduce lightweight categories only if debugging now requires them.

Possible helper:

```text
GameLog.debug("save", ...)
GameLog.debug("ai", ...)
```

But avoid building a sophisticated logging framework.

Godot's ordinary diagnostics remain sufficient for most cases.

---

# 146. Error Handling

Production-facing failures should degrade gracefully.

Examples:

Missing optional sound:

```text
warning
continue
```

Missing required mission definition:

```text
error
fail fast in development
```

Save corruption:

```text
recover or present safe UI
```

Do not silently swallow invalid game data.

---

# 147. Resource Validation Convention

Where custom Resources can validate themselves, consider:

```text
func validate() -> PackedStringArray
```

or an external validator.

Return human-readable issues.

Example:

```text
weapon pulse_rifle: magazine_size must be > 0
```

---

# 148. Phase 3 Tooling Goal

Developer workflow for validating project:

```bash
./tools/validate.sh
./tools/test.sh
./tools/export-debug.sh
```

Phase 3 validation should now include:

```text
Godot import
unit tests
integration tests
content validation
mission smoke tests
```

---

# 149. Mission Smoke Tests

For each campaign mission:

```text
scene loads
required systems exist
player spawn exists
mission definition valid
extraction exists
```

This catches broken scenes before manual playtesting.

---

# 150. Input Regression

All new UI must preserve:

```text
keyboard/mouse
controller
touch
```

Do not design settings and menus around mouse only.

Controller navigation should be considered now.

---

# 151. Menu Controller Support

Required:

```text
D-pad / stick navigation
A / Cross confirm
B / Circle back
```

Menus should be usable without mouse.

---

# 152. Touch Menu Support

Buttons must be large enough for touch.

No hover-only functionality.

Settings must work on mobile.

---

# 153. HUD Weapon Display

Phase 3 HUD expands to show:

```text
current weapon
magazine
reserve
weapon slot
```

Optional:

small icons for other slots.

---

# 154. Weapon Pickup

If weapons can be acquired in mission:

```text
walk/interact
→ collect weapon
```

If slot full, initial behaviour could be:

```text
replace selected weapon?
```

Recommendation:

Avoid weapon-drop management until design proves necessary.

For Phase 3, weapons may be granted by mission or menu.

---

# 155. Production Art Boundary

Phase 3 remains allowed to use placeholder/open-source art.

However, identify assets likely to survive into final production.

Update:

```text
THIRD_PARTY_ASSETS.md
```

with:

```text
status:
prototype
possible_final
replace
```

---

# 156. Audio Licensing

Apply same provenance rules to:

* music;
* ambience;
* weapon sounds;
* enemy sounds.

Audio licensing often becomes messy later if not tracked early.

---

# 157. Phase 3 Playtesting

Conduct two categories.

## System playtests

Focus on:

* new weapons;
* new enemies;
* hazards;
* difficulty.

## Mission playtests

Focus on:

* Medical Wing pacing;
* objective clarity;
* resource economy;
* encounter variety.

---

# 158. Blind Mission Test

Give Medical Wing to a player who has completed Station Blackout but has not seen Mission 2.

Do not explain:

* Hunter;
* Spitter;
* hazards;
* route.

Observe whether behaviour is readable.

---

# 159. Weapon Questions

Ask:

```text
When did you choose the shotgun instead of the rifle?
```

If answer is:

```text
I always used whichever had more ammo
```

weapon roles may not be distinct enough.

---

# 160. Enemy Questions

Ask:

```text
Did Hunter change how you moved?
```

```text
Did Spitter change your use of cover?
```

If both enemies feel like differently shaped Drones, redesign behaviour.

---

# 161. Hazard Questions

Ask:

```text
Did you understand what caused damage?
```

```text
Did you understand how to disable/avoid the hazard?
```

Environmental damage must be readable.

---

# 162. Difficulty Playtest

Complete at least part of Mission 2 on:

```text
Explorer
Standard
Survivor
```

Verify difficulty feels different for the intended reasons.

---

# 163. Phase 3 Development Backlog

Recommended issue set:

```text
P3-001 Review Phase 2 technical debt

P3-002 Refactor reusable level components

P3-003 Formalise production level structure

P3-004 Refactor common enemy architecture

P3-005 Implement Hunter enemy

P3-006 Implement Spitter enemy

P3-007 Create ranged enemy attack component

P3-008 Implement encounter system

P3-009 Implement reusable spawn points

P3-010 Implement encounter wave definitions

P3-011 Expand WeaponDefinition

P3-012 Implement weapon switching

P3-013 Implement Sidearm

P3-014 Implement Shotgun

P3-015 Implement ammo types

P3-016 Implement generic ItemDefinition

P3-017 Implement generic Pickup

P3-018 Implement electrical hazard

P3-019 Implement fire hazard

P3-020 Optional toxic gas hazard

P3-021 Implement persistent profile save

P3-022 Implement mission save

P3-023 Add save schema version

P3-024 Implement save backup/atomic write

P3-025 Add save/load tests

P3-026 Implement settings system

P3-027 Implement audio settings

P3-028 Implement control settings

P3-029 Implement accessibility settings baseline

P3-030 Implement DifficultyDefinition

P3-031 Add Explorer mode

P3-032 Add Survivor mode

P3-033 Implement campaign session state

P3-034 Implement mission transitions

P3-035 Implement basic main menu

P3-036 Implement Continue/New Game flow

P3-037 Consolidate debug overlay

P3-038 Add content validators

P3-039 Run content validation in CI

P3-040 Create Medical Wing blockout

P3-041 Build Medical Wing mission flow

P3-042 Add medical access route

P3-043 Add hazard encounter

P3-044 Add Hunter introduction

P3-045 Add Spitter introduction

P3-046 Add Medical Wing checkpoints

P3-047 Add Medical Wing extraction

P3-048 Blind playtest Medical Wing

P3-049 Performance regression pass

P3-050 Mobile regression pass

P3-051 Phase 3 documentation

P3-052 Phase 3 release validation
```

---

# 164. Recommended Implementation Sequence

The order matters.

---

## Step 1 — Phase 2 Review

Before adding anything:

* play Station Blackout;
* inspect system coupling;
* list technical debt;
* identify repeated code.

Do not start with the new enemies.

---

# 165. Step 2 — Reusable Level Components

Clean up:

```text
Door
Terminal
PowerConsumer
Checkpoint
MissionTrigger
Pickup
```

based on lessons from Station Blackout.

Acceptance:

> They can be placed in a blank test room without Station Blackout dependencies.

---

# 166. Step 3 — Second Mission Blockout

Create Medical Wing geometry immediately.

This provides a real consumer for every Phase 3 abstraction.

Do not wait until all production systems are "finished."

---

# 167. Step 4 — Common Enemy Refactor

Extract only genuinely common behaviour.

Verify Drone still behaves correctly.

---

# 168. Step 5 — Hunter

Implement Hunter.

Use Medical Wing test room.

Tune until behaviour feels distinct.

---

# 169. Step 6 — Spitter

Implement ranged combat.

This tests whether enemy architecture can support a substantially different attack model.

---

# 170. Step 7 — Encounter System

Replace repetitive mission-specific activation logic with reusable Encounter nodes.

Migrate at least one Station Blackout encounter as regression proof.

---

# 171. Step 8 — Weapon Expansion

Implement:

```text
Sidearm
Shotgun
```

using existing framework.

If this requires major weapon-script branching:

```text
if weapon == ...
```

stop and improve the data/behaviour model.

---

# 172. Step 9 — Weapon Switching

Add loadout and HUD support.

Test controller and mobile.

---

# 173. Step 10 — Generic Pickups

Refactor health/ammo pickup duplication only if it exists.

Keep specialized behaviour where it is actually simpler.

---

# 174. Step 11 — Hazards

Implement electrical hazard first.

Use in Medical Wing immediately.

Add fire second.

Do not create five hazard types before the mission uses them.

---

# 175. Step 12 — Save System

Convert Phase 2 checkpoint state into persistent save data.

Start with:

```text
save
quit
restart game
continue
```

for Station Blackout.

Then verify Medical Wing.

---

# 176. Step 13 — Settings

Build settings model before elaborate settings UI.

Test persistence.

Then add simple menu.

---

# 177. Step 14 — Difficulty

Introduce DifficultyDefinition.

Use Standard as exact previous behaviour.

Then tune Explorer and Survivor.

---

# 178. Step 15 — Campaign Flow

Add:

```text
main menu
→ Station Blackout
→ completion
→ Medical Wing
```

Now the project begins to feel like a game rather than a collection of scenes.

---

# 179. Step 16 — Medical Wing Completion

Finish mission using production systems.

Track every place where custom code was required.

This becomes architectural feedback.

---

# 180. Step 17 — Production Debugging

Consolidate debug tools once multiple systems/missions justify it.

---

# 181. Step 18 — Validation

Add Resource and mission validation.

Integrate into CI.

---

# 182. Step 19 — Performance Regression

Profile both missions.

Compare with Phase 2 baseline.

Investigate regressions before content scale increases.

---

# 183. Step 20 — Blind Playtest

Test Mission 2 with someone unfamiliar with it.

Do not explain new systems.

---

# 184. Architecture Gate — Enemies

Before Phase 3 closes:

Can you add a fourth enemy by combining:

```text
definition
movement behaviour
perception
attack
visuals
```

without rewriting the enemy core?

If not, revisit the architecture.

---

# 185. Architecture Gate — Weapons

Can you add a new weapon without modifying a central:

```text
switch weapon_type
```

statement throughout the code?

Weapon-specific behaviour may exist, but common infrastructure should remain stable.

---

# 186. Architecture Gate — Missions

Can Mission 3 be created primarily from:

```text
TileMapLayers
reusable scenes
Resources
mission objective definitions
encounter definitions
```

?

If a new custom mission controller is required for every objective, refine the mission system.

---

# 187. Architecture Gate — Persistence

Can a new saved field be added through:

```text
schema update
migration
test
```

without rewriting save architecture?

---

# 188. Architecture Gate — Difficulty

Can an enemy, weapon or pickup consult difficulty configuration without knowing which difficulty name is active?

Avoid:

```gdscript
if difficulty == "survivor":
```

spread throughout gameplay code.

Prefer effective configuration values.

---

# 189. Definition of Done — Enemy System

* [ ] Drone migrated to common architecture.
* [ ] Hunter implemented.
* [ ] Spitter implemented.
* [ ] shared perception reusable.
* [ ] shared navigation reusable.
* [ ] melee attack reusable.
* [ ] ranged attack reusable.
* [ ] noise reaction works across enemies.
* [ ] enemy configuration data-driven.
* [ ] no significant copy/paste enemy logic.

---

# 190. Definition of Done — Weapons

* [ ] Sidearm playable.
* [ ] Pulse Rifle playable.
* [ ] Shotgun playable.
* [ ] weapon switching works.
* [ ] weapon switching works with controller.
* [ ] weapon switching works on mobile.
* [ ] magazine state persists per weapon.
* [ ] ammo types work.
* [ ] noise radius is weapon-configurable.
* [ ] HUD updates correctly.

---

# 191. Definition of Done — Encounters

* [ ] reusable SpawnPoint exists.
* [ ] Encounter exists.
* [ ] encounter can start from trigger.
* [ ] encounter can start from mission event.
* [ ] wave configuration supported where needed.
* [ ] completion event works.
* [ ] maximum active limits available.
* [ ] no common encounter requires custom script.

---

# 192. Definition of Done — Hazards

* [ ] reusable hazard base exists or equivalent composition.
* [ ] electrical hazard implemented.
* [ ] fire hazard implemented.
* [ ] hazards use standard damage system.
* [ ] hazard enabled/disabled state works.
* [ ] power-linked hazard demonstrated.
* [ ] visual/audio feedback readable.

---

# 193. Definition of Done — Save System

* [ ] profile save persists.
* [ ] mission checkpoint persists.
* [ ] application restart restores mission.
* [ ] schema version stored.
* [ ] backup/atomic write strategy exists.
* [ ] corrupted save does not crash application.
* [ ] save round-trip tests pass.
* [ ] save location uses `user://`.

---

# 194. Definition of Done — Settings

* [ ] settings model exists.
* [ ] settings persist independently of mission.
* [ ] audio settings work.
* [ ] controller sensitivity persists.
* [ ] mobile control settings persist.
* [ ] screen shake setting works.
* [ ] settings menu usable by controller.
* [ ] settings menu usable by touch.

---

# 195. Definition of Done — Difficulty

* [ ] Explorer exists.
* [ ] Standard exists.
* [ ] Survivor exists.
* [ ] Standard reproduces baseline gameplay.
* [ ] difficulty stored in campaign save.
* [ ] difficulty affects intended parameters.
* [ ] base Resources are not mutated.
* [ ] difficulty tests pass.

---

# 196. Definition of Done — Campaign Flow

* [ ] main menu exists.
* [ ] New Game works.
* [ ] Continue works.
* [ ] mission transition works.
* [ ] Station Blackout completion persists.
* [ ] Medical Wing unlocks/starts.
* [ ] mission results work.
* [ ] quitting and continuing works.

---

# 197. Definition of Done — Medical Wing

* [ ] mission is 15–20 minutes.
* [ ] mission uses reusable interaction.
* [ ] mission uses reusable doors/access.
* [ ] mission uses reusable power.
* [ ] mission uses reusable checkpoints.
* [ ] mission uses reusable encounters.
* [ ] mission introduces hazards.
* [ ] mission introduces Hunter.
* [ ] mission introduces Spitter.
* [ ] mission can be completed without developer intervention.
* [ ] mission survives save/reload.
* [ ] mission works on controller.
* [ ] mission works on mobile.

---

# 198. Definition of Done — Tooling

* [ ] debug overlay consolidated.
* [ ] enemy state can be inspected.
* [ ] power state can be inspected.
* [ ] mission state can be inspected.
* [ ] save state can be inspected.
* [ ] content validators exist.
* [ ] CI runs validators.
* [ ] campaign mission smoke tests run in CI.

---

# 199. Phase 3 Acceptance Scenario

A clean user journey should now support:

```text
Launch game

↓
Main Menu

↓
New Game

↓
Choose Standard

↓
Station Blackout

↓
Complete mission

↓
Campaign progress saved

↓
Medical Wing begins/unlocks

↓
Encounter Hunter

↓
Encounter environmental hazard

↓
Acquire/use new weapon

↓
Encounter Spitter

↓
Reach checkpoint

↓
Quit application

↓
Restart game

↓
Continue

↓
Resume Medical Wing checkpoint

↓
Complete mission

↓
Progress saved
```

No editor or developer commands required.

---

# 200. Production Authoring Acceptance Scenario

A developer should also be able to:

```text
create blank mission scene

↓
paint floor/walls

↓
place navigation

↓
place doors

↓
place power consumer

↓
place access credential

↓
place encounter + spawn points

↓
assign objective definitions

↓
place checkpoint

↓
place extraction

↓
run
```

without writing custom code for common behaviour.

---

# 201. Phase 3 Metrics

Track roughly:

```text
engineering time for Mission 1
engineering time for Mission 2
```

More importantly:

```text
number of mission-specific scripts
```

and:

```text
number of reusable components required
```

The direction should be:

```text
less bespoke engineering
more content configuration
```

---

# 202. Mission 2 Efficiency Goal

Mission 2 does not have to take half the total calendar time of Mission 1, because it introduces new enemies and systems.

But common tasks such as:

```text
door
checkpoint
objective
pickup
power circuit
enemy encounter
```

should now take minutes, not hours.

---

# 203. Phase 3 Risks

## Risk — Over-generalising

Symptom:

```text
GenericGameplayActionFactory
```

appears to solve every possible future interaction.

Mitigation:

Generalise from two real use cases, not hypothetical ones.

---

## Risk — Enemy framework becomes an ECS project

Mitigation:

Use Godot nodes/components and explicit state machines.

Do not build an engine inside the engine.

---

## Risk — Save system attempts to serialize entire scene tree

Mitigation:

Persist explicit game state.

Keep ephemeral presentation state out of saves.

---

## Risk — Difficulty scattered throughout code

Mitigation:

Centralize effective configuration.

Do not write difficulty conditionals everywhere.

---

## Risk — Mission 2 becomes another custom vertical slice

Mitigation:

Track every custom script and ask whether it belongs in reusable systems.

---

## Risk — UI/settings scope explodes

Mitigation:

Only expose settings players actually need.

A 2D game does not require PC-style graphics-menu complexity.

---

# 204. Deliberate Technical Debt Allowed

Acceptable during Phase 3:

* only two full missions;
* simple campaign progression;
* JSON saves;
* basic save-slot UI;
* basic menu transitions;
* placeholder icons;
* limited weapon animations;
* simple enemy flanking;
* simple ranged AI;
* no complex status system;
* no dynamic difficulty;
* no full localisation.

---

# 205. Technical Debt Not Acceptable

Do not leave:

* mission-specific copies of reusable doors;
* duplicated enemy health/perception;
* duplicated weapon fire logic;
* save data with no schema version;
* production code depending on scene-tree absolute paths;
* settings stored only in UI nodes;
* difficulty `if` statements throughout gameplay;
* broken controller menu navigation;
* untracked asset licences;
* debug cheats active in production builds.

---

# 206. Recommended Time Allocation

For a 3–5 week Phase 3:

| Area                                 | Approximate Share |
| ------------------------------------ | ----------------: |
| Phase 2 refactor / authoring systems |               15% |
| Enemy expansion                      |               15% |
| Weapons/items                        |               10% |
| Encounters/hazards                   |               10% |
| Persistence/settings/difficulty      |               20% |
| Campaign/menu flow                   |               10% |
| Medical Wing                         |               15% |
| Testing/performance/documentation    |                5% |

The exact split will change based on Phase 2 technical debt.

---

# 207. Phase 3 Exit Review

Before progressing to content production, evaluate:

### Content velocity

Can we make rooms and encounters quickly?

### Reuse

Did Medical Wing genuinely reuse Station Blackout systems?

### Enemy variety

Do enemies create different tactical responses?

### Weapon variety

Do weapons create different decisions?

### Persistence

Can a player safely stop and resume?

### Difficulty

Do modes alter tension rather than just health bars?

### Mobile

Has the architecture remained viable on phones?

### Technical complexity

Can the codebase still be understood without a large architectural map?

---

# 208. GO / CHANGE Decision

## GO

Proceed to Phase 4 if:

* Mission 2 was materially easier to build;
* reusable systems are stable;
* save/load works;
* enemy/weapon variety works;
* content authoring is fast enough;
* performance remains healthy.

---

## CHANGE

Extend Phase 3 if:

* every mission still needs custom engineering;
* save system is fragile;
* enemy architecture has heavy duplication;
* mobile performance has degraded;
* mission authoring is cumbersome.

Do not begin producing eight missions on top of painful tools.

---

# 209. Phase 3 Release

Version:

```text
0.3.0
```

Tag:

```text
v0.3.0
```

Suggested release description:

```text
Hull Breach v0.3.0 — Production Systems

Transforms the vertical slice into a reusable production framework.

Includes:

- production level-authoring conventions
- reusable enemy architecture
- Drone, Hunter and Spitter enemies
- reusable melee and ranged attacks
- encounter and spawn systems
- Sidearm, Pulse Rifle and Shotgun
- weapon switching and ammo types
- generic item/pickup support
- electrical and fire hazards
- persistent campaign and checkpoint saves
- save schema versioning and recovery
- settings persistence
- audio, control and accessibility settings
- Explorer, Standard and Survivor difficulty modes
- campaign/session flow
- main menu and Continue/New Game
- mission transitions
- consolidated development debug tools
- automated content validation
- Medical Wing mission
- desktop and mobile regression validation

This milestone establishes the systems required for campaign content production.
```

---

# 210. First Work After Phase 3

Phase 4 should be primarily:

```text
CONTENT
```

not:

```text
ARCHITECTURE
```

The first Phase 4 tasks should be:

```text
Mission 3 blockout
Mission 4 blockout
art direction lock
enemy roster completion
weapon roster completion
audio production
campaign pacing
```

If Phase 4 immediately requires another infrastructure sprint, Phase 3 exited too early.

---

# 211. Phase 3 Core Principle

Phase 2 proves:

> We can make one good Hull Breach mission.

Phase 3 must prove:

> We can make many good Hull Breach missions without rebuilding the game every time.

The final test is therefore not how sophisticated the architecture looks.

It is whether this:

```text
new room
+
two spawn points
+
an access door
+
a power circuit
+
a hazard
+
an objective
```

can become a playable encounter quickly.

The best Phase 3 architecture is the one that disappears into the editor and lets development focus on:

> **interesting rooms, interesting enemies, interesting decisions and interesting missions.**

# Hull Breach — Phase 2 Product Requirements and Implementation Plan

**Phase:** 2 — Vertical Slice
**Project:** Hull Breach
**Status:** Proposed
**Engine:** Godot 4.7.2 Standard
**Language:** GDScript
**Renderer:** Compatibility
**Depends On:** Phase 0 and Phase 1 complete
**Target Version:** `0.2.0`
**Estimated Effort:** 3–5 focused development weeks
**Primary Deliverable:** One complete 10–15 minute mission

---

# 1. Purpose

Phase 2 transforms the Phase 1 combat prototype into the first representative version of the actual game.

Phase 1 answered:

> Is moving and shooting fun?

Phase 2 must answer:

> Is exploring a hostile facility while managing combat, ammunition, darkness, access, power and enemy attention fun?

The phase delivers one complete mission:

# Station Blackout

The mission must include:

* exploration;
* combat;
* doors;
* access control;
* terminals;
* power state;
* dynamic lighting;
* objectives;
* pickups;
* environmental storytelling;
* noise-driven enemy perception;
* checkpoints;
* HUD objective display;
* first mobile controls;
* mission completion;
* extraction.

At the end of Phase 2, Hull Breach should feel like a small version of the intended finished game.

---

# 2. Product Goal

The vertical slice must demonstrate the primary Hull Breach gameplay pillars:

```text
exploration
    +
resource pressure
    +
combat
    +
sound
    +
lighting
    +
environmental systems
    +
objectives
```

The mission should create situations where the player thinks:

> Should I fire?

rather than:

> Where is the next enemy?

The environment must affect combat decisions.

---

# 3. Phase 2 Core Question

The most important design experiment is:

```text
Player fires weapon
        ↓
weapon produces noise
        ↓
nearby aliens investigate
        ↓
combat situation changes
        ↓
player learns that firing has consequences
```

This mechanic should become one of Hull Breach's distinguishing systems.

---

# 4. Vertical Slice Mission

Working title:

# Station Blackout

Location:

**C-12 Remote Research Facility**

Mission duration target:

**10–15 minutes for a first-time player**

Replay duration:

**8–12 minutes**

---

# 5. Mission Premise

The player arrives at Research Facility C-12 after communications with the facility cease.

Initial objective:

> Restore communications with orbital command.

The facility is mostly without power.

Emergency lighting remains active in some sections.

The player must:

1. enter the facility;
2. reach communications;
3. discover communications has no power;
4. obtain engineering access;
5. reach engineering;
6. acquire or activate an auxiliary power cell;
7. restore facility power;
8. return to communications;
9. transmit the distress signal;
10. survive the resulting alarm response;
11. reach extraction.

---

# 6. Mission Flow

High-level flow:

```text
ARRIVAL
   ↓
RECEPTION
   ↓
COMMUNICATIONS
   ↓
POWER FAILURE DISCOVERED
   ↓
SEARCH SECURITY OFFICE
   ↓
OBTAIN ENGINEERING ACCESS
   ↓
ENGINEERING
   ↓
RESTORE AUXILIARY POWER
   ↓
FACILITY STATE CHANGES
   ↓
RETURN THROUGH CHANGED LEVEL
   ↓
COMMUNICATIONS
   ↓
SEND DISTRESS SIGNAL
   ↓
ALARM
   ↓
ENEMY PRESSURE
   ↓
EXTRACTION
```

---

# 7. The Return Journey Principle

The player should traverse portions of the level twice.

However, the second journey must feel different.

Before power restoration:

* darkness;
* closed powered doors;
* inactive machinery;
* fewer enemies;
* limited visibility.

After restoration:

* lights activate;
* machinery starts;
* powered doors become usable;
* incubators activate;
* alarms may sound;
* additional enemies emerge.

Therefore:

```text
same corridor
+
different system state
=
different encounter
```

This should become a fundamental Hull Breach level-design pattern.

---

# 8. Phase 2 Success Criteria

Phase 2 succeeds when a player can complete Station Blackout without developer assistance and experiences:

* exploration;
* uncertainty;
* combat pressure;
* meaningful darkness;
* meaningful ammunition usage;
* access restrictions;
* changing environment state;
* enemies responding to sound;
* a clear objective chain;
* a climactic extraction sequence.

The mission must feel substantially different from the Phase 1 combat sandbox.

---

# 9. Non-Goals

Phase 2 does **not** require:

* full campaign;
* multiple missions;
* full weapon roster;
* full enemy roster;
* final save system;
* persistent campaign progression;
* procedural generation;
* crafting;
* skill tree;
* complex inventory;
* multiplayer;
* achievements;
* Steam integration;
* final production artwork;
* final soundtrack;
* sophisticated stealth system;
* advanced enemy coordination;
* cloud saves;
* localisation;
* production mobile UI.

Phase 2 remains a vertical slice.

---

# 10. Required Phase 2 Systems

Implement:

* level TileMap architecture;
* navigation map;
* interaction system;
* doors;
* access requirements;
* terminals;
* access cards;
* mission/objective system;
* power system;
* lighting states;
* noise events;
* enemy hearing;
* investigate AI state;
* search AI state;
* ammunition pickups;
* health pickups;
* mission HUD;
* interaction prompts;
* environmental audio;
* checkpoint system;
* mission restart;
* basic mobile controls;
* one complete mission.

---

# 11. Existing Phase 1 Systems Reused

Phase 2 must reuse rather than replace:

```text
Player
HealthComponent
DamageInfo
WeaponDefinition
Weapon
Projectile
Drone
EnemyDefinition
combat HUD
controller input
pause/restart
```

Refactoring is allowed where Phase 2 exposes legitimate architectural limitations.

Avoid rewriting Phase 1 merely because another architecture now seems aesthetically cleaner.

---

# 12. Recommended Repository Additions

Phase 2 should expand the repository approximately as follows:

```text
features/
├── interaction/
│   ├── interactable.gd
│   ├── interaction_component.gd
│   ├── interaction_detector.gd
│   └── interaction_prompt.gd
│
├── doors/
│   ├── door.gd
│   ├── door.tscn
│   ├── door_definition.gd
│   └── access_requirement.gd
│
├── access/
│   ├── access_level.gd
│   ├── access_credential.gd
│   └── access_inventory.gd
│
├── terminals/
│   ├── terminal.gd
│   └── terminal.tscn
│
├── power/
│   ├── power_grid.gd
│   ├── power_consumer.gd
│   ├── power_source.gd
│   └── power_state.gd
│
├── noise/
│   ├── noise_event.gd
│   ├── noise_emitter.gd
│   ├── noise_listener.gd
│   └── noise_system.gd
│
├── missions/
│   ├── mission.gd
│   ├── mission_definition.gd
│   ├── objective.gd
│   └── objectives/
│       ├── reach_area_objective.gd
│       ├── interact_objective.gd
│       ├── collect_objective.gd
│       └── extraction_objective.gd
│
├── checkpoints/
│   ├── checkpoint.gd
│   └── checkpoint_manager.gd
│
├── lighting/
│   ├── powered_light.gd
│   └── emergency_light.gd
│
└── pickups/
    ├── ammo/
    ├── health/
    └── credentials/

levels/
├── campaign/
│   └── station_blackout/
│       ├── station_blackout.tscn
│       ├── station_blackout.gd
│       └── station_blackout_mission.tres
│
└── dev/
    ├── interaction_sandbox/
    ├── noise_sandbox/
    ├── power_sandbox/
    └── navigation_sandbox/

ui/
├── hud/
│   ├── objective_display/
│   └── interaction_prompt/
│
└── mobile/
    ├── virtual_move_stick/
    ├── virtual_aim_stick/
    └── mobile_combat_controls/
```

---

# 13. Level Technology

Use multiple:

```text
TileMapLayer
```

nodes rather than one monolithic tilemap.

Suggested level scene:

```text
StationBlackout
│
├── World
│   ├── Floor
│   ├── FloorDetail
│   ├── Walls
│   ├── WallDetail
│   ├── Decoration
│   └── Foreground
│
├── NavigationRegion2D
│
├── Interactive
│   ├── Doors
│   ├── Terminals
│   ├── Pickups
│   └── PowerSystems
│
├── Lighting
│
├── Enemies
│
├── SpawnPoints
│
├── MissionTriggers
│
├── Audio
│
└── PlayerSpawn
```

---

# 14. Tile Layer Responsibilities

Recommended:

### Floor

Base walkable tiles.

### FloorDetail

Grates, markings, stains and decals.

### Walls

Primary wall geometry.

### WallDetail

Wall panels, pipes and visual decoration.

### Decoration

Furniture and environmental detail.

### Foreground

Elements rendered over the player where required.

Collision should ideally be configured through TileSet metadata or dedicated collision geometry where appropriate.

Interactive objects should not generally be baked into tiles.

---

# 15. Interactive Objects Are Scenes

Objects with behaviour should normally remain scenes.

Examples:

```text
Door.tscn
Terminal.tscn
PowerConsole.tscn
AmmoPickup.tscn
HealthPickup.tscn
Checkpoint.tscn
```

Do not encode complicated gameplay behaviour directly into individual tile IDs.

Tiles describe environment.

Scenes describe interactive entities.

---

# 16. Prototype Art

Primary environment recommendation:

```text
Warped Top-Down Tech Lab
Warped Top-Down Tech Lab 2
Warped Top-Down Tech Lab Extension
```

Use these primarily to establish:

* corridors;
* laboratory rooms;
* engineering rooms;
* animated doors;
* wall lights;
* crates;
* barrels;
* computer displays;
* incubators;
* medical supplies.

Do not mix many unrelated tilesets unless necessary.

Visual coherence is more important than having every possible prop.

---

# 17. Level Scale

Target:

approximately:

```text
40 × 30
```

to:

```text
60 × 40
```

32-pixel tiles.

Approximate world:

```text
1280 × 960
```

to:

```text
1920 × 1280
```

logical pixels.

The exact dimensions should emerge from mission flow.

Do not make the level enormous merely because the technology permits it.

---

# 18. Mission Zones

Station Blackout should contain approximately:

1. Docking/arrival;
2. Reception;
3. Communications;
4. Security office;
5. Laboratory corridor;
6. Research laboratory;
7. Storage;
8. Engineering;
9. Power room;
10. extraction zone.

Optional:

11. maintenance shortcut.

---

# 19. Level Topology

Avoid a single linear corridor.

Preferred topology:

```text
                 ┌─ SECURITY ───────┐
                 │                  │
ARRIVAL ─ RECEPTION ─ COMMUNICATIONS
                 │                  │
                 │               LABS
                 │                  │
                 └── STORAGE ─ ENGINEERING
                                │
                              POWER
                                │
                          maintenance
                             shortcut
```

The layout should create:

* loops;
* shortcuts;
* alternate paths;
* opportunities to hear enemies before seeing them.

---

# 20. Navigation

Phase 2 should formally introduce Godot 2D navigation.

Use:

```text
NavigationRegion2D
NavigationAgent2D
```

for enemies that must traverse the facility.

The navigation data must represent actual walkable space rather than expecting rendering or collision geometry to automatically imply navigation.

---

# 21. Navigation Requirements

Enemies must be capable of:

* navigating corridors;
* moving around rooms;
* finding doorways;
* investigating sounds around corners;
* pursuing the player through multiple rooms.

Navigation must work when:

```text
player and alien do not have direct line of sight
```

This is the point where Phase 1 direct steering becomes insufficient.

---

# 22. Door and Navigation Interaction

A door must affect both:

```text
physics
```

and:

```text
navigation behaviour
```

When a door is closed:

* player collision blocks passage;
* enemy movement must treat passage appropriately.

When opened:

* passage becomes traversable.

Simplest Phase 2 solution:

Use navigation layout that allows paths through doorways while enemy movement checks actual door state.

More sophisticated dynamic navigation obstruction should only be added if necessary.

---

# 23. Interaction System

Phase 2 introduces a generic interaction mechanism.

The player should be able to interact with:

* doors;
* terminals;
* power consoles;
* mission objects;
* extraction zones where appropriate.

Interaction should not require custom player code for every object type.

---

# 24. Interaction Contract

Create a simple conceptual interface:

```text
Interactable
```

with operations:

```text
can_interact(player)
get_interaction_text(player)
interact(player)
```

GDScript may implement this through:

* base class;
* component;
* duck typing.

Prefer a small component or interface-like convention.

Do not build an elaborate reflection system.

---

# 25. Interaction Detector

Player scene gains:

```text
InteractionDetector
```

Suggested:

```text
Player
├── ...
└── InteractionDetector
    └── Area2D
```

It detects nearby interactables.

Selection rules:

1. must be in interaction range;
2. preferably favour object closest to aim direction;
3. choose closest candidate where necessary.

---

# 26. Interaction Range

Starting range:

```text
40–56 logical pixels
```

roughly one to two tiles.

Interaction should not work across walls.

---

# 27. Interaction Prompt

HUD displays:

```text
[E] Open Door
```

Controller:

```text
[A] Open Door
```

or the appropriate controller icon later.

Examples:

```text
[E] Access Terminal
[E] Restore Power
[E] Collect Engineering Card
```

Prompt disappears when no valid interaction exists.

---

# 28. Door System

Create reusable:

```text
Door.tscn
```

Door state:

```text
CLOSED
OPENING
OPEN
CLOSING
LOCKED
UNPOWERED
JAMMED
DESTROYED
```

Not every state must be used in Station Blackout, but architecture should support the important distinctions.

---

# 29. Door Scene

Suggested:

```text
Door
├── Visuals
│   └── AnimatedSprite2D
│
├── Collision
├── InteractionArea
├── NavigationObstacle
├── Audio
└── StatusLight
```

---

# 30. Door Configuration

Create:

```text
DoorDefinition
```

Potential fields:

```text
open_duration
close_duration
requires_power
auto_close
auto_close_delay
access_requirement
locked_message
```

---

# 31. Door Access

Initial access requirements:

```text
NONE
ENGINEERING
SECURITY
```

Station Blackout needs at least:

```text
ENGINEERING
```

Do not start with coloured keys unless they fit the final visual language.

A security credential model is more extensible.

---

# 32. Access Credentials

Create:

```text
AccessCredential
```

Example identifiers:

```text
engineering
security
medical
command
```

Player maintains a lightweight:

```text
AccessInventory
```

This is not the full inventory system.

It simply answers:

```text
has_access("engineering")
```

---

# 33. Engineering Credential

The Station Blackout player finds:

```text
Engineering Access Credential
```

in the security office or on a deceased station engineer.

Collection should:

* play sound;
* display notification;
* update access inventory;
* complete relevant mission objective.

Example:

```text
ENGINEERING ACCESS ACQUIRED
```

---

# 34. Door Feedback

Locked door must communicate why it does not open.

Examples:

```text
ACCESS DENIED
ENGINEERING CLEARANCE REQUIRED
```

or:

```text
NO POWER
```

Do not simply ignore the interaction.

The player must understand the difference between:

```text
locked
```

and:

```text
unpowered
```

---

# 35. Terminals

Introduce:

```text
Terminal.tscn
```

Possible behaviours:

* objective terminal;
* information terminal;
* unlock terminal;
* power terminal.

Phase 2 should avoid elaborate terminal UI.

Interaction can display short contextual information.

---

# 36. Communications Terminal

Communications terminal initially reports:

```text
COMMUNICATION ARRAY OFFLINE

AUXILIARY POWER REQUIRED
```

This updates mission objective.

Later, after power restoration:

```text
TRANSMIT DISTRESS SIGNAL
```

becomes available.

---

# 37. Power System

Power is a core environmental system.

Do not hard-code:

```text
generator turns every light on
```

inside level scripts.

Introduce a reusable power model.

---

# 38. Power Model

Phase 2 requires at least:

```text
PowerGrid
```

with circuits:

```text
emergency
main
communications
engineering
```

Station Blackout can keep the actual topology simple.

---

# 39. Power States

Possible state:

```text
OFF
EMERGENCY
ONLINE
```

For individual consumers, usually:

```text
powered = true/false
```

is sufficient.

---

# 40. Power Consumer

Create reusable:

```text
PowerConsumer
```

Consumers include:

* lights;
* doors;
* terminals;
* communications;
* machinery.

Consumer listens to power state.

Avoid central PowerGrid directly iterating over arbitrary scene children.

Prefer registration/signals or explicit connections.

---

# 41. Power Restoration Sequence

Engineering objective:

```text
Locate Auxiliary Power Control
```

Player interacts.

Sequence:

```text
switch activated
        ↓
generator audio starts
        ↓
short delay
        ↓
main power online
        ↓
lights activate section-by-section
        ↓
door indicators change
        ↓
machinery starts
        ↓
incubators activate
        ↓
new enemies become active
```

This should be one of the vertical slice's memorable moments.

---

# 42. Lighting

Phase 2 introduces lighting as gameplay.

Use 2D lights such as:

```text
PointLight2D
```

where appropriate.

Lighting should communicate system state.

---

# 43. Pre-Power Lighting

Before restoration:

* limited emergency lighting;
* player flashlight;
* occasional blinking fixtures;
* dark side rooms;
* red warning lights.

The player must still be able to navigate.

Darkness should create tension, not frustration.

---

# 44. Post-Power Lighting

After restoration:

* normal corridor lighting;
* computer screens;
* machine illumination;
* powered doors;
* brighter engineering areas.

However, some sections may remain damaged.

---

# 45. Player Flashlight

Phase 2 should introduce a simple directional flashlight.

Player:

```text
Player
└── Flashlight
    └── PointLight2D
```

or an appropriate shaped-light setup.

The flashlight follows:

```text
aim_direction
```

The flashlight is always available during Phase 2.

Do not add battery management yet.

---

# 46. Flashlight Design Rule

Flashlight must aid visibility without revealing the entire room.

Desired effect:

```text
darkness

       \ illuminated cone /
        \                /
         \              /
          PLAYER ─────►
```

Exact shape depends on chosen light texture.

---

# 47. Noise System

Phase 2 introduces the defining noise mechanic.

Create:

```text
NoiseEvent
```

Noise represents information available to nearby enemies.

---

# 48. Noise Event

Suggested:

```gdscript
class_name NoiseEvent
extends RefCounted

var position: Vector2
var radius: float
var intensity: float
var category: StringName
var source: Node
```

Potential categories:

```text
weapon
movement
door
alarm
explosion
environment
```

---

# 49. Noise Emitters

Sources can emit noise:

```text
Weapon
Door
PlayerMovement
Alarm
PowerSystem
```

Phase 2 minimum:

* pulse rifle;
* shotgun if added;
* doors;
* alarm;
* sprinting if sprint exists.

Walking noise can be added but should remain subtle.

---

# 50. Noise Radius

Starting experimental values:

| Source      |   Radius |
| ----------- | -------: |
| walking     |    60 px |
| sprint      |   140 px |
| door        |   160 px |
| pulse rifle |   320 px |
| shotgun     |   500 px |
| alarm       | 1000+ px |

These are tuning values.

The important relationship is:

```text
shotgun > rifle > movement
```

not the exact numbers.

---

# 51. Noise Delivery

Recommended approach:

```text
NoiseSystem.emit_noise(event)
```

Nearby listeners are informed.

However, avoid a design where the noise system itself controls enemy state.

Noise system says:

> A sound occurred here.

Enemy decides:

> I care about it.

---

# 52. Noise Listener

Enemy gains:

```text
NoiseListener
```

It evaluates:

* distance;
* noise intensity;
* possibly category;
* enemy hearing sensitivity.

The listener may emit:

```text
noise_heard(event)
```

Enemy AI then decides how to react.

---

# 53. Enemy AI Expansion

Phase 1:

```text
IDLE
CHASE
ATTACK
DEAD
```

Phase 2 adds:

```text
INVESTIGATE
SEARCH
```

Potential flow:

```text
IDLE
 │
 │ sound heard
 ▼
INVESTIGATE
 │
 │ reaches source
 ▼
SEARCH
 │
 ├─ sees player → CHASE
 │
 └─ timeout → IDLE
```

---

# 54. Enemy State Machine

Full Phase 2 baseline:

```text
                    sees player
       ┌──────────────────────────────┐
       │                              ▼
IDLE ──┴─ sound ─► INVESTIGATE ───► CHASE
                               │       │
                               │       │ range
                               │       ▼
                               │     ATTACK
                               │       │
                               │       └─────► CHASE
                               │
                               ▼
                             SEARCH
                               │
                               └──────► IDLE

ANY STATE
   │
   │ health <= 0
   ▼
  DEAD
```

---

# 55. Line of Sight

Phase 2 introduces actual visual perception.

Enemy should not automatically detect player through walls.

Use:

```text
distance check
+
line-of-sight ray
```

Requirements:

```text
within vision range
AND
not obstructed
```

Optional:

field-of-view angle.

---

# 56. Enemy Vision

Starting values:

```text
vision range: 350 px
field of view: 120°
```

Drone could have a broader field of view if appropriate.

Do not overcomplicate vision with realistic illumination calculations yet.

Lighting-dependent perception can be introduced later.

---

# 57. Investigate Behaviour

When noise heard:

```text
last_heard_position = noise.position
```

Enemy navigates toward that location.

If player becomes visible:

```text
CHASE
```

If enemy reaches position and does not find player:

```text
SEARCH
```

---

# 58. Search Behaviour

Keep search behaviour simple.

Enemy may:

* pause;
* look around;
* move to one or two nearby positions.

After:

```text
2–5 seconds
```

return to:

```text
IDLE
```

unless another stimulus occurs.

---

# 59. Noise Demonstration Encounter

The mission must deliberately teach the player the mechanic.

Example:

Player enters laboratory corridor.

One Drone is visible.

Several aliens are in adjacent rooms.

If player shoots:

```text
BANG
```

aliens begin moving toward the gunfire.

This creates an implicit tutorial:

> Weapons attract enemies.

No tutorial dialog is required initially.

---

# 60. Alarm Event

After distress transmission:

```text
facility alarm
```

generates a very large noise event or explicitly wakes selected enemies.

The purpose is to transition mission into:

```text
escape
```

mode.

Alarm may pulse periodically.

---

# 61. Mission System

Phase 2 requires a reusable mission/objective framework.

Do not write:

```gdscript
if has_key and generator_on and terminal_used:
    win_game()
```

inside the level script.

---

# 62. Mission Definition

Create:

```text
MissionDefinition
```

Fields:

```text
id
display_name
description
objectives
```

Station Blackout definition:

```text
station_blackout_mission.tres
```

---

# 63. Objective Base

Create:

```text
Objective
```

State:

```text
INACTIVE
ACTIVE
COMPLETED
FAILED
```

Signals:

```text
activated
completed
failed
progress_changed
```

---

# 64. Objective Types

Phase 2 needs at least:

```text
ReachAreaObjective
InteractObjective
CollectObjective
ExtractionObjective
```

Possible future:

```text
DestroyObjective
SurviveObjective
EscortObjective
RestorePowerObjective
```

Restore power may simply be an InteractObjective during Phase 2.

Avoid premature abstraction.

---

# 65. Station Blackout Objectives

Suggested sequence:

### Objective 1

```text
Reach Communications
```

### Objective 2

```text
Restore Facility Power
```

Subtask:

```text
Acquire Engineering Access
```

### Objective 3

```text
Reach Engineering
```

### Objective 4

```text
Activate Auxiliary Power
```

### Objective 5

```text
Return to Communications
```

### Objective 6

```text
Transmit Distress Signal
```

### Objective 7

```text
Reach Extraction
```

---

# 66. Objective Dependencies

Objectives should support simple prerequisites.

Example:

```text
Acquire Engineering Access
        ↓
Reach Engineering
        ↓
Restore Power
```

Do not require a sophisticated graph framework.

A sequential mission with optional sub-objectives is enough.

---

# 67. Mission Events

Level reacts to mission progression through signals.

Example:

```text
power objective completed
        ↓
station script activates encounter
```

But avoid placing generic mission logic inside the station script where reusable components can handle it.

---

# 68. Mission HUD

HUD gains objective display.

Example:

```text
OBJECTIVE

Restore Facility Power

Engineering access required
```

When updated:

```text
OBJECTIVE UPDATED
```

brief notification.

---

# 69. Objective Completion Feedback

On completion:

```text
✓ ENGINEERING ACCESS ACQUIRED
```

or:

```text
✓ AUXILIARY POWER ONLINE
```

display for approximately:

```text
2 seconds
```

Then transition to next objective.

---

# 70. Pickups

Phase 2 supports:

* ammunition;
* health;
* access credentials.

Potential armour pickup may be included only if Phase 1 already supports armour.

Do not build grid inventory.

---

# 71. Health Pickup

Simple:

```text
MEDKIT
```

heals:

```text
25–40 health
```

Cannot increase above maximum.

If player is full health, decide between:

### Option A

Do not collect.

### Option B

Collect anyway.

Recommendation:

**Do not collect when full.**

Communicate:

```text
HEALTH FULL
```

---

# 72. Ammo Scarcity

Station Blackout should deliberately limit ammunition.

The player should have enough ammunition to complete the mission without perfect play.

But indiscriminate firing should create pressure.

Target:

```text
available ammunition ≈ 1.5–2× expected combat requirement
```

during initial tuning.

Later difficulty levels can modify this.

---

# 73. Optional Second Weapon

Phase 2 may introduce:

```text
Shotgun
```

only if time permits.

The shotgun is particularly useful because the noise system makes it mechanically different.

Potential values:

```text
high close-range damage
wide spread
slow fire rate
limited ammunition
very high noise radius
```

This creates:

```text
powerful now
+
dangerous later
```

which strongly reinforces the game's identity.

---

# 74. Shotgun Priority

Shotgun is:

```text
SHOULD
```

not:

```text
MUST
```

for Phase 2.

Do not jeopardise the vertical slice merely to add another weapon.

---

# 75. Environmental Audio

Phase 2 needs atmospheric audio.

Sources:

* ventilation;
* electrical hum;
* machinery;
* alarms;
* distant creature sounds;
* door motors;
* power generator.

Use:

```text
AudioStreamPlayer2D
```

for spatial sources where appropriate.

---

# 76. Audio Zones

Different facility areas should feel distinct.

Examples:

### Reception

quiet emergency ambience.

### Laboratories

electrical noise and intermittent machinery.

### Engineering

generator hum.

### Post-power

additional machinery loops.

Do not build a generic audio middleware system.

Godot audio buses and local players are sufficient.

---

# 77. Ambient Enemy Audio

Occasional alien sounds outside the player's view can create tension.

Important:

Audio should not always indicate an actual immediate enemy position.

Some ambience can simply imply activity elsewhere.

---

# 78. Environmental Storytelling

Station Blackout should communicate what happened without requiring extensive dialogue.

Examples:

* blood trails;
* damaged door;
* abandoned medical kit;
* dead technician near credential;
* broken containment;
* damaged terminals;
* overturned furniture;
* emergency messages.

Avoid writing lengthy lore terminals for the vertical slice.

---

# 79. Minimal Narrative Text

Keep terminal text short.

Example:

```text
C-12 AUXILIARY POWER

MAIN GRID: OFFLINE
EMERGENCY GRID: 38%

MANUAL START REQUIRED
ENGINEERING LEVEL 2
```

This conveys both story and mechanics.

---

# 80. Checkpoint System

Phase 2 introduces simple mission checkpoints.

This is not yet full save-game persistence.

Checkpoint stores enough runtime information to restart the mission from a meaningful point.

---

# 81. Minimum Checkpoint State

Checkpoint should record:

```text
player position
player health
weapon ammunition
access credentials
completed objectives
power state
important door states
important encounter states
```

Potentially:

```text
alive/dead persistent enemies
```

but this can become complicated.

---

# 82. Recommended Phase 2 Checkpoint Strategy

Use a small number of explicit checkpoint snapshots.

Suggested:

### Checkpoint 0

Mission start.

### Checkpoint 1

Engineering access obtained.

### Checkpoint 2

Power restored.

### Checkpoint 3

Distress signal transmitted.

This reduces complexity.

---

# 83. Checkpoint Architecture

Do not serialize the entire Godot scene tree.

Instead save explicit gameplay state.

Example:

```text
CheckpointState
├── checkpoint_id
├── player_state
├── mission_state
├── access_state
├── power_state
└── world_flags
```

This architecture can later evolve into the actual save system.

---

# 84. World Flags

Simple flags:

```text
engineering_card_collected
auxiliary_power_online
communications_transmitted
security_door_unlocked
incubator_event_triggered
```

Do not attempt generic serialization of every node.

Explicit state is easier to reason about.

---

# 85. Death Flow

Player death:

```text
YOU DIED
```

Options:

```text
Restart Checkpoint
Restart Mission
Quit
```

Checkpoint restart should take only a few seconds.

Fast retry matters.

---

# 86. Mobile Prototype

Phase 2 must test mobile controls.

Do not defer touchscreen controls until the end of development.

The objective is not final mobile UX.

The objective is proving the gameplay translates to touch.

---

# 87. Mobile Orientation

Landscape only.

Suggested layout:

```text
┌────────────────────────────────────────────┐
│ objective                                  │
│                                            │
│                                            │
│                 GAME                       │
│                                            │
│                                            │
│    MOVE                          AIM/FIRE   │
│     ◯                              ◯        │
│                                      [USE] │
│                                  [RELOAD]  │
└────────────────────────────────────────────┘
```

---

# 88. Virtual Movement Stick

Left side controls movement.

Requirements:

* analogue magnitude;
* configurable dead zone;
* touch origin may optionally float;
* visual opacity low enough not to obscure world.

---

# 89. Virtual Aim Stick

Right side controls:

```text
aim
+
fire
```

Recommended behaviour:

```text
touch right zone
        ↓
drag
        ↓
aim
        ↓
stick exceeds fire threshold
        ↓
fire
```

This avoids requiring a separate permanent fire button.

---

# 90. Mobile Aim Behaviour

When aim stick is released:

```text
retain last aim direction
```

consistent with controller behaviour.

---

# 91. Mobile Interaction

Dedicated:

```text
USE
```

button.

Contextual interaction prompt remains visible.

Potential future behaviour:

* automatic door interaction;
* tap contextual interaction.

Do not optimise this prematurely.

---

# 92. Mobile Reload

Dedicated:

```text
RELOAD
```

button initially.

Auto-reload can later become a setting.

---

# 93. Mobile Acceptance Device

Phase 2 must be installed and played on at least one real Android device.

Emulator-only testing is insufficient.

Test:

* touch accuracy;
* aspect ratio;
* UI safe areas;
* performance;
* temperature over a 15-minute session.

iOS may remain export-validation-only until later if Apple hardware availability is limited.

---

# 94. Mobile Performance Goal

Normal vertical-slice gameplay:

```text
60 FPS target
```

If hardware cannot maintain that:

identify whether bottleneck is:

* lighting;
* particles;
* navigation;
* enemy count;
* shaders;
* overdraw.

Do not simply lower the whole game to 30 FPS without investigation.

---

# 95. Enemy Count

Typical Station Blackout encounter:

```text
2–6 active enemies
```

Climactic extraction:

```text
8–15 active enemies
```

Potential background enemies:

additional inactive or distant actors.

Phase 1 already proved higher raw counts.

Phase 2 tests systemic complexity rather than maximum quantity.

---

# 96. Encounter Design

Station Blackout should contain approximately:

### Encounter 1

1–2 enemies.

Purpose:

reintroduce combat.

### Encounter 2

noise demonstration.

1 visible enemy + hidden nearby enemies.

### Encounter 3

dark laboratory encounter.

### Encounter 4

post-power activated enemies.

### Encounter 5

communications/alarm escape.

---

# 97. Encounter 1 — Familiarisation

Near reception.

Player sees enemy before it sees player.

Purpose:

* confirm movement;
* confirm aiming;
* confirm firing.

No major complexity.

---

# 98. Encounter 2 — Noise Lesson

Player sees:

```text
1 Drone
```

Nearby unseen room contains:

```text
2–3 Drones
```

If player fires pulse rifle:

nearby enemies investigate.

If player moves around or avoids the enemy:

may avoid larger encounter.

This demonstrates player agency.

---

# 99. Encounter 3 — Darkness

Research laboratory.

Lighting limited.

Enemy movement heard before seen.

Player flashlight provides information.

This validates:

```text
lighting
+
audio
+
combat
```

together.

---

# 100. Encounter 4 — Power Restoration

Power comes online.

An incubator or containment unit activates.

Enemies previously inactive become active.

The environment visibly changes.

This should be a memorable moment.

---

# 101. Encounter 5 — Extraction

After communication:

```text
ALARM
```

Player objective changes:

```text
REACH EXTRACTION
```

Enemies enter from multiple directions.

The player should preferably move rather than stand and clear an arena.

Design pressure toward:

```text
run
shoot selectively
manage reloads
```

---

# 102. Extraction

Extraction zone can be:

* airlock;
* shuttle bay;
* elevator.

Player reaches area and interacts.

Mission ends.

Display:

```text
MISSION COMPLETE

C-12 DISTRESS SIGNAL TRANSMITTED
```

Optional stats:

```text
Time
Enemies killed
Shots fired
Damage taken
```

Stats are nice but not required.

---

# 103. Mission Completion

After completion:

```text
MissionCompleteScreen
```

Buttons:

```text
Replay
Return to Bootstrap/Menu
```

No campaign progression yet.

---

# 104. UI Expansion

Phase 2 HUD should contain:

```text
Health
Ammo
Current Objective
Interaction Prompt
Access Notification
Damage Feedback
```

Optional:

```text
flashlight indicator
```

No minimap required.

---

# 105. No Minimap Yet

A minimap can reduce tension by revealing level structure.

Phase 2 should first test navigation without it.

Use:

* clear room shapes;
* signage;
* lighting;
* environmental landmarks.

Add a minimap only if playtesting shows persistent confusion.

---

# 106. Signage

Environmental signage can guide player:

```text
COMMUNICATIONS →
ENGINEERING ↓
SECURITY ←
```

This is preferable to a permanent navigation arrow.

---

# 107. Objective Markers

Avoid glowing arrows through walls.

If objective markers are required:

* keep subtle;
* potentially display only when player requests guidance.

Phase 2 should determine whether environmental navigation is sufficient.

---

# 108. Lighting Performance

Lighting must be profiled on desktop and mobile.

Avoid placing hundreds of dynamic lights.

Prefer:

* selective gameplay lights;
* baked/static-looking sprite illumination where appropriate;
* dynamic lights for important sources.

---

# 109. Navigation Performance

Navigation targets should not be recalculated unnecessarily every rendered frame.

Enemy should update targets at a practical interval or when needed.

Example:

```text
0.1–0.25 second
```

target refresh may be sufficient for normal enemies.

Profile before optimising further.

---

# 110. Noise Performance

Avoid:

```text
every enemy checking every sound every frame
```

Noise events occur discretely.

Architecture should be:

```text
noise occurs
    ↓
listeners in relevant area evaluated
    ↓
event expires
```

Noise is an event, not a persistent frame-by-frame simulation.

---

# 111. Noise Debug Visualization

Add development visualisation.

When noise occurs, optionally draw:

```text
circle centred on noise source
```

with radius.

Example debug:

```text
        .----------------.
     .'                    '.
    /                        \
   |            X             |
    \                        /
     '.                    .'
        '----------------'
```

X = noise source.

This will make tuning dramatically easier.

---

# 112. Perception Debugging

Debug overlay should optionally show:

* enemy state;
* current navigation target;
* last heard position;
* vision range;
* noise radius;
* current target.

Example:

```text
Drone #12
STATE: INVESTIGATE
TARGET: (422, 288)
HEARD: rifle
```

Do not expose this in production builds.

---

# 113. Power Debugging

Optional debug overlay:

```text
POWER

Emergency: ON
Main: OFF
Communications: OFF
Engineering: ON
```

This will make system debugging significantly easier.

---

# 114. Mission Debugging

Development keys can allow:

```text
skip objective
restore power
give engineering access
trigger alarm
teleport to checkpoint
```

These tools save enormous testing time.

They must be development-only.

---

# 115. Suggested Debug Controls

Example:

```text
F1  Toggle debug overlay
F2  Give Engineering Access
F3  Toggle Main Power
F4  Emit test noise
F5  Trigger alarm
F6  Complete current objective
F7  Reload checkpoint
```

Exact key assignments may differ from Phase 1.

---

# 116. Testing Strategy

Phase 2 introduces substantially more deterministic domain logic.

Automated tests should focus on:

* door states;
* access;
* power;
* objective progression;
* noise detection;
* enemy state transitions;
* checkpoints.

Do not try to automate whether a dark corridor feels frightening.

---

# 117. Door Tests

Test:

```text
unlocked powered door opens
```

```text
locked door rejects interaction
```

```text
credential permits access
```

```text
unpowered door does not open
```

```text
door state signals emitted once
```

---

# 118. Access Tests

Test:

```text
credential initially absent
```

```text
adding credential grants access
```

```text
duplicate credential does not create invalid state
```

```text
wrong credential does not grant access
```

---

# 119. Power Tests

Test:

```text
consumer off when circuit unpowered
```

```text
consumer activates when power enabled
```

```text
consumer receives transition once
```

```text
restored checkpoint correctly restores power state
```

---

# 120. Noise Tests

Test:

```text
enemy inside radius hears event
```

```text
enemy outside radius does not
```

```text
hearing sensitivity modifies effective radius
```

```text
noise position preserved
```

```text
enemy transitions to investigate
```

---

# 121. Mission Tests

Test:

```text
objective activates correctly
```

```text
objective cannot complete before active
```

```text
completion activates next objective
```

```text
mission completes after final objective
```

```text
checkpoint restores active objective
```

---

# 122. Checkpoint Tests

Test:

```text
player health restored
```

```text
ammo restored
```

```text
credentials restored
```

```text
power restored
```

```text
objective progress restored
```

```text
world flags restored
```

---

# 123. Integration Test — Door Access

Scenario:

```text
player has no engineering access
        ↓
interact with engineering door
        ↓
door remains locked
        ↓
give credential
        ↓
interact
        ↓
door opens
```

---

# 124. Integration Test — Power

Scenario:

```text
main power off
        ↓
communications unavailable
        ↓
restore auxiliary power
        ↓
communications becomes available
```

---

# 125. Integration Test — Noise

Scenario:

```text
Drone idle in adjacent room
        ↓
player fires
        ↓
noise event emitted
        ↓
Drone receives noise
        ↓
state becomes INVESTIGATE
```

This is one of the most valuable Phase 2 automated tests.

---

# 126. Vertical Slice Smoke Test

Automated smoke test:

```text
load station_blackout.tscn
```

Verify important nodes exist:

```text
PlayerSpawn
Mission
PowerGrid
NavigationRegion
Extraction
```

Avoid brittle tests relying on exact full node paths where unnecessary.

---

# 127. Performance Acceptance

Desktop:

```text
60 FPS minimum
```

during normal encounters.

Stress:

```text
20 active navigation enemies
+
dynamic lights
+
weapon projectiles
+
noise events
```

should remain comfortably playable.

---

# 128. Mobile Acceptance

Real Android device:

```text
60 FPS target
```

during normal mission gameplay.

Touch controls must permit:

* movement;
* aiming;
* shooting;
* reload;
* interaction;
* pause.

Completing the entire mission on phone must be possible.

---

# 129. Memory Acceptance

Monitor memory through repeated:

```text
mission start
death
checkpoint reload
mission restart
```

Memory must not continually increase due to:

* abandoned enemies;
* signal connections;
* projectiles;
* audio players;
* checkpoint references.

---

# 130. Scene Lifetime Review

Pay particular attention to stale signal connections.

Use Godot object lifecycle naturally.

Avoid global services retaining references to freed level nodes.

This is especially important for:

```text
NoiseSystem
Mission
PowerGrid
```

if any of them become autoloads.

---

# 131. Autoload Decision

Prefer keeping level-specific systems inside the level scene.

Likely:

```text
MissionController
PowerGrid
```

should be level-local.

A truly global:

```text
GameState
```

or:

```text
Settings
```

may eventually become an autoload.

Do not make NoiseSystem global unless sounds genuinely need to cross scene boundaries.

---

# 132. Save Architecture Boundary

Checkpoint state should be designed so Phase 3 can persist it.

However:

Phase 2 does not need actual disk persistence.

Keep checkpoint state in memory.

Phase 3 can later serialize the same state structure.

---

# 133. Analytics During Playtesting

Do not build telemetry backend.

For playtesting, record manually or through debug logging:

```text
mission completion time
deaths
ammo remaining
damage taken
objective confusion
number of enemies alerted by noise
```

These are useful for tuning.

---

# 134. Vertical Slice Playtest Questions

Ask testers:

### Navigation

Did you know where to go?

### Objective

Did you understand why communications did not work?

### Access

Did you understand why the engineering door was locked?

### Power

Did restoring power feel meaningful?

### Noise

Did you realise gunfire attracted enemies?

### Darkness

Did lighting increase tension without becoming annoying?

### Combat

Did combat still feel good outside the arena?

### Extraction

Did the final escape feel exciting?

---

# 135. Critical Noise Question

Ask directly after play:

> Did you notice that firing attracted additional aliens?

If the answer is consistently:

```text
No
```

the system exists technically but has failed as a design mechanic.

Improve feedback.

---

# 136. Noise Feedback

Possible feedback:

* distant alien vocalisation after gunshot;
* movement sounds approaching;
* subtle motion detector later;
* visible enemy entering room;
* environmental audio response.

Avoid explicit UI:

```text
YOU ALERTED 3 ENEMIES
```

unless necessary.

The player should learn through the world.

---

# 137. Power Feedback

Restoring power must have significant feedback:

```text
generator rumble
+
lights
+
screen/display activation
+
door indicators
+
ambient machinery
+
enemy event
```

If the player presses a terminal and only a text value changes, the moment has failed.

---

# 138. Access Feedback

Obtaining access credential should feel useful immediately.

Ideally the player has previously encountered:

```text
ENGINEERING ACCESS REQUIRED
```

Then later obtains:

```text
ENGINEERING ACCESS ACQUIRED
```

This creates:

```text
problem
→ solution
```

rather than collecting arbitrary keys.

---

# 139. Level Design Rule — Show Before Require

Prefer:

```text
player sees locked engineering door
```

before:

```text
player finds engineering credential
```

Likewise:

```text
player sees communications offline
```

before:

```text
player is asked to restore power
```

This gives objectives context.

---

# 140. Level Design Rule — Shortcuts

Restoring power or unlocking security should create at least one shortcut.

Example:

```text
long outbound route

SECURITY → LABS → STORAGE → ENGINEERING
```

after power:

```text
ENGINEERING → powered shortcut → RECEPTION
```

This makes system progress spatially meaningful.

---

# 141. Level Design Rule — Avoid Key Hunts

The engineering credential should not be hidden randomly.

The environment should logically suggest:

```text
security office
engineer corpse
maintenance desk
```

Searching should feel investigative rather than arbitrary.

---

# 142. Phase 2 Asset Requirements

Minimum environment:

* floor;
* wall;
* doors;
* terminals;
* crates;
* lights;
* engineering machinery;
* incubator;
* health pickup;
* ammo pickup.

Minimum characters:

* player;
* Drone.

Optional:

* second alien;
* shotgun.

---

# 143. Asset Licensing

All imported prototype assets remain subject to Phase 0 rules:

```text
source
author
licence
download date
local path
```

must appear in:

```text
THIRD_PARTY_ASSETS.md
```

No asset enters the repository with unknown provenance.

---

# 144. Recommended Implementation Backlog

Create approximately:

```text
P2-001 Build TileMapLayer level foundation

P2-002 Create Station Blackout blockout

P2-003 Configure navigation region

P2-004 Upgrade Drone navigation

P2-005 Implement line-of-sight perception

P2-006 Implement interaction detector

P2-007 Implement interaction prompts

P2-008 Implement reusable Door

P2-009 Implement access credentials

P2-010 Implement Engineering access door

P2-011 Implement terminal scene

P2-012 Implement communications terminal

P2-013 Implement PowerGrid

P2-014 Implement powered consumers

P2-015 Implement powered lighting

P2-016 Implement player flashlight

P2-017 Implement auxiliary power sequence

P2-018 Implement NoiseEvent

P2-019 Implement NoiseSystem

P2-020 Connect weapon noise emission

P2-021 Add enemy NoiseListener

P2-022 Implement INVESTIGATE AI state

P2-023 Implement SEARCH AI state

P2-024 Add environmental door noise

P2-025 Implement mission framework

P2-026 Implement Station Blackout objectives

P2-027 Add objective HUD

P2-028 Add engineering credential pickup

P2-029 Add health pickup

P2-030 Add mission checkpoints

P2-031 Add checkpoint restart

P2-032 Add mission extraction

P2-033 Add alarm sequence

P2-034 Add extraction encounter

P2-035 Add environmental audio

P2-036 Add environmental storytelling

P2-037 Implement mobile movement control

P2-038 Implement mobile aim/fire control

P2-039 Add mobile interaction/reload controls

P2-040 Android device build

P2-041 Add perception debug overlay

P2-042 Add power/noise debug tools

P2-043 Add Phase 2 unit tests

P2-044 Add vertical-slice integration tests

P2-045 Desktop performance pass

P2-046 Mobile performance pass

P2-047 Vertical-slice playtest

P2-048 Combat/resource tuning

P2-049 Mission pacing tuning

P2-050 Phase 2 release validation
```

---

# 145. Recommended Implementation Sequence

Implementation order is important.

---

## Step 1 — Level Blockout

Before adding systems, create Station Blackout as simple geometry.

Use:

* floor;
* walls;
* rooms;
* corridors.

Play it with the Phase 1 player.

Evaluate:

```text
movement
room scale
camera
corridor width
```

---

# 146. Step 2 — Navigation

Configure:

```text
NavigationRegion2D
```

Upgrade Drone to navigate around the facility.

Do not proceed until enemies can move reliably between rooms.

---

# 147. Step 3 — Interaction

Implement generic interaction.

Test with one simple debug object:

```text
[E] Interact
```

The object changes colour or prints a message.

Do not implement doors until the interaction foundation works.

---

# 148. Step 4 — Door

Implement basic:

```text
closed
open
```

door.

Then add:

```text
locked
```

Then:

```text
unpowered
```

Build incrementally.

---

# 149. Step 5 — Access

Implement:

```text
engineering credential
```

Test full loop:

```text
locked door
→ credential
→ open door
```

---

# 150. Step 6 — Terminal

Implement reusable terminal interaction.

Create communications terminal.

At this stage:

```text
communications offline
```

can simply display text.

---

# 151. Step 7 — Power

Implement PowerGrid.

Connect:

```text
communications
doors
lights
```

Test manually toggling power.

---

# 152. Step 8 — Lighting

Create:

```text
emergency
normal
flashlight
```

visual states.

Do not over-polish lighting yet.

Verify readability.

---

# 153. Step 9 — Power Restoration Sequence

Turn engineering control into complete environmental moment.

This is the first major vertical-slice polish target.

---

# 154. Step 10 — Noise Event

Create NoiseEvent and emit from pulse rifle.

Debug draw radius.

Do not change enemy behaviour yet.

Verify event data first.

---

# 155. Step 11 — Enemy Hearing

Add NoiseListener.

Test:

```text
fire
→ enemy receives noise
```

Use debug labels.

---

# 156. Step 12 — INVESTIGATE

Enemy navigates to sound source.

Now the noise mechanic becomes visible.

---

# 157. Step 13 — SEARCH

Add short search after reaching sound position.

Do not overcomplicate.

---

# 158. Step 14 — Vision

Add line-of-sight restrictions.

Now enemies can:

```text
hear player
```

without:

```text
magically seeing player
```

through walls.

---

# 159. Step 15 — Mission Framework

Implement mission/objective lifecycle.

Use simple development objectives before integrating full Station Blackout chain.

---

# 160. Step 16 — Connect Mission

Build complete sequence:

```text
communications
→ access
→ engineering
→ power
→ communications
→ extraction
```

At this point, the mission must be completable with placeholder art.

---

# 161. Step 17 — Checkpoints

Once mission flow is stable, add checkpoints.

Do not build checkpoints while the objective sequence is still changing daily.

---

# 162. Step 18 — Final Encounter

Add communications alarm and extraction pressure.

Do not create a conventional arena wave unless testing shows it works.

Prefer moving escape.

---

# 163. Step 19 — Environmental Audio

Add:

* ambience;
* doors;
* generator;
* alarms;
* machinery;
* alien sounds.

This will significantly increase perceived quality.

---

# 164. Step 20 — Mobile Controls

Add touchscreen controls once desktop mission is fully playable.

Do not wait until Beta.

Complete mission on actual phone.

---

# 165. Step 21 — Playtest

Give build to someone unfamiliar with the level.

Do not explain:

```text
where engineering is
what the card does
how power works
```

Observe.

Confusion is valuable data.

---

# 166. Step 22 — Tune

Tune:

```text
enemy placement
ammo placement
objective wording
lighting
door locations
noise radius
mission pacing
checkpoint positions
```

Do not add features to solve problems that level design can solve.

---

# 167. Suggested Branch Sequence

Examples:

```text
feature/station-blackout-blockout

feature/enemy-navigation

feature/interaction-system

feature/door-system

feature/access-system

feature/power-grid

feature/noise-perception

feature/mission-objectives

feature/checkpoints

feature/mobile-controls

feature/station-blackout-polish
```

Avoid one giant Phase 2 branch.

---

# 168. Architecture Gate

Before Phase 2 closes, verify:

### Doors

Can another door be added through scene configuration?

### Access

Can another credential type be added without player-code changes?

### Power

Can another light/terminal become power-dependent through composition?

### Noise

Can another weapon emit noise by configuration?

### Objectives

Can another objective be created without rewriting Mission?

### Enemies

Can a different enemy react differently to sound?

If not, refactor before content production begins.

---

# 169. Definition of Done — Level

* [ ] Station Blackout complete.
* [ ] Level uses intended TileMapLayer structure.
* [ ] Rooms and corridors are visually readable.
* [ ] Navigation works between major areas.
* [ ] At least one shortcut exists.
* [ ] Player can complete full mission without editor manipulation.

---

# 170. Definition of Done — Interaction

* [ ] Generic interaction detector works.
* [ ] Prompt works.
* [ ] Keyboard input works.
* [ ] Controller input works.
* [ ] Mobile interaction button works.
* [ ] Doors use common interaction mechanism.
* [ ] Terminals use common interaction mechanism.

---

# 171. Definition of Done — Doors and Access

* [ ] Door opens/closes.
* [ ] Door collision works.
* [ ] Powered state works.
* [ ] Locked state works.
* [ ] Engineering credential works.
* [ ] Access denied feedback exists.
* [ ] Unpowered feedback exists.
* [ ] Door audio exists.

---

# 172. Definition of Done — Power

* [ ] PowerGrid exists.
* [ ] Main power starts offline.
* [ ] Emergency lighting works.
* [ ] Auxiliary power can be restored.
* [ ] Lighting reacts.
* [ ] Communications reacts.
* [ ] selected doors react.
* [ ] machinery reacts.
* [ ] power state restores from checkpoint.

---

# 173. Definition of Done — Noise

* [ ] Pulse rifle emits noise.
* [ ] noise radius configurable.
* [ ] enemy listener works.
* [ ] enemy inside range reacts.
* [ ] enemy outside range ignores event.
* [ ] INVESTIGATE state works.
* [ ] SEARCH state works.
* [ ] line-of-sight detection works.
* [ ] noise debug visualisation works.
* [ ] alarm noise works.

---

# 174. Definition of Done — Missions

* [ ] MissionDefinition exists.
* [ ] Objective base exists.
* [ ] sequential objectives work.
* [ ] objective HUD works.
* [ ] engineering credential objective works.
* [ ] restore power objective works.
* [ ] communication objective works.
* [ ] extraction objective works.
* [ ] mission-complete state works.

---

# 175. Definition of Done — Checkpoints

* [ ] mission-start checkpoint works.
* [ ] engineering checkpoint works.
* [ ] power-restored checkpoint works.
* [ ] communications checkpoint works.
* [ ] health restores.
* [ ] ammunition restores.
* [ ] access restores.
* [ ] objectives restore.
* [ ] power restores.
* [ ] world flags restore.

---

# 176. Definition of Done — Mobile

* [ ] landscape layout works.
* [ ] virtual movement works.
* [ ] virtual aim works.
* [ ] touch firing works.
* [ ] reload works.
* [ ] interaction works.
* [ ] pause works.
* [ ] mission completable on Android.
* [ ] safe-area issues reviewed.
* [ ] performance measured on real device.

---

# 177. Definition of Done — Quality

* [ ] unit tests pass.
* [ ] integration tests pass.
* [ ] CI passes.
* [ ] no repeated errors.
* [ ] no known blocker bugs.
* [ ] desktop mission maintains target performance.
* [ ] mobile performance measured.
* [ ] all third-party assets documented.
* [ ] mission has been blind-playtested.

---

# 178. Phase 2 Acceptance Scenario

A tester must be able to:

```text
Launch Station Blackout

↓
Enter facility

↓
Fight first Drone

↓
Reach Communications

↓
Discover power failure

↓
Find Engineering access credential

↓
Open Engineering door

↓
Navigate dark research area

↓
Fire weapon

↓
Attract nearby enemies

↓
Reach Engineering

↓
Restore auxiliary power

↓
Observe facility transformation

↓
Return through changed environment

↓
Reach Communications

↓
Transmit distress signal

↓
Trigger alarm

↓
Survive / evade enemy response

↓
Reach extraction

↓
MISSION COMPLETE
```

No developer intervention.

---

# 179. Phase 2 Subjective Acceptance

The build must also pass subjective evaluation.

A tester should experience at least one moment resembling:

> "I fired at one alien and suddenly heard more of them coming."

and:

> "Turning the power back on changed the station."

and:

> "I knew I needed to get out rather than kill everything."

Those reactions are more important than architectural elegance.

---

# 180. Vertical Slice Design Gate

Before starting Phase 3, answer:

### Exploration

Is navigating the facility enjoyable?

### Combat

Does combat remain enjoyable in corridors and rooms?

### Noise

Does firing create meaningful consequences?

### Lighting

Does darkness change how the player behaves?

### Power

Does changing facility state feel meaningful?

### Objectives

Can players understand what they need to do without excessive instructions?

### Resource Pressure

Does ammunition influence decisions?

### Mobile

Does twin-stick gameplay remain viable on touch?

### Architecture

Can additional missions be constructed from these systems?

---

# 181. GO / CHANGE / STOP Decision

At the end of Phase 2 make a deliberate decision.

## GO

Proceed to production.

Conditions:

* combat enjoyable;
* exploration enjoyable;
* noise mechanic works;
* environment systems add value;
* mission has clear identity.

---

## CHANGE

Repeat part of vertical slice.

Examples:

* combat good but exploration boring;
* noise mechanic unclear;
* mobile controls poor;
* objectives confusing;
* lighting frustrating.

Fix the core problem before producing campaign content.

---

## STOP

Do not proceed if the core combination is fundamentally not enjoyable.

It is much cheaper to stop or redesign after one mission than after eight.

---

# 182. Phase 2 Release

Version:

```text
0.2.0
```

Tag:

```text
v0.2.0
```

Suggested release description:

```text
Hull Breach v0.2.0 — Vertical Slice

First complete representative mission.

Includes:

- Station Blackout mission
- tile-based sci-fi environment
- enemy navigation
- reusable interaction system
- powered and access-controlled doors
- engineering credentials
- terminals
- facility power system
- emergency and normal lighting
- player flashlight
- noise events
- enemy hearing
- investigate/search AI
- mission objective framework
- mission HUD
- health and ammunition pickups
- mission checkpoints
- communications alarm
- extraction sequence
- Android touch-control prototype
- desktop and mobile performance validation

This milestone represents the first playable slice of the intended final Hull Breach experience.
```

---

# 183. First Work After Phase 2

Do **not** immediately begin building eight missions.

Phase 3 should first take what Phase 2 taught us and harden the systems for production.

The first Phase 3 tasks should likely be:

```text
review Phase 2 technical debt
        ↓
extract reusable level components
        ↓
stabilise save-state model
        ↓
add second weapon
        ↓
add second/third enemy behaviour
        ↓
create production level-authoring workflow
        ↓
build second mission using only reusable systems
```

The best test of the Phase 2 architecture is:

> Can we build Mission 2 substantially faster than Station Blackout?

If the answer is no, Phase 3 needs to simplify the authoring architecture before large-scale content production.

---

# 184. Phase 2 Core Principle

Phase 1 proved:

> Shooting an alien is enjoyable.

Phase 2 must prove:

> Choosing whether to shoot an alien is interesting.

That distinction should define Hull Breach.

A successful vertical slice is not one with the most systems.

It is one where:

```text
dark corridor
+
limited ammunition
+
locked door
+
nearby unseen enemies
+
gunshot noise
+
objective pressure
```

combine to produce a decision the player actually cares about.

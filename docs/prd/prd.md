# Product Requirements Document — Project: Hull Breach

**Document Status:** Initial Product Definition
**Working Title:** Project: Hull Breach
**Genre:** Top-down sci-fi survival action shooter
**Primary Engine:** Godot
**Primary Language:** GDScript
**Initial Target Platforms:** Windows, macOS, Linux, Android, iOS
**Secondary Targets:** Steam Deck and conventional game controllers
**Game Mode:** Single-player
**Camera:** Fixed top-down / slightly elevated top-down 2D
**Business Model:** Premium game; no advertising or mandatory online services
**Current engine baseline:** Godot 4.7.x, initially pinned to Godot 4.7.2.

Godot 4.7.2 is the current stable maintenance release as of August 2026. The project will pin the exact engine version rather than automatically adopting each new Godot release.

---

# 1. Product Vision

Project: Hull Breach is a modern spiritual successor to classic top-down sci-fi action games such as *Alien Breed*.

The player explores damaged spacecraft, research stations, mining facilities and colonies that have been overrun by hostile organisms.

Gameplay combines:

* fast twin-stick combat;
* deliberate exploration;
* constrained ammunition and health;
* locked doors and access systems;
* environmental hazards;
* darkness and unreliable power;
* enemies attracted by sound;
* escalating enemy pressure;
* objectives requiring the player to move through previously explored areas;
* short but highly replayable missions.

The game should produce a constant tension between:

> **move quickly, conserve resources, or fight.**

Shooting is effective but has consequences.

Exploration provides resources but consumes time.

Restoring power improves visibility but may activate machinery — or enemies.

The player's biggest weapon should ultimately be understanding the environment rather than simply having the highest DPS.

---

# 2. Product Positioning

The game should feel recognisably inspired by early top-down sci-fi shooters while playing like a modern twin-stick survival/action game.

The desired mixture is approximately:

**Alien Breed**
+
**twin-stick shooter**
+
**survival horror tension**
+
**environmental systems**
+
**modern dynamic lighting and audio**

The objective is not to recreate an Amiga game pixel-for-pixel.

The project must **not** reuse:

* the *Alien Breed* name;
* original maps;
* original sprites;
* original sound;
* original music;
* original characters;
* distinctive text or story material;
* original logos or UI assets.

All game-specific IP will be original.

---

# 3. Core Design Pillars

## 3.1 Claustrophobic exploration

Levels primarily consist of:

* corridors;
* laboratories;
* storage rooms;
* engineering areas;
* habitation areas;
* maintenance tunnels;
* hangars;
* reactor rooms;
* medical areas;
* security areas.

The environment should frequently limit sight lines and create uncertainty about what is around the next corner.

---

## 3.2 Combat with consequences

The player should be powerful enough that combat feels satisfying.

However, firing a weapon produces:

* ammunition consumption;
* noise;
* muzzle flash;
* enemy attraction;
* potential environmental damage.

The optimal strategy must not always be:

> kill everything immediately.

---

## 3.3 Darkness matters

Lighting is both visual presentation and gameplay.

Possible states include:

* normal station lighting;
* reduced lighting;
* emergency lighting;
* complete power failure;
* intermittent lighting;
* local flashlight illumination.

Enemy behaviour can vary depending on lighting.

For example:

| Enemy   | Behaviour                             |
| ------- | ------------------------------------- |
| Drone   | Ignores lighting                      |
| Hunter  | Prefers darkness                      |
| Stalker | Retreats from strong light            |
| Swarm   | Attracted to noise                    |
| Spitter | Attacks from illuminated distance     |
| Brute   | Ignores most environmental conditions |

---

## 3.4 Sound is part of the simulation

Important player actions generate a `NoiseEvent`.

Examples:

| Event                   | Example Radius |
| ----------------------- | -------------: |
| walking                 |            2 m |
| sprinting               |            5 m |
| opening mechanical door |            7 m |
| suppressed weapon       |            8 m |
| pistol                  |           12 m |
| pulse rifle             |           16 m |
| shotgun                 |           22 m |
| explosion               |           35 m |
| alarm                   |  map-dependent |

Nearby enemies may:

1. hear the noise;
2. investigate its origin;
3. discover the player;
4. alert additional enemies.

Noise should create emergent encounters.

---

# 4. Target Audience

Primary audience:

* fans of retro sci-fi games;
* twin-stick shooter players;
* survival/action players;
* Steam Deck users;
* players wanting 10–30 minute gameplay sessions;
* mobile players wanting a substantial premium game rather than a microtransaction-driven experience.

Recommended rating target:

**Teen / equivalent moderate violence rating.**

Gore should initially be configurable rather than fundamental to gameplay.

---

# 5. Supported Platforms

## Release Tier 1

* Windows
* Linux
* macOS

## Release Tier 2

* Android
* iOS

Desktop should be the primary development environment because iteration and debugging are faster.

Mobile must nevertheless be considered from the beginning, particularly:

* UI scale;
* screen aspect ratios;
* memory use;
* touch input;
* enemy counts;
* shader complexity;
* particle counts.

---

# 6. Engine and Technology

## 6.1 Engine

**Godot 4.7.x**

Initial development version:

**Godot 4.7.2 Standard**

Do not use the .NET version initially.

The project will use:

**GDScript**

rather than C#.

This avoids the additional mobile complications associated with Godot's C# export path; Godot's documentation continues to describe Android and iOS C# support as experimental.

---

# 7. Rendering

Initial renderer:

**Compatibility renderer**

Reasons:

* game is fundamentally 2D;
* widest desktop/mobile GPU compatibility;
* excellent performance for 2D;
* no requirement for compute shaders;
* reduced risk on older Android hardware.

Godot itself recommends Compatibility as an appropriate starting point for 2D projects and projects targeting older mobile or desktop hardware.

The architecture must not prevent later experimentation with the Mobile renderer.

Any shader introduced into the project must therefore have either:

* verified Compatibility support; or
* a fallback implementation.

---

# 8. Display Model

Logical design resolution:

**640 × 360**

Target aspect ratio:

**16:9**

Supported aspect ratios should include:

* 16:9
* 16:10
* 18:9
* 19.5:9
* 20:9
* ultrawide desktop displays where practical.

The play area should expand rather than simply stretching sprites.

UI must obey safe-area constraints on phones.

Pixel assets should use nearest-neighbour filtering unless the final visual style changes.

---

# 9. Control Model

The core controls are deliberately based around:

**MOVE + AIM**

rather than movement direction automatically determining shooting direction.

## Desktop

| Input       | Action         |
| ----------- | -------------- |
| WASD        | Move           |
| Mouse       | Aim            |
| Left Mouse  | Fire           |
| Right Mouse | Secondary fire |
| R           | Reload         |
| E           | Interact       |
| Shift       | Sprint         |
| 1–5 / wheel | Select weapon  |
| Tab         | Map/objectives |
| Esc         | Pause          |

---

## Controller

| Input       | Action        |
| ----------- | ------------- |
| Left stick  | Move          |
| Right stick | Aim           |
| RT          | Fire          |
| LT          | Secondary     |
| A / Cross   | Interact      |
| X / Square  | Reload        |
| LB/RB       | Change weapon |
| Start       | Pause         |
| View/Select | Map           |

Controller functionality must work from Phase 1.

---

## Mobile

Landscape mode only.

Left side:

**virtual movement stick**

Right side:

**virtual aim stick**

The primary firing model should initially be:

> firing begins when the aim stick exceeds a configurable dead zone.

Additional buttons:

* interact;
* reload;
* weapon;
* secondary ability.

Mobile controls must support:

* repositionable virtual sticks;
* sensitivity;
* stick size;
* transparency;
* aim assist.

---

# 10. Core Gameplay Loop

The core mission loop is:

1. enter an infested facility;
2. receive primary objective;
3. explore;
4. locate required resources or access;
5. encounter enemies;
6. decide whether to evade or engage;
7. manipulate station systems;
8. complete objective;
9. survive changing conditions;
10. reach extraction.

Example mission:

> Enter Research Station C-12 and restore communications.

Sub-objectives may emerge:

> Communications power unavailable.

Therefore:

> Reach engineering.

Then:

> Generator requires replacement power cell.

Therefore:

> Search storage.

Player retrieves the cell.

Restoring power:

* turns lights on;
* unlocks some doors;
* powers elevators;
* also activates incubators.

The return journey is therefore mechanically different from the outbound journey.

This is a fundamental level-design principle.

---

# 11. Player Systems

Player will have:

* health;
* armour;
* movement speed;
* sprint stamina;
* current weapon;
* ammunition;
* inventory;
* access credentials;
* flashlight;
* optional special equipment.

Initial values should be data-driven using custom Godot `Resource` definitions.

---

# 12. Weapon System

Weapon implementation must be configuration-driven.

Example:

`WeaponDefinition`

Properties:

* identifier;
* display name;
* weapon type;
* damage;
* rate of fire;
* magazine size;
* reload time;
* projectile speed;
* projectile count;
* spread;
* recoil;
* noise radius;
* muzzle flash;
* projectile scene;
* impact effect;
* fire audio;
* reload audio.

Initial weapons:

### Sidearm

Reliable.

Low damage.

Moderate noise.

Infinite reserve ammo may be considered as a difficulty option.

### Pulse Rifle

Primary general-purpose weapon.

High fire rate.

Moderate damage.

High ammunition consumption.

### Shotgun

Exceptional close-range damage.

Very loud.

Can attract multiple enemies.

### Plasma Cutter

High damage.

Slower projectile.

Effective against armoured creatures.

### Incinerator

Short-range area control.

Useful against swarms.

Dangerous near explosive environmental objects.

---

# 13. Enemy Architecture

Enemies should use composition and shared behaviours rather than large inheritance trees.

Suggested model:

`Enemy`

plus components such as:

* HealthComponent
* MovementComponent
* PerceptionComponent
* NoiseListenerComponent
* AttackComponent
* StatusEffectComponent
* DropComponent

Enemy state machine:

`IDLE`

→ `PATROL`

→ `INVESTIGATE`

→ `CHASE`

→ `ATTACK`

→ `SEARCH`

→ `RETURN`

→ `DEAD`

Enemy navigation will use Godot's 2D navigation system rather than manually implemented tile-by-tile pathfinding initially. Godot's NavigationServer2D supports navigation regions and avoidance agents suitable for this architecture.

---

# 14. Initial Enemy Types

## Drone

Basic melee alien.

Fast.

Low health.

Common.

---

## Hunter

Fast creature.

Uses alternate routes.

Attempts to approach from side corridors.

---

## Spitter

Ranged attacker.

Attempts to maintain distance.

---

## Swarm

Small low-health organisms.

Occurs in groups.

Weak individually.

---

## Brute

Slow.

Armoured.

High health.

Can break selected doors.

---

## Stalker

Avoids strong light.

Highly dangerous in dark sections.

---

## Queen / Brood Entity

Boss or environmental objective.

Can generate additional enemies until destroyed.

---

# 15. Environment Systems

Environmental interaction is an important differentiator.

Supported systems should eventually include:

* power;
* doors;
* security;
* terminals;
* elevators;
* alarms;
* destructible objects;
* explosive barrels/tanks;
* ventilation;
* toxic gas;
* fire;
* electrical hazards;
* environmental lighting.

These systems should communicate primarily through signals/events rather than direct dependencies.

---

# 16. Doors and Access

Door states:

* open;
* closed;
* locked;
* powered off;
* jammed;
* destroyed.

Access requirements can include:

* no restriction;
* coloured access card;
* security level;
* terminal unlock;
* power;
* mission condition.

Doors must be reusable scenes.

Example:

`Door.tscn`

containing:

* animation;
* collision;
* navigation obstacle;
* interaction trigger;
* access control component;
* sound source.

---

# 17. Level Architecture

Godot's older `TileMap` node is deprecated in favour of multiple `TileMapLayer` nodes, so levels should use `TileMapLayer` from the beginning.

Recommended structure:

`Level01.tscn`

* Floor
* FloorDetail
* Walls
* WallDetail
* Collision
* Navigation
* Lighting
* Doors
* Props
* Pickups
* Enemies
* SpawnPoints
* MissionTriggers
* EnvironmentalSystems

Not every layer needs to be a TileMapLayer.

Interactive objects should generally remain reusable scenes.

---

# 18. Mission System

Mission logic must not be hard-coded directly into level scripts.

Create reusable objectives.

Examples:

* ReachAreaObjective
* InteractObjective
* CollectObjective
* DestroyObjective
* RestorePowerObjective
* SurviveObjective
* EscortObjective
* ExtractionObjective.

Mission state:

`NOT_STARTED`

`ACTIVE`

`COMPLETED`

`FAILED`

Mission objectives should emit signals allowing level elements to react.

---

# 19. Save System

Two save models:

## Profile save

Contains:

* settings;
* unlocked content;
* statistics;
* campaign progress.

## Mission checkpoint

Contains:

* current level;
* player state;
* inventory;
* objective states;
* persistent environmental state.

Desktop and mobile saves should use the same logical schema.

Save files require schema version numbers.

---

# 20. Difficulty

Initial modes:

### Explorer

Lower enemy damage.

More ammunition.

Aim assistance.

Optional objective hints.

### Standard

Designed experience.

### Survivor

Scarcer resources.

More aggressive enemies.

Reduced checkpoint availability.

Difficulty should adjust parameters rather than duplicate levels.

---

# 21. Accessibility

Minimum accessibility requirements:

* configurable controller sensitivity;
* configurable touch sensitivity;
* configurable virtual joystick size;
* screen shake slider;
* controller vibration slider;
* flashes/reduced flash option;
* subtitle support;
* colour-independent access indicators;
* UI scale;
* aim assist;
* hold/toggle sprint;
* hold/toggle aim where applicable;
* remappable keyboard/controller controls.

---

# 22. Art Direction

Initial prototype style:

**pixel-art sci-fi top-down**

Target tile scale:

**32 × 32 logical tile**

Character sprite size may exceed one tile.

The production game should use a controlled palette with:

* cool metallic station colours;
* warm danger/emergency lighting;
* bright weapon effects;
* high enemy/player silhouette contrast.

Lighting should add atmosphere without making navigation frustrating.

---

# 23. Open-Source / CC0 Art Strategy

For early development, favour **CC0 assets**.

CC0 is preferable because it reduces licence complexity and permits commercial modification.

Every external asset must nevertheless have:

* original source URL;
* author;
* licence;
* date downloaded;
* local asset path.

Record this in:

`THIRD_PARTY_ASSETS.md`

and preferably alongside each asset pack in:

`LICENSE.txt`

or:

`SOURCE.md`.

---

# 24. Recommended Prototype Assets

## 24.1 Kenney — Top-down Shooter

Recommended usage:

* initial player;
* weapons;
* furniture;
* crates;
* building components;
* NPC placeholders;
* props.

The pack contains approximately 580 files and is released under CC0. Kenney explicitly permits commercial use and states that attribution is not required.

[Kenney Top-down Shooter pack](https://kenney.nl/assets/top-down-shooter?utm_source=chatgpt.com)

Use:

`assets/third_party/kenney/top_down_shooter/`

---

## 24.2 Kenney — Sci-Fi UI

Recommended usage:

* prototype menus;
* health display;
* ammo UI;
* settings screens;
* buttons;
* panels.

The pack provides around 130 sci-fi UI assets under CC0.

[Kenney Sci-Fi UI Pack](https://kenney.nl/assets/ui-pack-sci-fi?utm_source=chatgpt.com)

---

## 24.3 Kenney — Sci-Fi RTS

Recommended usage:

* futuristic structures;
* machinery;
* map elements;
* interface decoration.

The pack is CC0 and contains approximately 120 files.

[Kenney Sci-Fi RTS Pack](https://kenney.nl/assets/sci-fi-rts?utm_source=chatgpt.com)

---

## 24.4 Ansimuz — Warped Top-Down Tech Lab

This should be one of the primary prototype level sets.

It provides a dedicated top-down sci-fi laboratory environment and is CC0.

[Warped Top-Down Tech Lab](https://opengameart.org/content/warped-top-down-tech-lab?utm_source=chatgpt.com)

Suggested path:

`assets/third_party/ansimuz/warped_tech_lab/`

---

## 24.5 Warped Top-Down Tech Lab 2

The second pack extends the environment and explicitly uses 32 × 32 tiles.

It is also CC0.

[Warped Top-Down Tech Lab 2](https://opengameart.org/content/warped-top-down-tech-lab-2?utm_source=chatgpt.com)

---

## 24.6 Warped Tech Lab Extension

Particularly valuable because it adds:

* animated doors;
* health;
* armour;
* crates;
* barrels;
* beacons;
* displays;
* wall lights;
* incubators.

This pack is also released into the public domain/CC0.

[Warped Tech Lab Extension](https://opengameart.org/content/warped-top-down-tech-lab-extension?utm_source=chatgpt.com)

This is probably the single most practically useful extension for the Hull Breach prototype.

---

## 24.7 Rawdanitsu — Sci-Fi Top-Down Tileset

Alternative environment artwork.

64 × 64 tiles.

CC0/public domain.

[Sci-Fi Top-Down Tileset](https://opengameart.org/content/top-down-tileset-1?utm_source=chatgpt.com)

Useful for experimentation, although mixing this directly with the 32 × 32 Warped pack may create visual inconsistency.

---

## 24.8 Sci-Fi RPG Tiles 48×48

Hyptosis provides a larger sci-fi tile collection under CC0.

[Space Sci-Fi RPG Tiles](https://opengameart.org/content/space-scifi-rpg-tiles-48x48?utm_source=chatgpt.com)

Use primarily as a concept/reference or selectively adapted prototype asset.

---

## 24.9 CC0 Alien Sprite Sheet

OpenGameArt user rrodi411 provides a simple four-direction alien spritesheet under CC0.

[Alien Sprite Sheet](https://opengameart.org/content/alienspritesheet?utm_source=chatgpt.com)

Good Phase 1 placeholder enemy.

---

## 24.10 Alien Boss Set

A collection of several alien boss graphics exists under CC0.

[Alien Boss Set](https://opengameart.org/content/alien-boss-set?utm_source=chatgpt.com)

Useful as concept/prototype material during later combat experimentation.

---

# 25. Art Licensing Rule

The preferred licence hierarchy is:

**CC0**

then, only if necessary:

**CC BY**

Avoid using CC BY-SA assets without explicitly reviewing whether the share-alike obligations fit the intended distribution model.

Prototype art should not automatically become final production art.

An art replacement audit occurs before Beta.

---

# 26. Technical Architecture

Recommended high-level source structure:

```text
res://
├── project.godot
│
├── assets/
│   ├── original/
│   ├── generated/
│   └── third_party/
│       ├── kenney/
│       ├── ansimuz/
│       └── opengameart/
│
├── core/
│   ├── events/
│   ├── save/
│   ├── settings/
│   ├── state/
│   └── utilities/
│
├── features/
│   ├── player/
│   ├── enemies/
│   ├── weapons/
│   ├── combat/
│   ├── interaction/
│   ├── doors/
│   ├── power/
│   ├── noise/
│   ├── missions/
│   ├── pickups/
│   └── lighting/
│
├── levels/
│   ├── shared/
│   ├── dev/
│   └── campaign/
│
├── ui/
│   ├── hud/
│   ├── menus/
│   ├── mobile/
│   └── common/
│
├── resources/
│   ├── enemies/
│   ├── weapons/
│   ├── items/
│   └── difficulty/
│
├── audio/
├── shaders/
│
├── tests/
│   ├── unit/
│   └── integration/
│
├── docs/
└── tools/
```

Prefer feature-oriented folders over an application-style global separation of every `.gd` and `.tscn` file.

For example:

```text
features/player/
├── player.gd
├── player.tscn
├── player_input.gd
├── player_state.gd
└── player_config.tres
```

This keeps related Godot resources together.

---

# 27. Architectural Rules

## Signals over direct coupling

Prefer:

```text
Weapon
   ↓ emits
weapon_fired

NoiseSystem
   ↓ reacts

EnemyPerception
```

over:

```text
Weapon
   ↓
EnemyManager.find_all_enemies()
   ↓
enemy.hear_weapon()
```

---

## Composition over inheritance

Avoid deep structures such as:

```text
Actor
→ Enemy
→ WalkingEnemy
→ MeleeEnemy
→ FastMeleeEnemy
→ ArmouredFastMeleeEnemy
```

Prefer:

```text
Enemy
+
MovementComponent
+
MeleeAttackComponent
+
ArmourComponent
+
NoiseListener
```

---

## Data-driven configuration

Weapons, enemies, pickups and difficulty parameters should use Godot Resources.

Behaviour should be code.

Tuning should primarily be data.

---

# 28. Automated Testing

Use automated tests for systems that are substantially deterministic.

Recommended framework:

**GdUnit4**

GdUnit4 supports Godot 4.x, GDScript testing, assertions, mocking and scene testing. Its current 6.2 generation supports Godot 4.7.

Candidate tests:

* damage calculations;
* armour;
* weapon configuration;
* inventory;
* access control;
* objective transitions;
* save migration;
* difficulty calculation;
* sound propagation calculations.

Do not attempt to achieve arbitrary 90–100% game-code coverage.

Tests exist to protect important behaviour, not to optimise a metric.

---

# 29. Performance Requirements

## Desktop target

1080p / 60 FPS minimum.

Recommended hardware should comfortably achieve 120 FPS where display refresh permits.

---

## Mobile target

60 FPS target.

30 FPS configurable fallback on low-end hardware.

Primary baseline:

approximately Snapdragon 845 / Apple A12 class hardware or better.

Godot lists Snapdragon 845-class Android hardware among its recommended baseline for straightforward exported projects.

---

## Initial simulation limits

Target:

* 50 simultaneously active conventional enemies;
* 100 lightweight swarm enemies where simplified behaviour is used;
* 100 active projectiles;
* 100 short-lived effects.

These values are engineering targets rather than guaranteed final design limits.

---

# 30. Phase Delivery Plan

---

# PHASE 0 PRD — Project Foundation

## Objective

Produce a reproducible development environment where a new developer can:

1. clone the repository;
2. install the documented Godot version;
3. open the project;
4. run it;
5. execute tests;
6. produce a desktop debug build.

No real gameplay is required.

---

## Phase 0 Duration

Expected:

**1–3 development days**

Do not spend weeks building architecture before gameplay exists.

---

## Phase 0 Deliverables

* Git repository;
* private GitHub repository;
* README;
* Godot project;
* engine version pin;
* `.gitignore`;
* Git LFS rules;
* source structure;
* initial project settings;
* input map;
* first test;
* CI;
* Windows debug export;
* asset licence register;
* architecture decision record;
* contribution guidelines.

---

# Phase 0.1 — Install Toolchain

Install:

**Godot 4.7.2 Standard**

not:

**Godot 4.7.2 .NET**

Verify:

```bash
godot --version
```

Expected version should contain:

```text
4.7.2
```

Godot recommends having the editor executable available on the command line; the official documentation describes packages such as Homebrew and Scoop as options for doing so.

---

# Phase 0.2 — Create Repository

Suggested repository name:

```text
hull-breach
```

Create:

```bash
mkdir hull-breach
cd hull-breach

git init -b main
```

Create Godot project in this directory.

Godot project name:

```text
Hull Breach
```

Renderer:

```text
Compatibility
```

Git metadata:

```text
Git
```

---

# Phase 0.3 — Repository Files

Initial repository:

```text
hull-breach/
├── .github/
│   ├── workflows/
│   └── pull_request_template.md
│
├── assets/
│   ├── original/
│   └── third_party/
│
├── core/
├── features/
├── levels/
│   └── dev/
├── resources/
├── tests/
├── tools/
├── ui/
├── docs/
│
├── .editorconfig
├── .gitignore
├── .gitattributes
├── .godot-version
├── CHANGELOG.md
├── CONTRIBUTING.md
├── README.md
├── THIRD_PARTY_ASSETS.md
├── project.godot
└── export_presets.cfg
```

---

# Phase 0.4 — Engine Version Pin

Create:

`.godot-version`

containing:

```text
4.7.2
```

README should state:

```text
Required Godot version: 4.7.2 Standard
```

Engine upgrades require a dedicated pull request.

Do not casually edit the project using Godot 4.8-dev.

---

# Phase 0.5 — `.gitignore`

Minimum:

```gitignore
# Godot cache/import database
.godot/

# Builds
build/
dist/
exports/

# OS
.DS_Store
Thumbs.db
Desktop.ini

# IDEs
.idea/
.vscode/

# Temporary files
*.tmp
*.log

# Local environment
.env
.env.*

# Credentials
*.keystore
*.jks
*.p12
*.mobileprovision
```

Godot keeps sensitive export credentials under `.godot/export_credentials.cfg`; the project must never commit these credentials. Godot's documentation specifically distinguishes safe-to-commit `export_presets.cfg` from confidential export credentials.

---

# Phase 0.6 — Git LFS

Use Git LFS for editable source artwork and large lossless media.

Example:

```bash
git lfs install

git lfs track "*.aseprite"
git lfs track "*.psd"
git lfs track "*.kra"
git lfs track "*.blend"
git lfs track "*.wav"
git lfs track "*.flac"
```

Do not automatically LFS-track every PNG.

Most pixel-art PNGs are small enough for normal Git.

Commit generated `.gitattributes`.

---

# Phase 0.7 — Initial Git Commit

```bash
git add .
git commit -m "chore: bootstrap Godot project"
```

If using GitHub CLI:

```bash
gh repo create hull-breach \
  --private \
  --source=. \
  --remote=origin \
  --push
```

---

# Phase 0.8 — Branch Model

Use **trunk-based development**.

Permanent branch:

```text
main
```

Short-lived branches:

```text
feature/player-movement
feature/noise-system
fix/mobile-input
chore/update-godot
```

Do not maintain:

```text
develop
release
integration
staging
```

unless the project eventually grows large enough to justify them.

Require PRs into `main`.

---

# Phase 0.9 — Commit Conventions

Use conventional commit prefixes:

```text
feat:
fix:
refactor:
test:
docs:
build:
chore:
perf:
```

Examples:

```text
feat: add twin-stick player aiming
fix: prevent shotgun firing while reloading
perf: pool projectile impact effects
docs: document third-party alien sprites
```

---

# Phase 0.10 — Project Settings

Configure:

```text
Display Mode:
Landscape

Logical viewport:
640 × 360

Stretch:
canvas_items

Renderer:
Compatibility
```

Input actions:

```text
move_left
move_right
move_up
move_down

aim_left
aim_right
aim_up
aim_down

fire
secondary_fire
interact
reload
sprint
pause

weapon_next
weapon_previous
```

Do not code against raw keyboard scancodes.

All gameplay input must go through Godot InputMap.

---

# Phase 0.11 — Initial Scene

Create:

```text
levels/dev/bootstrap.tscn
```

containing:

```text
Bootstrap
├── Camera2D
├── ColorRect/background
└── Label
```

Display:

```text
Hull Breach
Development Build
```

Pressing F6/F5 must launch without errors.

---

# Phase 0.12 — Testing

Install GdUnit4.

Add:

```text
tests/unit/test_bootstrap.gd
```

The test verifies the testing environment runs.

Testing becomes mandatory for deterministic domain logic introduced later.

---

# Phase 0.13 — Continuous Integration

Create:

```text
.github/workflows/ci.yml
```

CI responsibilities:

1. checkout;
2. install pinned Godot;
3. import project;
4. run automated tests;
5. verify project loads;
6. optionally produce Linux debug build.

Godot supports headless CI operations and command-line exporting, including `--headless` and `--export-release`.

Conceptually:

```bash
godot --headless --path . --import
```

and:

```bash
godot \
  --headless \
  --path . \
  --export-debug \
  "Linux" \
  build/hull-breach.x86_64
```

Exact workflow implementation should pin the Godot dependency.

---

# Phase 0.14 — Export Presets

Create:

```text
Windows Desktop
Linux
macOS
Android
iOS
```

Only desktop export must be fully operational during Phase 0.

`export_presets.cfg` should be committed.

Secrets must not.

---

# Phase 0.15 — Third-Party Assets Register

Create:

`THIRD_PARTY_ASSETS.md`

Format:

```text
# Third-Party Assets

## Kenney — Top-down Shooter

Source:
https://kenney.nl/assets/top-down-shooter

Author:
Kenney

Licence:
CC0 1.0

Downloaded:
YYYY-MM-DD

Usage:
Prototype character, furniture and weapon art.

Local path:
assets/third_party/kenney/top_down_shooter/
```

All imported external assets require an entry before merging.

---

# Phase 0.16 — Architecture Decision Records

Create:

```text
docs/adr/
```

Initial ADRs:

```text
0001-use-godot.md
0002-use-gdscript.md
0003-use-compatibility-renderer.md
0004-feature-oriented-source-layout.md
0005-use-cc0-prototype-assets.md
```

Keep them short.

This will stop architectural choices being repeatedly reopened six months later.

---

# Phase 0 Definition of Done

Phase 0 completes when:

* clean clone opens under Godot 4.7.2;
* project runs;
* no missing dependencies exist;
* automated test runs;
* CI succeeds;
* Windows or Linux debug export succeeds;
* controller InputMap exists;
* repository structure exists;
* third-party licence policy exists;
* README setup process is tested on a clean machine.

---

# PHASE 1 PRD — Combat Sandbox

## Objective

Prove that movement and shooting are satisfying.

This phase deliberately avoids building a campaign.

---

## Duration

Approximately:

**1–2 weeks**

---

## Features

Implement:

* player movement;
* mouse aiming;
* controller aiming;
* player sprite;
* camera;
* collisions;
* one weapon;
* projectiles;
* weapon cooldown;
* ammo;
* reload;
* one enemy;
* enemy health;
* enemy chase;
* player damage;
* enemy death;
* minimal HUD;
* debug arena.

---

## Player Character

Prototype with Kenney Top-down Shooter character assets.

Placeholder visuals are acceptable.

Player must support independent:

```text
movement direction
```

and:

```text
aim direction
```

---

## Enemy

Use either:

* simple custom placeholder;
* CC0 Alien Sprite Sheet.

Enemy behaviour:

```text
IDLE
→ detect player
→ CHASE
→ ATTACK
→ DEAD
```

---

## Weapon

Initial weapon:

**Pulse Rifle**

Requirements:

* configurable damage;
* configurable fire rate;
* configurable magazine;
* reload;
* projectile speed;
* weapon noise property, although noise AI is deferred.

---

## Debug Level

Create:

```text
levels/dev/combat_sandbox.tscn
```

Arena includes:

* walls;
* obstacles;
* player;
* alien spawners;
* ammo pickup.

---

## Phase 1 Technical Deliverables

Implement Resource:

```text
WeaponDefinition
```

Implement:

```text
HealthComponent
```

Implement first:

```text
EnemyDefinition
```

Implement object pooling only if profiling demonstrates a problem.

Do not prematurely build a large ECS.

---

## Phase 1 Acceptance Criteria

Player can:

* move smoothly with WASD;
* move smoothly with controller;
* aim independently;
* shoot;
* reload;
* kill an enemy;
* receive damage;
* die;
* restart.

Minimum:

**20 enemies simultaneously**

at:

**60 FPS**

on development machine.

Combat must subjectively be enjoyable before moving on.

---

## Phase 1 Non-goals

No:

* missions;
* campaign;
* procedural generation;
* mobile controls;
* advanced lighting;
* bosses;
* inventory management;
* complex AI.

---

# PHASE 2 PRD — Vertical Slice

## Objective

Produce one small mission demonstrating the intended final game.

This is the most important phase.

At completion, the question should be:

> Is this game worth building?

---

## Duration

Approximately:

**3–5 weeks**

---

# Vertical Slice Mission

Working name:

**Station Blackout**

Duration:

**10–15 minutes**

Mission:

> Restore communications and reach extraction.

---

## Level Flow

Player enters reception.

Communications room has no power.

Engineering is locked.

Player locates security credentials.

Player reaches engineering.

Player restores auxiliary power.

Power restoration:

* activates lights;
* opens selected doors;
* activates dormant aliens.

Player returns to communications.

Player transmits distress signal.

Transmission triggers alarm.

Enemy wave begins.

Player reaches extraction.

---

# Phase 2 Systems

Implement:

* TileMapLayer environment;
* doors;
* access cards;
* terminals;
* interaction system;
* objectives;
* mission state;
* power system;
* lighting states;
* enemy noise perception;
* item pickups;
* ammunition;
* health;
* armour;
* checkpoint;
* pause menu;
* one complete mission.

---

# Noise System

Introduce:

`NoiseEvent`

Fields:

```text
position
radius
source
category
intensity
```

Enemies subscribing to the noise system decide independently whether they react.

Noise should not directly command an enemy to attack.

It provides sensory information.

---

# Power System

Initial grid:

```text
PowerGrid
├── emergency_lighting
├── main_lighting
├── doors
└── communications
```

Systems subscribe to changes.

Example:

```text
PowerGrid.main_power_changed
```

No direct:

```text
Generator -> every light in level
```

relationship.

---

# Phase 2 Asset Set

Use primarily:

* Warped Top-Down Tech Lab;
* Warped Tech Lab Extension;
* Kenney character/prop assets;
* CC0 alien placeholder.

Visual inconsistency is acceptable at this phase.

---

# Phase 2 Mobile Prototype

Basic touchscreen controls must be introduced now.

Do not leave mobile input until Beta.

Requirements:

* left virtual joystick;
* right virtual aim/fire joystick;
* interact button;
* reload;
* pause.

Build must run on at least one real Android device.

---

# Phase 2 Acceptance Criteria

A new player can:

1. launch the game;
2. understand how to move;
3. find an objective;
4. shoot aliens;
5. collect access card;
6. restore power;
7. observe changed level state;
8. complete communications objective;
9. survive final attack;
10. extract.

Target playtime:

**10–15 minutes**

No developer console should be necessary.

Desktop:

**stable 60 FPS**

Mobile:

**stable 60 FPS on target test device under normal encounter load.**

---

# Phase 2 Exit Decision

At the end of Phase 2 choose one:

### GO

Combat and exploration are enjoyable.

Proceed.

### CHANGE

Core concept works but important mechanics need redesign.

Repeat portions of Phase 2.

### STOP

Core experience is not enjoyable enough to justify content production.

This decision gate prevents spending six months producing content for an unproven game.

---

# PHASE 3 PRD — Production Systems

## Objective

Turn the vertical slice architecture into reusable systems from which many levels can be produced.

---

## Duration

Approximately:

**3–5 weeks**

---

# Features

Implement reusable:

* enemy architecture;
* weapon system;
* item system;
* environmental hazards;
* mission objectives;
* checkpoint system;
* save system;
* difficulty settings;
* settings screen;
* audio buses;
* spawning system;
* level transition system.

---

# Enemy Expansion

Implement:

* Drone;
* Hunter;
* Spitter;
* Swarm;
* Brute.

Each must differ behaviourally.

Simply increasing:

```text
health = 200
```

does not constitute a new enemy.

---

# Weapon Expansion

Add:

* pistol;
* rifle;
* shotgun;
* plasma cutter.

Every weapon requires distinct:

* tactical purpose;
* sound profile;
* ammo economy;
* recoil;
* visual feedback.

---

# Level Authoring

Create reusable level-design components:

```text
EnemySpawner
PickupSpawner
MissionTrigger
Door
Terminal
AccessReader
PowerNode
Hazard
ExtractionZone
Checkpoint
```

A designer must be able to create a mission mostly through editor configuration.

---

# Save System

Implement:

```text
SaveGame
version
profile
campaign
settings
```

Automated tests required for:

* serialization;
* loading;
* missing fields;
* version migration.

---

# Phase 3 Acceptance Criteria

A second mission can be built without adding custom mission-specific code to core systems.

Creation of a conventional:

* locked door;
* access card;
* power objective;
* extraction;

must require configuration rather than new programming.

---

# PHASE 4 PRD — Content Alpha

## Objective

Build enough content to represent the complete game.

---

## Expected Duration

**6–10 weeks**, highly dependent on art/content resources.

---

# Alpha Content Target

Recommended initial campaign:

**8 missions**

Average:

**15–25 minutes**

Total first-play campaign:

approximately:

**3–5 hours**

This is intentionally achievable for a small indie project.

Do not start by planning a 20-hour campaign.

---

# Proposed Campaign

## Mission 1 — Blackout

Tutorial/communications.

## Mission 2 — Medical Wing

Introduces infected survivors and environmental contamination.

## Mission 3 — Cargo Deck

Large open encounters and swarm enemies.

## Mission 4 — Research

Introduces Stalkers and failed experiments.

## Mission 5 — Engineering

Heat and electrical hazards.

## Mission 6 — Reactor

Power-routing puzzle under enemy pressure.

## Mission 7 — Hive

Organic infestation transforms normal station architecture.

## Mission 8 — Evacuation

Large multi-stage finale and boss encounter.

---

# Alpha Content Requirements

At least:

* 8 missions;
* 6 standard enemy types;
* 1 boss;
* 5 weapons;
* 3 environmental hazard types;
* 15+ sound effects categories;
* ambient soundtrack;
* title screen;
* settings;
* complete save/load;
* campaign progress.

---

# Procedural Generation

Not required.

Hand-authored levels are preferred.

Procedural generation can become a post-release mode.

Alien Breed's strength comes partly from navigating deliberate environments.

Do not lose that by making random corridors before handcrafted levels are proven.

---

# Alpha Acceptance Criteria

Entire campaign playable from start to finish.

No developer intervention required.

All placeholder mechanics complete.

Game may still contain placeholder:

* art;
* audio;
* balancing;
* UI.

No major feature remains undefined.

---

# PHASE 5 PRD — Beta / Platform Hardening

## Objective

Stop adding major systems.

Make the game reliable and enjoyable.

---

## Duration

Approximately:

**4–6 weeks**

---

# Beta Priorities

1. bugs;
2. performance;
3. input;
4. usability;
5. balancing;
6. accessibility;
7. platform compatibility;
8. visual consistency.

Feature additions require strong justification.

---

# Mobile Optimisation

Test:

* touchscreen accuracy;
* thermal behaviour;
* battery consumption;
* particle performance;
* lighting performance;
* memory;
* safe areas;
* interrupted/resumed application state.

Devices should include at least:

* one older Android;
* one mid-range Android;
* one modern Android;
* one older supported iPhone;
* one modern iPhone.

---

# Android Build

Godot supports Android one-click deployment once its Android export toolchain and runnable export preset are configured.

Beta requires:

* signed development build;
* internal store/test distribution;
* resume after sleep;
* audio interruption handling;
* controller pairing test.

---

# iOS Build

iOS export requires macOS and Xcode.

Beta requires:

* real iPhone build;
* safe-area validation;
* touch validation;
* suspend/resume;
* controller test;
* TestFlight build.

---

# Desktop Testing

Validate:

* Windows keyboard/mouse;
* Windows controller;
* Linux;
* Steam Deck;
* macOS;
* common resolutions;
* multiple DPI scales.

---

# Art Replacement Audit

Classify every external asset:

```text
FINAL
MODIFIED
PLACEHOLDER
REPLACE
```

Any asset whose licence is uncertain is replaced.

Third-party licence register must be complete.

---

# Beta Acceptance Criteria

No:

* blocker bugs;
* save corruption;
* repeatable crashes;
* impossible missions;
* required debug commands.

Target:

**60 FPS**

during normal gameplay on target hardware.

---

# PHASE 6 PRD — Release Candidate

## Objective

Produce a commercially releasable build.

---

## Duration

Approximately:

**2–4 weeks**

---

# Features

Code freeze.

Only:

* bug fixes;
* performance fixes;
* localisation fixes;
* store integration fixes;
* compliance fixes.

---

# Release Requirements

Desktop:

* Windows build;
* Linux build;
* macOS build.

Mobile:

* Android App Bundle;
* iOS App Store build.

Store assets:

* icon;
* screenshots;
* trailer;
* description;
* privacy information;
* support information;
* licence/credits screen.

---

# Credits

Include an in-game credits section even for CC0 contributors where reasonable.

Example:

```text
Additional prototype / production artwork:

Kenney
Ansimuz
OpenGameArt contributors
```

Even where attribution is optional, acknowledging contributors is worthwhile.

---

# Versioning

Use semantic-ish game versions:

```text
0.1.0 prototype
0.2.0 vertical slice
0.5.0 alpha
0.8.0 beta
0.9.0 release candidate
1.0.0 release
```

Build metadata:

```text
1.0.0+abc1234
```

where possible.

---

# Release Candidate Acceptance Criteria

All campaign missions complete.

All saves load.

Fresh install works.

Upgrade from Beta save tested where supported.

All supported input devices work.

Credits complete.

Licences verified.

No debug menus accessible accidentally.

No placeholder assets.

No developer console logging flooding release builds.

---

# PHASE 7 PRD — Post-Launch

Not part of the minimum initial release.

Potential additions:

* challenge maps;
* survival mode;
* daily mission;
* procedural mode;
* additional campaign;
* new weapons;
* modifiers;
* achievements;
* Steam Cloud;
* leaderboards;
* local cooperative mode.

Multiplayer should remain out of scope until after v1.

Adding network multiplayer during initial production would significantly increase complexity across:

* enemy authority;
* physics;
* save state;
* level transitions;
* mobile networking;
* UI;
* pause behaviour;
* testing.

It provides poor value compared with making the single-player game excellent first.

---

# 31. Milestone Summary

| Phase     | Result                      |                           Rough Duration |
| --------- | --------------------------- | ---------------------------------------: |
| 0         | Reproducible repo/toolchain |                                 1–3 days |
| 1         | Fun combat sandbox          |                                1–2 weeks |
| 2         | Complete vertical slice     |                                3–5 weeks |
| 3         | Production-ready systems    |                                3–5 weeks |
| 4         | Complete campaign Alpha     |                               6–10 weeks |
| 5         | Beta/platform hardening     |                                4–6 weeks |
| 6         | Release candidate           |                                2–4 weeks |
| **Total** | **Potential v1**            | **~5–8 months part/full-time dependent** |

The timeline is illustrative, not contractual.

Art, audio and level creation will likely dominate later development more than programming.

---

# 32. Scope Control

The following are explicitly **not v1 requirements**:

* online multiplayer;
* local co-op;
* procedural campaign generation;
* dedicated servers;
* account system;
* cloud backend;
* PvP;
* loot boxes;
* battle passes;
* live-service architecture;
* crafting system;
* open world;
* user-generated levels;
* mod marketplace.

These may be considered after release.

---

# 33. Primary Development Metric

The project should not optimise around:

* lines of code;
* architectural sophistication;
* number of systems;
* number of enemies;
* number of weapons.

The primary development metric is:

> **How quickly can we create another good room, encounter or mission?**

Architecture should serve content production.

If a "clean architecture" makes it harder to produce levels, it is the wrong architecture for this project.

---

# 34. Key Technical Principle

Do not build an enterprise application inside Godot.

Use engineering discipline where it produces value:

* clear boundaries;
* configuration;
* tests;
* event-driven communication;
* source control;
* CI;
* reproducible builds.

But take advantage of Godot:

* scenes;
* resources;
* node composition;
* signals;
* editor tooling;
* animation;
* TileMapLayer;
* NavigationServer2D.

Avoid recreating Spring-style dependency injection, repository layers or elaborate service abstractions unless an actual game requirement justifies them.

---

# 35. First Development Backlog

After Phase 0, implementation order should be:

1. empty combat sandbox;
2. player movement;
3. independent aiming;
4. weapon firing;
5. projectile impact;
6. enemy;
7. health/damage;
8. enemy chase;
9. player death/restart;
10. controller;
11. visual/audio feedback;
12. ammo/reload;
13. second enemy;
14. noise events;
15. basic doors;
16. first real room;
17. first objective;
18. power system;
19. vertical-slice level;
20. mobile controls.

Do not begin with:

```text
SaveManager
AchievementManager
CampaignManager
ProceduralLevelGenerator
CraftingSystem
```

before the first alien is enjoyable to shoot.

---

# 36. Definition of Product Success

The project succeeds if a new player finishing the vertical slice describes the game roughly as:

> "I kept wanting to explore another room, but every time I fired the shotgun I worried about what else I'd attracted."

That interaction between:

**exploration**

**combat**

**sound**

**light**

and

**resource pressure**

should become the defining identity of Hull Breach.

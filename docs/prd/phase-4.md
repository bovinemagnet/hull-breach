# Hull Breach — Phase 4 Product Requirements and Implementation Plan

**Phase:** 4 — Content Alpha
**Project:** Hull Breach
**Status:** Proposed
**Engine:** Godot 4.7.2 Standard
**Language:** GDScript
**Renderer:** Compatibility
**Depends On:** Phases 0–3 complete
**Target Version:** `0.5.0`
**Estimated Effort:** 6–10 focused development weeks
**Primary Deliverable:** Complete campaign playable from beginning to end
**Target Campaign Length:** Approximately 3–5 hours on first playthrough

---

# 1. Purpose

Phase 4 changes the focus of Hull Breach from systems engineering to content production.

Phases 0–3 established:

```text
repository
    ↓
combat
    ↓
vertical slice
    ↓
production systems
```

Phase 4 must now answer:

> Can those systems support a complete game?

The primary goal is to create the entire playable campaign.

At the end of Phase 4:

* every planned mission exists;
* every mission can be completed;
* the campaign has a beginning, escalation and conclusion;
* all major enemy archetypes exist;
* the intended weapon roster exists;
* all major environmental mechanics are represented;
* campaign progression works;
* saves work throughout the campaign;
* desktop and mobile builds are playable;
* major placeholder art/audio may remain;
* balancing and polish are incomplete;
* the game is feature-complete enough to enter Beta.

Phase 4 is an **Alpha** milestone.

It is not the final game.

---

# 2. Phase 4 Core Principle

Phase 3 should have established a development model where common gameplay is configured rather than programmed.

Phase 4 should therefore be dominated by:

```text
level design
encounter design
enemy placement
weapon placement
mission pacing
lighting
sound
storytelling
art
playtesting
```

rather than:

```text
new frameworks
new managers
new abstractions
new foundational architecture
```

A useful warning metric is:

> If more than roughly 20–25% of Phase 4 development time is being spent on foundational architecture, Phase 3 probably exited too early.

Some new systems will inevitably emerge.

They must be justified by campaign content.

---

# 3. Phase 4 Product Goal

Deliver a complete eight-mission campaign.

Recommended campaign structure:

```text
Mission 1 — Station Blackout
Mission 2 — Medical Wing
Mission 3 — Cargo Deck
Mission 4 — Research Sector
Mission 5 — Engineering Complex
Mission 6 — Reactor Core
Mission 7 — The Hive
Mission 8 — Evacuation
```

Target mission duration:

```text
15–30 minutes
```

Target first-play campaign:

```text
3–5 hours
```

Target experienced replay:

```text
2–3 hours
```

This is intentionally modest.

The game should be short enough to maintain quality and replayability.

---

# 4. Phase 4 Success Criteria

Phase 4 succeeds when:

1. the entire campaign can be played from New Game through final credits;
2. all missions are completable without developer commands;
3. progression persists correctly;
4. checkpoints function throughout the campaign;
5. major weapons and enemies are introduced progressively;
6. each mission has a distinct gameplay identity;
7. later missions combine earlier mechanics rather than merely increasing enemy counts;
8. campaign difficulty has a sensible progression;
9. desktop, controller and mobile gameplay remain functional;
10. the game is ready for systematic Beta testing rather than continued feature development.

---

# 5. Alpha Definition

For Hull Breach:

> **Alpha means feature complete and content complete, but not polished.**

Alpha may still contain:

* placeholder art;
* inconsistent sprite quality;
* temporary sound;
* unfinished music;
* balance issues;
* imperfect UI;
* incomplete animations;
* graphical bugs;
* performance issues;
* minor mission bugs.

Alpha must **not** contain:

* missing campaign missions;
* undefined core mechanics;
* placeholder objectives that prevent completion;
* major unfinished enemy behaviours;
* missing save/load;
* absent ending;
* developer-only steps required to progress.

---

# 6. Phase 4 Non-Goals

Do not introduce unless required to complete the campaign:

* online multiplayer;
* local co-op;
* procedural campaign generation;
* crafting;
* skill trees;
* equipment rarity;
* vendor systems;
* account systems;
* daily challenges;
* live service;
* PvP;
* modding;
* user-generated levels;
* extensive dialogue trees;
* open-world navigation;
* large cinematic system;
* network telemetry backend.

Anything not required for the eight-mission campaign should generally be deferred.

---

# 7. Campaign Structure

The campaign should escalate along several dimensions:

```text
enemy complexity
environmental danger
objective complexity
resource pressure
level topology
system interactions
narrative stakes
```

Not simply:

```text
more enemies
+
more health
```

---

# 8. Campaign Progression Model

Suggested escalation:

| Mission | Primary Learning / Challenge                |
| ------- | ------------------------------------------- |
| 1       | Core combat, power, access, noise           |
| 2       | Hazards, Hunter, Spitter                    |
| 3       | Large spaces, Swarms, moving cargo          |
| 4       | Darkness, Stalkers, containment             |
| 5       | Layered power systems, environmental damage |
| 6       | Reactor pressure and timed objectives       |
| 7       | Organic infestation and altered navigation  |
| 8       | Full-system combination and escape          |

Each mission should introduce at most:

```text
1–2 major new concepts
```

Everything else should reinforce previously learned mechanics.

---

# 9. Campaign Narrative

The story should remain intentionally lightweight.

The player gradually learns:

```text
initial outbreak
    ↓
research failure
    ↓
containment breach
    ↓
infection spreading through connected facilities
    ↓
creatures are adapting
    ↓
major infestation exists
    ↓
evacuation / destruction required
```

Narrative delivery should primarily use:

* environment;
* short terminal logs;
* radio messages;
* mission briefings;
* visual changes;
* objective context.

Avoid large amounts of mandatory reading.

---

# 10. Narrative Philosophy

The player should never need to read a paragraph to understand the next objective.

Gameplay information must remain distinct from lore.

Example:

```text
OBJECTIVE:
Restore coolant flow.
```

Optional terminal:

```text
Reactor coolant pressure dropped after
containment systems failed at 03:14.
```

The first tells the player what to do.

The second provides context.

---

# 11. Campaign Mission Template

Each mission should define:

```text
Mission ID
Display Name
Primary Objective
Secondary Objectives
Estimated Duration
New Mechanic
New Enemy
Environmental Theme
Power Configuration
Access Configuration
Checkpoint Plan
Weapon / Ammo Budget
Health Budget
Encounter Plan
Narrative Beats
Extraction Condition
```

Document these before detailed implementation.

---

# 12. Campaign Content Directory

Recommended:

```text
levels/campaign/
├── 01_station_blackout/
├── 02_medical_wing/
├── 03_cargo_deck/
├── 04_research_sector/
├── 05_engineering_complex/
├── 06_reactor_core/
├── 07_hive/
└── 08_evacuation/
```

Use numeric prefixes for campaign ordering while keeping stable mission IDs independent of folder name.

Example:

```text
folder:
03_cargo_deck

mission_id:
cargo_deck
```

---

# 13. Campaign Development Strategy

Do not completely polish Mission 3 before beginning Mission 4.

Recommended process:

```text
Blockout missions 3–8
        ↓
make all missions completable
        ↓
first campaign playthrough
        ↓
fix structural problems
        ↓
content pass
        ↓
encounter pass
        ↓
art/audio pass
        ↓
balance pass
```

This reduces the risk of polishing early missions while discovering later that campaign pacing is wrong.

---

# 14. Campaign Passes

Phase 4 should use explicit passes.

## Pass 1 — Blockout

Geometry and objective flow.

## Pass 2 — Systems

Doors, access, power, hazards, encounters.

## Pass 3 — Enemy and Resource Placement

Combat and economy.

## Pass 4 — Visual Language

Lighting, props, environmental storytelling.

## Pass 5 — Audio

Ambience, machinery, enemy cues.

## Pass 6 — Playtesting

Pacing, navigation, difficulty.

This prevents missions becoming inconsistent because each is built with a different process.

---

# 15. Mission 1 — Station Blackout

Status:

Already produced during Phase 2.

Phase 4 responsibilities:

* upgrade to production mission conventions;
* rebalance alongside full campaign;
* replace obvious temporary assets;
* ensure campaign save integration;
* ensure difficulty profiles;
* improve tutorialisation;
* align visual/audio presentation with later missions.

Target duration:

```text
10–15 minutes
```

Mission purpose:

```text
teach:
movement
combat
interaction
access
power
noise
extraction
```

---

# 16. Mission 1 Difficulty

Mission 1 should be forgiving.

Avoid:

* high enemy density;
* difficult Hunter encounters;
* large resource scarcity;
* complex hazards.

The player is learning systems.

---

# 17. Mission 1 Tutorial Philosophy

Prefer contextual instruction.

Examples:

First weapon pickup:

```text
FIRE — Left Mouse / RT
```

First interaction:

```text
INTERACT — E / A
```

First reload:

```text
RELOAD — R / X
```

These prompts should disappear once understood.

Avoid lengthy tutorial screens.

---

# 18. Mission 2 — Medical Wing

Status:

Created during Phase 3.

Phase 4 responsibilities:

* campaign integration;
* art/audio consistency;
* final Hunter introduction;
* final Spitter introduction;
* hazard tuning;
* difficulty balancing;
* mission pacing.

Target:

```text
15–20 minutes
```

Purpose:

```text
enemy variety
hazards
route choice
```

---

# 19. Mission 3 — Cargo Deck

## Theme

Large industrial cargo facility.

Compared with previous narrow interiors, this mission introduces larger spaces.

Visual elements:

* cargo containers;
* loading cranes;
* forklifts;
* hangar doors;
* conveyor systems;
* storage racks;
* maintenance corridors.

---

# 20. Mission 3 Primary Objective

Example:

> Locate and secure the contaminated cargo manifest.

Secondary objective:

> Restore cargo handling system access.

Possible mission flow:

```text
ARRIVAL
  ↓
CARGO CONTROL LOCKED
  ↓
SEARCH STORAGE OFFICES
  ↓
RESTORE LOCAL CONTROL
  ↓
MOVE / OPEN CARGO SECTIONS
  ↓
INFESTED CONTAINER DISCOVERY
  ↓
RECOVER MANIFEST
  ↓
SWARM EVENT
  ↓
EXTRACTION
```

---

# 21. Mission 3 New Enemy — Swarm

Introduce:

```text
Swarm
```

Role:

> Numerous low-health creatures that pressure area control and ammunition efficiency.

Characteristics:

* low individual health;
* high numbers;
* quick movement;
* weak attacks;
* strongly attracted by sound.

---

# 22. Swarm Implementation

Swarm should not use full heavyweight AI if unnecessary.

Potential simplified behaviour:

```text
target player/noise
→ direct movement
→ lightweight avoidance
→ attack on contact
```

This can support larger counts.

Target encounter:

```text
15–30 swarm units
```

where performance permits.

---

# 23. Swarm Gameplay Purpose

Swarm should make:

```text
shotgun
```

and future area weapons valuable.

The player should think differently from fighting a Drone.

Drone:

```text
precision / steady damage
```

Swarm:

```text
crowd control / movement
```

---

# 24. Cargo Interaction

Mission may introduce reusable:

```text
CargoDoor
```

but preferably compose existing:

```text
Door
Power
Terminal
MissionTrigger
```

rather than adding a new bespoke system.

Moving cargo platforms should only be implemented if they add clear gameplay value.

---

# 25. Cargo Environmental Hazards

Possible:

* crushing machinery;
* electrical crane areas;
* explosive containers.

Do not turn the mission into a physics puzzle game.

---

# 26. Mission 3 Weapon Introduction

Recommended:

```text
Shotgun
```

if not already granted during Mission 2.

The mission's Swarm encounters naturally demonstrate its usefulness.

---

# 27. Mission 3 Design Test

Question:

> Does the player discover that weapon choice matters?

If the Pulse Rifle remains universally optimal, weapon balance needs work.

---

# 28. Mission 4 — Research Sector

## Theme

High-security biological research laboratories.

Primary mood:

```text
dark
quiet
unsettling
```

This mission should be slower and more suspenseful than Cargo Deck.

---

# 29. Mission 4 Primary Objective

Example:

> Recover the experiment archive and identify the source organism.

Flow:

```text
ARRIVAL
 ↓
SECURITY LOCKDOWN
 ↓
REACTIVATE LAB ACCESS
 ↓
ENTER CONTAINMENT
 ↓
FIND EXPERIMENT RECORDS
 ↓
CONTAINMENT FAILURE
 ↓
STALKER INTRODUCTION
 ↓
RECOVER ARCHIVE
 ↓
ESCAPE LAB
```

---

# 30. Mission 4 New Enemy — Stalker

Role:

> Ambush predator using darkness and concealment.

Behaviour:

* avoids well-lit spaces where practical;
* moves aggressively through dark routes;
* waits before attacking;
* high burst damage;
* moderate health.

---

# 31. Stalker Design

The Stalker must not simply become:

```text
invisible Drone
```

The player needs readable cues:

* sound;
* silhouette;
* brief reflected eyes;
* motion;
* environmental disturbance.

Player should feel threatened but not cheated.

---

# 32. Stalker and Lighting

Lighting becomes mechanically meaningful.

Potential behaviour:

```text
brightly lit area
→ Stalker reluctance
```

```text
dark corridor
→ Stalker aggressive
```

Do not attempt physically accurate luminance sampling if a simpler zone/tag model works better.

---

# 33. Light Influence Model

Potential Phase 4 implementation:

```text
LightZone
```

or:

```text
illumination_level
```

attached to areas.

Stalker evaluates:

```text
current area light state
```

rather than querying every light pixel.

This is easier to tune and cheaper on mobile.

---

# 34. Mission 4 Player Choice

Possible system interaction:

```text
restore laboratory lighting
```

makes Stalkers less dangerous but:

```text
activates additional machinery
/
opens containment systems
```

A good Hull Breach decision should rarely be purely positive.

---

# 35. Mission 4 Weapon Introduction

Potential:

```text
Plasma Cutter
```

Role:

> Accurate, powerful energy weapon useful against armoured enemies.

Do not add unless weapon architecture and content budget support it.

---

# 36. Mission 5 — Engineering Complex

## Theme

Industrial machinery, generators, pipes and damaged infrastructure.

Mission purpose:

```text
combine power
hazards
environmental state
enemy pressure
```

---

# 37. Mission 5 Objective

Example:

> Restore the station's main transit system.

Flow:

```text
ARRIVAL
 ↓
TRANSIT OFFLINE
 ↓
THREE ENGINEERING SUBSYSTEMS
 ↓
RESTORE COOLING
 ↓
RESTORE POWER
 ↓
REPAIR CONTROL
 ↓
TRANSIT ACTIVATES
 ↓
SYSTEM FAILURE / ENEMY EVENT
 ↓
REACH TRANSIT
```

---

# 38. Multi-Step Objectives

Mission 5 may be the first mission with objectives completed in flexible order.

For example:

```text
Restore Engineering Systems:

[ ] Coolant
[ ] Power
[ ] Control
```

The player can choose route order.

Mission architecture should already support such independent objective states.

---

# 39. Objective Graph Support

If Phase 3 mission system is strictly linear, Phase 4 may need limited prerequisite graph support.

Example:

```text
           Coolant
          /
Start ─── Power ───► Transit
          \
           Control
```

This is justified by actual content.

Avoid implementing a fully generic quest graph editor unless needed.

---

# 40. Engineering Hazards

Heavy use of:

* electrical damage;
* fire;
* steam;
* damaged machinery.

Possible environmental interaction:

```text
restore circuit
→ opens door
→ energises broken cable
```

Player must think about system state.

---

# 41. Mission 5 Enemy Combination

Recommended mix:

* Drone;
* Hunter;
* Spitter;
* Swarm.

No new enemy required unless pacing benefits from one.

This mission tests combinations of known threats.

---

# 42. Mission 5 Core Test

The player should begin predicting system interactions.

Example:

> If I restore power, that door will open—but the damaged machinery might start as well.

This demonstrates mastery rather than tutorialisation.

---

# 43. Mission 6 — Reactor Core

## Theme

High-risk energy facility.

Mission purpose:

```text
time pressure
environmental instability
resource pressure
```

---

# 44. Mission 6 Objective

Example:

> Stabilise the reactor before catastrophic containment failure.

The mission should create urgency without becoming an arcade time trial.

---

# 45. Reactor Flow

Example:

```text
ARRIVAL
 ↓
REACTOR CRITICAL
 ↓
RESTORE COOLANT
 ↓
VENT PRESSURE
 ↓
ACTIVATE CONTROL RODS
 ↓
REACTOR TEMPORARILY STABLE
 ↓
ALIEN BREACH
 ↓
FINAL STABILISATION
 ↓
EXTRACTION
```

---

# 46. Time Pressure

Avoid a single 15-minute countdown across the mission.

Prefer local timed events.

Example:

```text
Coolant pump activated

PRESSURE CRITICAL

90 seconds to open relief valve
```

This creates urgency without punishing exploration throughout the entire level.

---

# 47. Timed Objective System

If required, extend Objective with:

```text
TimerObjective
```

or optional timeout.

Behaviour:

```text
ACTIVE
→ countdown
→ COMPLETED
```

or:

```text
ACTIVE
→ timeout
→ FAILED / consequence
```

Not every timeout needs to end the mission.

---

# 48. Failure Consequences

Prefer:

```text
timer failure
→ more hazardous route
```

over:

```text
timer failure
→ instant game over
```

where possible.

Failure should create interesting consequences.

---

# 49. Reactor Environmental State

Possible:

```text
NORMAL
WARNING
CRITICAL
STABLE
```

affecting:

* lighting;
* alarms;
* hazards;
* enemy spawning;
* ambience.

---

# 50. Mission 6 Enemy Challenge

Use known enemies in combinations.

Example:

```text
Spitters
+
Swarm
```

forces player to handle:

```text
range
+
crowd pressure
```

---

# 51. Mission 6 Weapon Introduction

Potential:

```text
Incinerator
```

if final roster includes five weapons.

Role:

> Close-range area denial.

Especially useful against Swarms.

Potential tradeoff:

```text
high ammo consumption
short range
environment interaction
```

---

# 52. Incinerator Scope

Do not build complex fire propagation.

Weapon can:

* emit short-range damage area/projectiles;
* create temporary burn zone;
* apply damage over time if status system exists.

Keep implementation bounded.

---

# 53. Mission 7 — The Hive

## Theme

Facility architecture overtaken by alien biomass.

This mission should visually and mechanically break established expectations.

---

# 54. Hive Visual Language

Environment changes from:

```text
metal
panels
doors
machinery
```

to:

```text
organic walls
membranes
eggs
growth
resin
bioluminescence
```

Some underlying station architecture should remain visible.

---

# 55. Mission 7 Objective

Example:

> Locate and destroy the primary brood chamber.

Flow:

```text
ENTRY
 ↓
INFESTED TRANSIT
 ↓
BIOLOGICAL BARRIERS
 ↓
LOCATE NEST NODES
 ↓
DESTROY NODES
 ↓
OPEN DEEP HIVE
 ↓
BOSS / BROOD ENTITY
 ↓
FACILITY DESTABILISES
 ↓
ESCAPE
```

---

# 56. Organic Doors

Do not create a completely separate door architecture if avoidable.

Potential:

```text
Door interface
```

implemented by:

```text
OrganicBarrier
```

Same interaction/navigation contract, different behaviour.

This is a good test of interface/component boundaries.

---

# 57. Hive Nodes

Reusable mission object:

```text
NestNode
```

Potential behaviours:

* blocks path;
* spawns Swarms;
* generates noise;
* restores unless destroyed permanently;
* powers biological barriers.

Keep mechanics understandable.

---

# 58. Hive Navigation

Organic growth may change routes.

Possible:

```text
destroy node
→ barrier opens
```

Do not implement runtime procedural maze generation.

Hand-authored transformations are preferable.

---

# 59. Boss Requirement

Mission 7 should introduce first major boss-like enemy.

Recommended:

```text
Brood Entity
```

not necessarily a traditional arena boss.

---

# 60. Brood Entity Design

The boss encounter should use existing systems.

Possible phases:

```text
Phase 1
spawn Swarms

Phase 2
ranged organic attacks

Phase 3
exposed weak point
```

Avoid completely unique mechanics requiring a separate game architecture.

---

# 61. Boss Principle

Boss should be:

> a concentrated expression of systems the player already understands.

Not:

> an unrelated mini-game.

Use:

* movement;
* weapon choice;
* environmental cover;
* enemy adds;
* noise;
* hazards.

---

# 62. Boss Health

Do not simply give boss enormous health.

Use vulnerability windows or objectives.

Example:

```text
destroy 3 brood sacs
→ core vulnerable
```

This makes the encounter more interesting than sustained shooting.

---

# 63. Mission 7 Resource Economy

Resource availability should tighten.

The player should need to:

* explore;
* change weapons;
* decide whether optional rooms are worth risk.

But avoid soft-locking the player due to ammunition shortage.

---

# 64. Emergency Fallback

Consider a reliable fallback weapon or minimum ammunition mechanism.

The player should never reach a state where campaign progression is impossible because all ammunition is gone.

Possible solutions:

```text
Sidearm has regenerating/infinite reserve
```

or:

```text
critical encounters guarantee ammo
```

Decide during Phase 4 balancing.

---

# 65. Mission 8 — Evacuation

## Theme

Final collapse of the facility/network.

This mission combines all major systems.

It should feel urgent and climactic.

---

# 66. Mission 8 Objective

Example:

> Reach the evacuation shuttle before the infestation breaches the station.

Possible secondary objective:

> Initiate facility destruction protocol.

---

# 67. Mission 8 Flow

Example:

```text
START
 ↓
EVACUATION ORDER
 ↓
REACH COMMAND
 ↓
INITIATE DESTRUCTION
 ↓
SYSTEM LOCKDOWN
 ↓
CROSS MULTIPLE FACILITY SECTORS
 ↓
FULL ENEMY MIX
 ↓
POWER FAILURES / HAZARDS
 ↓
SHUTTLE BAY
 ↓
FINAL DEFENCE / EXTRACTION
 ↓
END
```

---

# 68. Finale Philosophy

Mission 8 should use:

```text
everything learned
```

but should not become endless enemy waves.

The dominant verb should remain:

```text
MOVE
```

not:

```text
stand still and kill 300 enemies
```

---

# 69. Final Mission State Changes

Possible dynamic sequence:

```text
normal route
→ explosion blocks route
→ emergency route opens
→ lights fail
→ alarm attracts enemies
→ power grid collapses
```

This creates a sense of facility breakdown.

---

# 70. Final Enemy Mix

Use:

* Drone;
* Hunter;
* Spitter;
* Swarm;
* Stalker;
* Brute if implemented;
* limited boss/elite presence.

Do not spawn every enemy simultaneously in every room.

Encounter composition still matters.

---

# 71. Optional Final Enemy — Brute

Phase 4 may add:

```text
Brute
```

Role:

> Slow heavily armoured space-control enemy.

Characteristics:

* high health;
* knockback resistant;
* slow;
* heavy melee;
* can break selected environmental objects/doors.

---

# 72. Brute Purpose

The Brute should force:

```text
movement
+
weapon selection
+
positioning
```

rather than simply consuming ammunition.

Possible vulnerability:

```text
armour front
weak rear / exposed tissue
```

Keep implementation readable.

---

# 73. Final Boss

A second traditional boss is optional.

Recommendation:

Avoid adding another complicated boss unless campaign needs it.

The final climax may be more effective as:

```text
facility collapse
+
combined enemies
+
evacuation
```

than another large health bar.

---

# 74. Ending

Keep ending concise.

Example:

```text
player escapes
station destroyed / quarantined
transmission reveals outbreak elsewhere
```

Potential sequel hook is fine but do not leave the core narrative unresolved.

---

# 75. Credits

Alpha should already support:

```text
Credits
```

even if incomplete.

This ensures third-party attribution is integrated before release pressure.

Sections:

* development;
* art;
* audio;
* open-source tools;
* third-party asset contributors;
* licences.

---

# 76. Enemy Roster

Target Alpha roster:

```text
Drone
Hunter
Spitter
Swarm
Stalker
Brute
Brood Entity
```

Target:

```text
5–6 standard enemy types
+
1 major boss
```

If one enemy does not meaningfully add gameplay, cut it.

Quality beats roster size.

---

# 77. Enemy Role Matrix

| Enemy        | Primary Role                |
| ------------ | --------------------------- |
| Drone        | Baseline melee pressure     |
| Hunter       | Fast/flanking pressure      |
| Spitter      | Ranged positioning pressure |
| Swarm        | Crowd pressure              |
| Stalker      | Darkness/ambush pressure    |
| Brute        | Space control / armour      |
| Brood Entity | Boss / spawning objective   |

Every enemy must answer:

> What does this enemy make the player do differently?

---

# 78. Enemy Combination Design

Later encounters should combine complementary pressures.

Examples:

```text
Drone + Spitter

Drone forces movement
Spitter punishes exposed movement
```

```text
Swarm + Brute

Swarm occupies attention
Brute controls space
```

```text
Stalker + darkness

visibility becomes resource
```

Avoid simply increasing counts.

---

# 79. Enemy Introduction Rule

Every new enemy should first appear in a controlled encounter.

Do not introduce:

```text
new enemy
+
new hazard
+
new weapon
+
new timed objective
```

simultaneously.

Let the player understand each mechanic.

---

# 80. Weapon Roster

Recommended Alpha weapons:

```text
Sidearm
Pulse Rifle
Shotgun
Plasma Cutter
Incinerator
```

Five weapons are enough.

---

# 81. Weapon Role Matrix

| Weapon        | Role                      |
| ------------- | ------------------------- |
| Sidearm       | Accurate fallback         |
| Pulse Rifle   | General-purpose           |
| Shotgun       | Close-range burst / crowd |
| Plasma Cutter | Heavy / armour damage     |
| Incinerator   | Area denial / Swarms      |

Each should have distinct:

* effective range;
* ammo economy;
* fire cadence;
* noise;
* enemy matchups.

---

# 82. Weapon Acquisition

Suggested progression:

Mission 1:

```text
Pulse Rifle
```

Mission 2:

```text
Sidearm / Shotgun
```

Mission 3:

```text
Shotgun guaranteed
```

Mission 4:

```text
Plasma Cutter
```

Mission 6:

```text
Incinerator
```

Do not overwhelm player with all weapons immediately.

---

# 83. Weapon Upgrade System

Recommendation:

Do **not** add weapon upgrades for v1 unless campaign testing demonstrates a strong need for progression.

Weapon variety itself may be enough.

Adding:

```text
damage level 1–5
reload upgrades
attachments
```

creates balancing and UI complexity.

Keep scope controlled.

---

# 84. Resource Economy

Phase 4 must establish campaign-wide ammunition philosophy.

The player should normally have enough resources to recover from imperfect play.

Recommended:

```text
expected required ammo
×
1.4–1.8 availability
```

on Standard.

This is an initial target, not a formula.

---

# 85. Resource Distribution

Avoid placing all ammo directly on critical path.

Mix:

```text
guaranteed critical ammo
+
optional exploration rewards
```

This makes exploration useful without making it mandatory.

---

# 86. Optional Rooms

Each mission should include some optional spaces containing:

* ammo;
* health;
* lore;
* weapon cache;
* shortcut;
* environmental storytelling.

The player should occasionally make:

```text
risk
vs
reward
```

decisions.

---

# 87. Secret Areas

Optional.

If included:

* keep few;
* reward observant exploration;
* do not contain mandatory resources.

Secret systems should not become another major development feature.

---

# 88. Health Economy

Standard difficulty target:

Player should not automatically leave every combat at full health.

Medkits should matter.

But damage should be recoverable.

Avoid excessive attrition causing mission restarts because one early mistake made the rest mathematically impossible.

---

# 89. Difficulty Pass

Phase 4 must test all three difficulty levels across the campaign.

Do not wait until Beta.

Target identities:

### Explorer

Focus on exploration and story.

### Standard

Intended game balance.

### Survivor

Scarcer resources and more dangerous decisions.

---

# 90. Survivor Philosophy

Survivor should emphasize:

```text
sound consequences
resource scarcity
enemy lethality
```

rather than:

```text
huge enemy health
```

---

# 91. Explorer Philosophy

Explorer should preserve mechanics.

Do not disable noise, hazards and darkness entirely.

Instead make them more forgiving.

Example:

```text
slower enemy reaction
more ammo
lower damage
stronger aim assist
```

---

# 92. Level Size

Avoid increasingly huge levels.

Target each mission for:

```text
15–30 minutes
```

rather than increasing map dimensions.

Content density matters more than floor area.

---

# 93. Room Design

Each important room should ideally serve at least one purpose:

```text
combat
navigation
story
resource choice
system interaction
atmosphere
```

Avoid large empty connector rooms.

---

# 94. Room Naming

During production assign internal names.

Example:

```text
M04_Lab_A
M04_Containment_02
M05_TurbineHall
```

Useful for:

* bug reports;
* debug teleport;
* screenshots;
* telemetry later.

---

# 95. Level Checkpoints

Target:

```text
3–5 checkpoints per mission
```

depending on mission length.

Checkpoint spacing:

approximately:

```text
4–7 minutes
```

on Standard.

Do not checkpoint immediately before every encounter.

---

# 96. Checkpoint Rules

Avoid saving in states that can immediately kill the player.

Ensure:

* no enemy attacks during spawn;
* hazard state is valid;
* critical pickups are correctly restored;
* objective state cannot become impossible.

---

# 97. Campaign Save

At Alpha:

```text
New Game
Continue
mission progress
checkpoint resume
difficulty
settings
```

must be stable across all missions.

---

# 98. Save Compatibility

During Alpha development, schema migrations may occur frequently.

Every schema change requires:

```text
migration
+
test
```

Avoid routinely deleting saves during development.

The migration discipline now will help Beta enormously.

---

# 99. Development Save Tools

Debug UI should support:

```text
create checkpoint
inspect save state
clear save
complete mission
unlock mission
load mission directly
```

Development only.

---

# 100. Campaign Mission Select

Development build should include:

```text
Mission Select
```

with:

```text
Mission 1
...
Mission 8
```

and optional checkpoint selection.

This dramatically improves testing speed.

Production build may hide locked missions.

---

# 101. Debug Teleport

Each mission should provide named development teleport locations.

Examples:

```text
start
security
engineering
boss
extraction
```

Do not make testers replay 15 minutes to reach a bug.

---

# 102. Encounter IDs

All major encounters should have stable debug IDs.

Example:

```text
M03_E04_CargoSwarm
```

This helps bug reports:

> Crash after M03_E04 is much more actionable than "near some boxes."

---

# 103. Campaign Validation

Create validation covering:

```text
all mission IDs unique
all missions load
all required objectives valid
all checkpoint IDs unique
all extraction nodes exist
all required Resources exist
```

CI must run this.

---

# 104. Automated Mission Smoke Tests

Every mission:

```text
load scene
instantiate
verify essential systems
free scene
```

CI should smoke-test all eight missions.

This prevents one broken Resource path from making a release build unusable.

---

# 105. Automated Campaign Sequence Test

Where practical, test logical progression:

```text
complete Mission 1
→ Mission 2 unlocked

complete Mission 2
→ Mission 3 unlocked
```

through final mission.

This test need not play gameplay.

It validates campaign state.

---

# 106. Enemy Definition Validation

All enemy Resources must validate:

* ID;
* health;
* movement;
* attacks;
* visuals;
* audio references where required.

A campaign-scale project cannot rely on noticing configuration errors manually.

---

# 107. Weapon Validation

Validate every weapon:

* valid ammo type;
* valid projectile;
* positive fire rate;
* magazine;
* required visual/audio resources.

---

# 108. Encounter Validation

Validate:

* spawn point IDs exist;
* enemy definitions exist;
* wave counts valid;
* encounter has valid trigger;
* no impossible active-limit configuration.

---

# 109. Mission Objective Validation

Validate:

* unique objective IDs;
* valid prerequisites;
* no impossible dependency cycle;
* at least one completion path.

If objective graphs become non-linear, cycle detection becomes worthwhile.

---

# 110. Performance Budget

Phase 4 must introduce explicit performance budgets.

Desktop target:

```text
60 FPS minimum
```

Normal encounter target:

```text
< 16.67 ms total frame
```

Prefer:

```text
8–12 ms
```

on representative development hardware, leaving headroom.

---

# 111. Mobile Performance Budget

Target:

```text
60 FPS
```

Normal gameplay.

Fallback:

```text
30 FPS
```

only for explicitly supported lower-power devices.

Do not assume mobile optimization can wait until Phase 5.

---

# 112. Enemy Budget

Normal encounter target:

```text
5–15 full AI enemies
```

Swarm scenes may use:

```text
20–40 lightweight enemies
```

Stress testing remains above normal.

---

# 113. Light Budget

Establish approximate mobile-safe limits for active dynamic lights.

For example:

```text
important gameplay lights:
limited

ambient decoration:
prefer static sprite effects
```

The exact number must come from profiling.

---

# 114. Particle Budget

Classify effects:

```text
critical
decorative
```

Mobile low-quality option may reduce:

* sparks;
* smoke;
* blood;
* environmental particles.

Critical telegraphs must remain.

---

# 115. Graphics Quality Levels

If required by mobile profiling, introduce:

```text
LOW
NORMAL
```

rather than:

```text
Low
Medium
High
Ultra
Extreme
```

for a small 2D game.

Possible differences:

* particles;
* dynamic decorative lights;
* screen effects.

---

# 116. Audio Production

Phase 4 should establish near-final audio categories.

Required:

```text
weapons
enemy vocalisations
enemy attacks
enemy deaths
doors
terminals
power
hazards
pickups
UI
ambience
alarms
music
```

Placeholder files may remain, but every gameplay event should have audio coverage.

---

# 117. Enemy Audio Identity

Each enemy should be distinguishable partly by sound.

Examples:

Drone:

```text
chitter / movement
```

Hunter:

```text
rapid movement / hunting call
```

Spitter:

```text
charge cue
```

Stalker:

```text
subtle distant movement
```

Brute:

```text
heavy footsteps
```

This supports gameplay even when visibility is low.

---

# 118. Audio Telegraphing

Dangerous attacks require distinct cues.

Player should sometimes react:

```text
before seeing attack
```

based on sound.

This is particularly valuable in a dark top-down game.

---

# 119. Ambient Audio

Each mission should have an ambience identity.

Examples:

Station Blackout:

```text
emergency power / silence
```

Medical Wing:

```text
ventilation / medical alarms
```

Cargo:

```text
industrial hum
```

Research:

```text
quiet electrical ambience
```

Engineering:

```text
heavy machinery
```

Reactor:

```text
low-frequency reactor rumble
```

Hive:

```text
organic sounds
```

Evacuation:

```text
alarms / structural collapse
```

---

# 120. Music

Phase 4 should establish campaign music direction.

Recommendation:

Use music sparingly.

Hull Breach benefits from:

```text
ambience
+
silence
+
tension
```

Constant music can reduce fear.

---

# 121. Music States

Potential simple model:

```text
ambient
tension
climax
```

No need for complex dynamic stem system unless composition supports it.

---

# 122. Art Direction Lock

By mid-Phase 4, establish a visual target.

Decide:

* pixel density;
* palette;
* character scale;
* lighting style;
* blood/gore style;
* UI style;
* environmental detail level.

Avoid changing fundamental art direction in Beta.

---

# 123. Prototype Art Audit

For every asset:

```text
FINAL
KEEP_AND_MODIFY
PLACEHOLDER
REPLACE
```

Document.

---

# 124. Third-Party Asset Strategy

By end of Phase 4, any asset expected to remain in v1 must have:

* verified licence;
* source;
* author;
* local path;
* credits status.

Unknown licence:

```text
REMOVE
```

---

# 125. Visual Consistency

Avoid obvious mixture of:

```text
32×32 pixel art
high-res vector art
photorealistic texture
cartoon UI
```

unless deliberately styled.

Open-source assets should be edited where licence permits to create coherent presentation.

---

# 126. Player Visuals

By Alpha the player should have near-production:

* idle;
* movement;
* firing;
* reload;
* damage;
* death.

Optional:

* flashlight pose;
* weapon-specific visuals.

Avoid waiting until Beta to discover animation requirements.

---

# 127. Enemy Animation

Every production enemy should have readable:

```text
idle/movement
attack
hit feedback
death
```

Not every enemy needs complex frame animation.

Transform/particle effects can supplement simpler sprite sets.

---

# 128. Environmental Animation

Use selectively:

* flickering screens;
* rotating fans;
* machinery;
* doors;
* alarms;
* hive movement.

Avoid animating every decorative tile.

---

# 129. UI Alpha

By Phase 4 the UI should be structurally final.

Required screens:

```text
Title / Main Menu
New Game
Continue
Difficulty
Settings
Pause
Death
Mission Complete
Credits
```

Optional:

```text
Mission Select
```

---

# 130. HUD Alpha

Final structural HUD should include:

* health;
* weapon;
* magazine;
* reserve ammo;
* objective;
* interaction;
* contextual notifications.

Do not keep redesigning information architecture during Beta.

Visual polish can continue.

---

# 131. Mobile HUD Alpha

Touch layout must now support all final combat functions.

Required:

```text
move
aim/fire
interact
reload
weapon switching
pause
```

If sprint/flashlight toggle becomes an action, support them too.

---

# 132. Mobile Control Customization

By Alpha:

* virtual stick size;
* opacity;
* aim sensitivity;
* optional floating stick if retained.

Potential control repositioning can be Beta if desired.

---

# 133. Controller Support

Every campaign mission must be fully completable:

```text
without keyboard
```

Menu navigation included.

---

# 134. Steam Deck

If Steam is intended:

Phase 4 should test on Steam Deck or a comparable controller-first Linux environment if available.

Test:

* performance;
* UI scale;
* controller prompts;
* sleep/resume.

---

# 135. Android

Every mission must launch and run on Android.

Do not require completing every campaign mission on every commit, but perform campaign-wide mobile passes periodically.

---

# 136. iOS

By end of Alpha, at least one real-device iOS build should be validated if iOS remains a launch target.

Do not first discover iOS-specific issues during release candidate work.

---

# 137. Environmental Storytelling Pass

Each mission should include roughly:

```text
3–6 meaningful environmental narrative moments
```

rather than hundreds of generic props.

Examples:

* breached containment;
* last defensive position;
* failed evacuation;
* improvised barricade;
* engineer death near manual control;
* hive consuming machinery.

---

# 138. Terminal Content

Keep optional terminal entries short.

Target:

```text
30–100 words
```

per log.

Avoid forcing player to read.

---

# 139. Dialogue

If radio/dialogue exists:

keep exchanges short.

Example:

```text
CONTROL:
Power signature detected ahead.

PLAYER:
Engineering?

CONTROL:
No. Something larger.
```

Avoid building a dialogue-heavy game unless intended.

---

# 140. Localization Readiness

Even if localization begins later:

all player-facing text should now come through a central localization-friendly mechanism.

Avoid hardcoded English strings in gameplay scripts.

---

# 141. Text Keys

Example:

```text
objective.restore_power
door.access_denied
pickup.engineering_access
mission.station_blackout.title
```

Do not use English text as ID.

---

# 142. Tutorial Prompts

Tutorial prompts should also use localization keys.

Prompt state should be tracked so repeated campaign play does not constantly show beginner instructions unless enabled.

---

# 143. New Game Experience

Phase 4 should now feel coherent from launch.

Flow:

```text
Title
 ↓
New Game
 ↓
Difficulty
 ↓
Briefing
 ↓
Mission 1
```

No development bootstrap visible.

---

# 144. Mission Briefings

Keep brief.

Example structure:

```text
LOCATION
OBJECTIVE
CONTEXT
```

Approximately one screen.

No elaborate cutscene required.

---

# 145. Campaign Progress Screen

Optional simple screen:

```text
C-12 INCIDENT

01 Station Blackout        COMPLETE
02 Medical Wing            COMPLETE
03 Cargo Deck              ACTIVE
04 Research Sector         LOCKED
...
```

Good for testing and player orientation.

---

# 146. Mission Completion Stats

Useful Alpha metrics:

* completion time;
* kills;
* shots fired;
* accuracy if easy;
* damage taken;
* deaths.

These help balancing and replayability.

Do not build complex scoring yet.

---

# 147. Optional Rankings

Do not implement online rankings.

Local best times can be deferred.

---

# 148. Campaign Difficulty Curve

Suggested pressure:

```text
M1  ██
M2  ███
M3  ███
M4  ████
M5  ████
M6  █████
M7  █████
M8  ██████
```

Not strictly monotonic.

Mission 4 may intentionally slow pace while increasing tension.

---

# 149. Pacing Curve

Campaign should alternate:

```text
action
↓
exploration
↓
tension
↓
action
```

Avoid eight missions that continually increase chaos.

---

# 150. Mission Internal Pacing

Each mission should generally have:

```text
intro
→ escalation
→ quieter exploration
→ complication
→ climax
→ extraction
```

Not every room should contain combat.

---

# 151. Empty Space

Intentional quiet areas are important.

They allow:

* atmosphere;
* anticipation;
* resource planning;
* player recovery.

Do not populate every corridor.

---

# 152. Enemy Density

A quiet room after a difficult encounter can be more effective than another fight.

Use enemy placement to create uncertainty.

---

# 153. Noise System Campaign Pass

Phase 4 must verify noise remains important in later missions.

Avoid level design where enemies are always already aggroed.

At least some encounters per mission should allow:

```text
avoidance
silent movement
selective engagement
```

---

# 154. Weapon Noise Differentiation

Ensure:

```text
Sidearm < Rifle < Shotgun
```

or similar meaningful hierarchy.

Noise should influence weapon choice.

---

# 155. Environment Noise

Add occasional meaningful noises:

* doors;
* machinery;
* alarms;
* explosions.

Potentially allow environmental sounds to distract enemies.

---

# 156. Noise Distraction

Optional extension:

Player can activate machinery or throw object to create noise.

Only implement if a campaign encounter clearly benefits.

Do not add a distraction inventory system without need.

---

# 157. Lighting Campaign Pass

Every mission should intentionally define:

```text
normal lighting
emergency lighting
critical dark areas
```

Not every mission needs darkness as a core mechanic.

Overusing darkness reduces its impact.

---

# 158. Stalker Lighting Validation

Ensure Stalker behaviour is understandable on:

* desktop;
* mobile;
* bright displays;
* dark displays.

Avoid relying on nearly invisible visual distinctions.

---

# 159. Accessibility Alpha

Required settings should now function campaign-wide:

* screen shake;
* reduced flashes;
* aim assist;
* UI scale;
* controller sensitivity;
* touch sensitivity;
* subtitles if dialogue exists.

---

# 160. Colour Accessibility

Do not use colour alone for:

```text
access level
power state
danger
```

Example door states should differ via:

* colour;
* icon;
* text;
* shape/animation.

---

# 161. Flash Safety

Emergency lights and alarms should respect reduced-flash setting.

Avoid rapid full-screen flashing.

---

# 162. Screen Shake

Every new weapon/enemy effect must use the centralized screen-shake setting.

Do not create effects that bypass accessibility controls.

---

# 163. Save Resilience

Test save/load in every mission.

For each checkpoint:

```text
reach checkpoint
quit application
restart
continue
```

must work.

---

# 164. Campaign Save Test Matrix

For every mission:

| State            | Test                     |
| ---------------- | ------------------------ |
| Start            | Save/load                |
| Mid checkpoint   | Save/load                |
| Final checkpoint | Save/load                |
| Completion       | Progress to next mission |

This can initially be partly manual.

---

# 165. Mission Failure

If an objective can fail:

ensure recovery behaviour is clear.

Possible:

```text
checkpoint restart
```

or:

```text
alternative mission state
```

Avoid accidental campaign dead ends.

---

# 166. Soft-Lock Testing

Explicitly test:

* key collected before objective;
* door opened in unexpected order;
* player leaves objective area;
* enemy dies before trigger;
* player consumes resources early;
* save occurs during unusual state.

Alpha should aggressively search for soft locks.

---

# 167. Sequence Breaking

Players will do things out of expected order.

Where harmless:

support it.

Example:

If player finds Engineering credential before visiting locked door:

objective should recognize possession.

Do not force artificial backtracking purely because script expected sequence.

---

# 168. Mission State Robustness

Mission logic should ask:

```text
what is true?
```

not only:

```text
what event fired?
```

where necessary.

This makes save/load and sequence breaking safer.

---

# 169. Alpha Bug Classification

Use:

```text
BLOCKER
CRITICAL
MAJOR
MINOR
POLISH
```

---

# 170. Blocker

Examples:

* game cannot launch;
* save cannot load;
* mission impossible to complete;
* crash every playthrough.

Must be fixed immediately.

---

# 171. Critical

Examples:

* frequent crash;
* common save corruption;
* objective regularly breaks;
* major controls fail.

Must be fixed before Alpha completion.

---

# 172. Major

Examples:

* significant visual bug;
* enemy pathfinding failure;
* checkpoint restores wrong state;
* severe performance drop.

Should be fixed before Beta where practical.

---

# 173. Minor / Polish

Examples:

* animation glitch;
* small clipping;
* audio balance;
* typo.

Can move to Phase 5.

---

# 174. Alpha Bug Database

Every significant bug should include:

```text
mission
room
checkpoint
platform
difficulty
reproduction steps
expected
actual
```

Stable room/encounter IDs from earlier phases make this much easier.

---

# 175. Playtesting Strategy

Phase 4 needs repeated playtesting.

Use three layers.

---

# 176. Developer Playtests

Frequent.

Purpose:

* basic flow;
* bugs;
* combat tuning.

These are not representative of real player difficulty because developer knows the game.

---

# 177. Familiar Tester Playtests

People who have played earlier builds.

Purpose:

* campaign pacing;
* progression;
* difficulty changes.

---

# 178. Blind Tester Playtests

People unfamiliar with new mission.

Purpose:

* navigation;
* tutorial clarity;
* enemy understanding;
* objective understanding.

These are particularly valuable.

---

# 179. Playtest Recording

If testers consent, video capture is extremely useful.

Observe:

* where player pauses;
* wrong turns;
* ammo shortage;
* missed objective;
* unexpected strategy.

Do not explain during test unless they are completely blocked.

---

# 180. Playtest Notes

For each mission record:

```text
completion time
deaths
damage taken
ammo remaining
confusing areas
missed interactions
unexpected paths
```

---

# 181. Do Not Fix Everything With UI

If players constantly miss Engineering:

first consider:

```text
level layout
signage
lighting
landmarks
```

before adding:

```text
giant objective arrow
```

The environment should do much of the navigation work.

---

# 182. Navigation Landmarks

Each major area should have visual identity.

Examples:

```text
Medical:
green-white clinical lighting

Engineering:
yellow industrial machinery

Reactor:
blue energy glow

Hive:
organic bioluminescence
```

This helps orientation.

---

# 183. Campaign Performance Pass

After all missions exist:

profile every mission.

Record:

```text
average FPS
worst FPS
peak enemy count
peak node count
peak memory
```

desktop and representative mobile.

---

# 184. Performance Regression Table

Maintain simple document:

```text
Mission | Desktop | Android | Worst encounter
```

Example:

```text
M1 | 120 | 60 | extraction
M3 | 95  | 52 | swarm cargo bay
```

This immediately highlights optimization priorities.

---

# 185. Optimize Representative Problems

Example:

If Cargo Swarm drops mobile to 40 FPS:

profile:

* AI;
* physics;
* particles;
* rendering.

Do not globally reduce graphics until bottleneck understood.

---

# 186. Swarm Optimization

Potential options if required:

* simplified collision;
* reduced navigation refresh;
* lightweight movement;
* shared animation timing;
* fewer active agents;
* off-screen sleep.

Implement only based on profiling.

---

# 187. Enemy Sleep

Phase 4 may justify a reusable off-screen/inactive enemy simulation mode.

Potential:

```text
DORMANT
```

when far from player and not investigating noise.

This can reduce processing in larger levels.

---

# 188. Dormant Rules

Enemy can become dormant if:

```text
far from player
AND
not in active encounter
AND
not investigating
```

Must wake on:

* nearby noise;
* encounter activation;
* mission event;
* player approach.

---

# 189. Update Frequency

Not every AI subsystem needs every-frame processing.

Possible:

```text
vision check: 5–10 times/sec
navigation target update: 4–10 times/sec
```

while movement remains physics-frame-based.

Profile/tune.

---

# 190. Art Performance

Large transparent sprites can cause mobile overdraw.

Check:

* particle sizes;
* smoke;
* full-screen overlays;
* dynamic lights.

---

# 191. Production Resolution

By Phase 4, final internal rendering resolution should be locked or nearly locked.

If using:

```text
640 × 360
```

confirm:

* sprite detail;
* UI readability;
* mobile presentation;
* 4K scaling.

Changing this late can create large art rework.

---

# 192. Pixel Art Import Rules

If retaining pixel art:

standardise import:

```text
nearest filtering
mipmaps as appropriate
no unintended smoothing
```

Document.

---

# 193. Asset Naming Convention

Example:

```text
player_idle_01.png
drone_attack_03.png
m04_lab_wall_a.png
sfx_rifle_fire_01.wav
music_hive_ambient.ogg
```

Avoid:

```text
new_sprite2_final_FINAL.png
```

---

# 194. Audio Naming

Suggested:

```text
sfx_weapon_rifle_fire_01
sfx_enemy_hunter_attack_01
amb_reactor_loop
music_hive_tension
ui_confirm
```

---

# 195. Content Build Size

Monitor export size.

Open-source packs often contain many unused assets.

Do not blindly ship entire asset collections if only a subset is used.

---

# 196. Asset Import Cleanup

Before Alpha:

remove obviously unused:

* duplicate tilesheets;
* source previews;
* demo files;
* unused sounds.

Keep editable source artwork where development requires it, but consider excluding raw sources from game exports.

---

# 197. Export Filters

Ensure source/editor materials such as:

```text
.psd
.kra
.aseprite
```

are not included in production package unnecessarily.

---

# 198. Build Pipeline

By Phase 4 CI should produce at least:

```text
Windows
Linux
```

debug or Alpha builds.

Ideally:

```text
macOS
Android
```

also.

iOS may require separate signing workflow.

---

# 199. Nightly/Manual Alpha Build

Create manual workflow:

```text
Build Alpha
```

producing platform artifacts.

Do not need automatic nightly schedule unless useful.

---

# 200. Versioning

Phase 4 development:

```text
0.4.x
```

Alpha milestone:

```text
0.5.0
```

Example:

```text
0.4.0 — Mission 3
0.4.1 — Mission 4
0.4.2 — Missions 5/6
0.4.3 — Missions 7/8
0.5.0 — Alpha
```

Exact scheme can vary.

---

# 201. Alpha Release Tag

```text
v0.5.0
```

This should correspond to:

> First build where the entire planned campaign is playable end-to-end.

---

# 202. Phase 4 Development Backlog

Suggested major issues:

```text
P4-001 Alpha campaign design review

P4-002 Blockout Mission 3 Cargo Deck

P4-003 Implement Swarm enemy

P4-004 Complete Cargo Deck objectives

P4-005 Complete Cargo Deck encounters

P4-006 Cargo Deck art/audio pass

P4-007 Blockout Mission 4 Research Sector

P4-008 Implement Stalker enemy

P4-009 Implement lighting-aware Stalker behaviour

P4-010 Complete Research Sector

P4-011 Add Plasma Cutter

P4-012 Blockout Mission 5 Engineering Complex

P4-013 Add multi-objective mission support if required

P4-014 Complete Engineering Complex

P4-015 Blockout Mission 6 Reactor Core

P4-016 Add timed objective support if required

P4-017 Complete Reactor Core

P4-018 Add Incinerator

P4-019 Blockout Mission 7 Hive

P4-020 Implement OrganicBarrier

P4-021 Implement NestNode

P4-022 Implement Brood Entity boss

P4-023 Complete Hive mission

P4-024 Blockout Mission 8 Evacuation

P4-025 Implement Brute if retained

P4-026 Complete Evacuation

P4-027 Implement ending sequence

P4-028 Integrate credits

P4-029 Complete campaign progression

P4-030 Campaign save regression

P4-031 Campaign objective validation

P4-032 Add mission smoke tests

P4-033 Add campaign sequence tests

P4-034 Finalize weapon roster

P4-035 Finalize enemy roster

P4-036 Standard difficulty campaign balance

P4-037 Explorer difficulty campaign pass

P4-038 Survivor difficulty campaign pass

P4-039 Campaign ammo/health economy pass

P4-040 Controller campaign regression

P4-041 Android campaign regression

P4-042 iOS Alpha validation

P4-043 Accessibility campaign pass

P4-044 Art asset audit

P4-045 Audio asset audit

P4-046 Third-party licence audit

P4-047 Alpha performance pass

P4-048 Alpha soft-lock pass

P4-049 Blind playtesting campaign

P4-050 Alpha bug-fix pass

P4-051 Alpha documentation

P4-052 Release v0.5.0
```

---

# 203. Recommended Implementation Sequence

Do not build sequentially all the way to polished Mission 8.

---

## Step 1 — Campaign Paper Design

Define missions 3–8 at high level.

For each:

```text
goal
new mechanic
new enemy
climax
estimated duration
```

---

# 204. Step 2 — Blockout Missions 3–8

Use primitive/basic tiles.

Ensure:

```text
start
objective flow
checkpoint locations
extraction
```

exist.

Do not spend significant time on decoration.

---

# 205. Step 3 — Full Campaign Skeleton

Make it technically possible to:

```text
complete M1
→ M2
→ M3
...
→ M8
→ ending
```

even if later missions are ugly blockouts.

This is one of the highest-value milestones in Phase 4.

---

# 206. Step 4 — Mission 3 Systems

Add Swarm only once Mission 3 needs it.

Complete Cargo Deck.

---

# 207. Step 5 — Mission 4 Systems

Add Stalker and any required lighting-zone behaviour.

Complete Research Sector.

---

# 208. Step 6 — Mission 5

Prefer using existing systems.

Only add parallel objective capability if mission design genuinely requires it.

---

# 209. Step 7 — Mission 6

Add limited timer support.

Avoid expanding timer architecture beyond Reactor requirements.

---

# 210. Step 8 — Mission 7

Add Hive-specific art and organic interactive entities.

Build boss encounter.

---

# 211. Step 9 — Mission 8

Combine systems.

Avoid introducing major new mechanic in final mission.

The finale should test mastery.

---

# 212. Step 10 — First Full Campaign Playthrough

Developer plays:

```text
New Game
→ Credits
```

without development shortcuts.

Record:

* total time;
* deaths;
* bugs;
* balance issues;
* pacing issues.

---

# 213. Step 11 — Campaign Structural Fixes

Before polishing visuals:

fix:

* boring sections;
* excessive backtracking;
* unclear objectives;
* bad checkpoint spacing;
* broken weapon progression;
* weak mission identity.

---

# 214. Step 12 — Enemy/Weapon Balance

Tune across campaign.

Do not balance each mission independently without considering progression.

---

# 215. Step 13 — Resource Economy

Tune ammo and health.

Complete campaign on Standard without cheats.

---

# 216. Step 14 — Difficulty Passes

Explorer.

Then Survivor.

Avoid tuning all three simultaneously.

---

# 217. Step 15 — Environmental Art Pass

Replace obvious blockouts.

Lock visual language.

---

# 218. Step 16 — Audio Pass

Ensure every gameplay action has required sound.

Establish ambience per mission.

---

# 219. Step 17 — UI Campaign Pass

Verify all objectives, notifications and menus work across campaign.

---

# 220. Step 18 — Platform Pass

Desktop/controller/mobile.

---

# 221. Step 19 — Blind Testing

External testers.

Fix:

```text
confusion
soft locks
unreadable hazards
difficulty spikes
```

---

# 222. Step 20 — Alpha Freeze

Stop adding planned campaign features.

Fix blockers/critical issues.

Tag:

```text
v0.5.0
```

---

# 223. Content Freeze Rule

Once Alpha is reached:

New campaign mechanics should require strong justification.

The expected next step is:

```text
polish
stability
performance
balance
```

not:

```text
more features
```

---

# 224. Definition of Done — Campaign

* [ ] Missions 1–8 exist.
* [ ] Every mission has final objective flow.
* [ ] Every mission can be completed.
* [ ] Campaign progression works.
* [ ] Ending exists.
* [ ] Credits exist.
* [ ] New Game → Credits works without developer tools.
* [ ] Save/resume works throughout campaign.

---

# 225. Definition of Done — Enemies

* [ ] Drone production ready.
* [ ] Hunter production ready.
* [ ] Spitter production ready.
* [ ] Swarm production ready.
* [ ] Stalker production ready.
* [ ] Brute either production ready or formally cut.
* [ ] Brood Entity production ready.
* [ ] enemy introduction encounters exist.
* [ ] enemy combinations tested.
* [ ] enemy audio cues exist.

---

# 226. Definition of Done — Weapons

* [ ] Sidearm works.
* [ ] Pulse Rifle works.
* [ ] Shotgun works.
* [ ] Plasma Cutter works or formally cut.
* [ ] Incinerator works or formally cut.
* [ ] all weapons have defined role.
* [ ] all weapon pickups/unlocks work.
* [ ] all ammo types persist.
* [ ] all weapon HUD states work.
* [ ] controller weapon switching works.
* [ ] mobile weapon switching works.

---

# 227. Definition of Done — Missions

Every mission has:

* [ ] mission definition;
* [ ] player spawn;
* [ ] objective chain;
* [ ] extraction;
* [ ] checkpoints;
* [ ] enemy encounters;
* [ ] resource placement;
* [ ] environmental audio;
* [ ] lighting;
* [ ] difficulty validation;
* [ ] save/load validation;
* [ ] mission smoke test.

---

# 228. Definition of Done — Persistence

* [ ] campaign can be saved in every mission.
* [ ] campaign can be resumed after app restart.
* [ ] all checkpoints tested.
* [ ] mission completion persists.
* [ ] weapon/ammo state persists correctly.
* [ ] access/objective/power state persists.
* [ ] schema migrations tested.
* [ ] corrupted save handling still works.

---

# 229. Definition of Done — Difficulty

* [ ] campaign completed on Explorer.
* [ ] campaign completed on Standard.
* [ ] campaign meaningfully tested on Survivor.
* [ ] no difficulty produces impossible resource economy.
* [ ] Survivor enemies are not excessive bullet sponges.
* [ ] Explorer retains core mechanics.

---

# 230. Definition of Done — Input

* [ ] full campaign keyboard/mouse completable.
* [ ] full campaign controller completable.
* [ ] mobile controls support every required action.
* [ ] menu controller navigation works.
* [ ] touch menu navigation works.
* [ ] input prompts remain correct.

---

# 231. Definition of Done — Performance

* [ ] every mission profiled on desktop.
* [ ] every major encounter profiled.
* [ ] worst mobile encounters identified.
* [ ] no persistent catastrophic performance problems.
* [ ] no obvious memory growth across mission transitions.
* [ ] checkpoints do not cause memory leaks.

---

# 232. Definition of Done — Art

* [ ] visual direction locked.
* [ ] no critical gameplay object uses unreadable placeholder.
* [ ] all placeholders marked.
* [ ] all intended final third-party assets licensed.
* [ ] player animation structurally complete.
* [ ] enemy animation structurally complete.
* [ ] environmental states visually understandable.

---

# 233. Definition of Done — Audio

* [ ] all weapons have sound.
* [ ] all enemies have major cues.
* [ ] doors/terminals/power/hazards have sound.
* [ ] each mission has ambience.
* [ ] alarm sequences have sound.
* [ ] audio bus settings work.
* [ ] no required sound has unknown licence.

---

# 234. Definition of Done — UI

* [ ] main menu works.
* [ ] New Game works.
* [ ] Continue works.
* [ ] difficulty selection works.
* [ ] settings work.
* [ ] HUD complete.
* [ ] pause works.
* [ ] death screen works.
* [ ] mission-complete screen works.
* [ ] credits work.
* [ ] all campaign objectives display correctly.

---

# 235. Definition of Done — Accessibility

* [ ] screen shake setting applies everywhere.
* [ ] reduced flashes applies everywhere.
* [ ] aim assist works.
* [ ] UI scale works.
* [ ] subtitles exist if required.
* [ ] access/power indicators do not depend only on colour.
* [ ] controller sensitivity persists.
* [ ] touch sensitivity persists.

---

# 236. Definition of Done — Validation

* [ ] all unit tests pass.
* [ ] all integration tests pass.
* [ ] all mission smoke tests pass.
* [ ] campaign progression test passes.
* [ ] content validation passes.
* [ ] CI builds succeed.
* [ ] no unknown asset licences.
* [ ] no debug-only requirements remain in campaign flow.

---

# 237. Alpha Acceptance Scenario

A player must be able to:

```text
Install build
    ↓
Launch
    ↓
New Game
    ↓
Choose Standard
    ↓
Complete Station Blackout
    ↓
Complete Medical Wing
    ↓
Complete Cargo Deck
    ↓
Complete Research Sector
    ↓
Complete Engineering Complex
    ↓
Complete Reactor Core
    ↓
Complete The Hive
    ↓
Complete Evacuation
    ↓
See ending
    ↓
See credits
```

During this process the player may:

```text
quit
restart application
continue
die
reload checkpoints
change settings
use controller
```

without losing campaign integrity.

---

# 238. Alpha Acceptance — Technical

The build must have:

```text
zero known blocker bugs
```

and:

```text
zero known reproducible save-corruption bugs
```

Some major/minor bugs can remain for Beta.

---

# 239. Alpha Acceptance — Gameplay

The campaign must demonstrate:

```text
exploration
combat
weapon choice
sound consequences
lighting
power systems
access
hazards
enemy variety
resource management
mission escalation
```

No major advertised gameplay pillar should still be theoretical.

---

# 240. Alpha Acceptance — Content

All eight missions must have:

```text
start
middle
climax
end
```

No:

```text
TODO room
placeholder objective
developer teleport required
```

in normal progression.

---

# 241. Alpha Exit Review

Before starting Phase 5, conduct a formal review.

Ask:

### Campaign

Is there a complete game here?

### Mission Variety

Do missions feel different?

### Enemy Variety

Do enemy types produce different behaviour from player?

### Weapon Variety

Do players intentionally change weapons?

### Difficulty

Is Standard fair?

### Resource Economy

Can players recover from mistakes?

### Navigation

Do players frequently get lost?

### Save System

Can they safely stop and resume?

### Mobile

Is the full game still viable on phones?

### Scope

Are any planned features unnecessary and better cut?

---

# 242. Cut Review

Phase 4 is the last good time to aggressively cut weak features.

Possible cuts:

```text
Brute
Incinerator
secondary objectives
extra boss
complex timed mechanics
```

if they are not improving the game.

A smaller complete game is better than a larger unstable one.

---

# 243. Do Not Add Content Because of Sunk Cost

If an enemy or weapon is consistently uninteresting:

cut it.

Do not retain it merely because engineering time was spent.

Phase 4 optimises the product, not the historical effort.

---

# 244. Phase 4 Release

Version:

```text
0.5.0
```

Tag:

```text
v0.5.0
```

Suggested release description:

```text
Hull Breach v0.5.0 — Alpha

First complete campaign build.

Includes:

- complete eight-mission campaign
- Station Blackout
- Medical Wing
- Cargo Deck
- Research Sector
- Engineering Complex
- Reactor Core
- The Hive
- Evacuation
- full campaign progression
- persistent checkpoint saves
- campaign ending and credits
- expanded enemy roster
- Drone
- Hunter
- Spitter
- Swarm
- Stalker
- optional Brute
- Brood Entity boss
- full Alpha weapon roster
- expanded environmental hazards
- campaign-wide power and access systems
- noise-driven enemy behaviour
- difficulty modes
- controller support
- mobile controls
- campaign-wide content validation
- desktop/mobile performance baselines
- Alpha art/audio integration

The game is now content-complete and ready for Beta hardening.

Known issues may include balancing, presentation, performance and minor gameplay defects.
```

---

# 245. Phase 5 Handoff

Phase 5 must not begin by asking:

> What features should we add?

It should ask:

```text
What prevents this Alpha from being something we would confidently sell?
```

Phase 5 priorities become:

```text
bugs
stability
performance
balance
usability
accessibility
platform behaviour
art consistency
audio consistency
store readiness
```

---

# 246. Phase 4 Core Development Metric

Phase 3's key metric was:

> Can we build Mission 2 efficiently?

Phase 4's key metric becomes:

> **Can we maintain quality while producing the rest of the campaign?**

Useful signs of healthy production:

```text
mission blockout: days
common encounter setup: minutes
door/power/objective configuration: minutes
new content mostly editor-driven
few mission-specific scripts
```

Unhealthy signs:

```text
every mission requires new framework
every boss modifies player code
every objective adds new global state
every environment needs custom door logic
```

---

# 247. Phase 4 Core Product Test

By the end of Phase 4, Hull Breach should produce moments like:

```text
player enters dark Research Sector
    ↓
hears Stalker
    ↓
considers turning lights on
    ↓
realises power also activates containment
    ↓
keeps flashlight trained on corridor
    ↓
uses Sidearm rather than louder Shotgun
    ↓
Hunter approaches from another route
    ↓
player retreats
    ↓
accidentally enters electrified area
    ↓
has to decide between fighting or escaping
```

That is the game.

Not any single mechanic.

The product succeeds when:

```text
level layout
+
enemy behaviour
+
weapon choice
+
sound
+
power
+
lighting
+
resource pressure
```

interact to create situations that were not explicitly scripted.

---

# 248. Phase 4 Final Principle

Phase 4 should not be judged by:

```text
number of rooms
number of enemies
number of weapons
hours of campaign
```

It should be judged by:

> **How many memorable decisions and situations the campaign creates.**

Eight strong 20-minute missions are vastly preferable to twenty repetitive missions.

A successful Alpha means that, despite missing polish, a tester can finish the campaign and say:

> "That already feels like a complete game."

Once that statement is true, Phase 4 is finished.

Phase 5 can then focus almost entirely on turning that complete game into a reliable, polished product.

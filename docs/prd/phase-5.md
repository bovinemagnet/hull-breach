# Hull Breach — Phase 5 Product Requirements and Implementation Plan

**Phase:** 5 — Beta / Platform Hardening
**Project:** Hull Breach
**Status:** Proposed
**Engine:** Godot 4.7.2 Standard
**Language:** GDScript
**Renderer:** Compatibility
**Depends On:** Phases 0–4 complete
**Target Version:** `0.8.0`
**Estimated Effort:** 4–6 focused development weeks
**Primary Deliverable:** Stable, balanced, platform-ready Beta suitable for external testing

---

# 1. Purpose

Phase 5 converts the complete Alpha campaign into a product that is reliable enough to release.

Phase 4 answered:

> Is there a complete game?

Phase 5 must answer:

> Is this complete game reliable, understandable, performant and polished enough that players can use it without developer assistance?

The emphasis changes significantly.

Phase 5 is primarily about:

```text
stability
+
performance
+
usability
+
balance
+
platform behaviour
+
accessibility
+
presentation consistency
```

It is **not** primarily a feature-development phase.

---

# 2. Phase 5 Core Principle

The guiding rule for Beta is:

> **Fix before adding.**

Whenever a new feature is proposed, ask:

1. Does it fix a clear problem observed during testing?
2. Is it required for release?
3. Can the problem instead be solved with balancing, content, UI or level design?
4. Does introducing it create new regression risk?

If not, defer it.

The project has already passed the point where adding features is automatically progress.

---

# 3. Beta Definition

Hull Breach enters Beta when:

* all intended v1 campaign content exists;
* all major gameplay systems exist;
* all planned enemies exist or have been formally cut;
* all planned weapons exist or have been formally cut;
* campaign progression works;
* save/load works;
* ending and credits exist.

Beta means:

> **Feature complete, content complete, undergoing hardening and polish.**

---

# 4. Phase 5 Primary Objectives

Phase 5 must focus on:

* eliminating crashes;
* eliminating save corruption;
* eliminating soft locks;
* eliminating impossible objectives;
* fixing serious AI failures;
* fixing performance spikes;
* improving controller behaviour;
* improving mobile behaviour;
* balancing difficulty;
* balancing resources;
* improving navigation clarity;
* polishing UI;
* polishing audio;
* improving visual consistency;
* verifying accessibility settings;
* validating desktop/mobile platforms;
* preparing release infrastructure.

---

# 5. Non-Goals

Phase 5 should not introduce major new systems such as:

* new campaign missions;
* new progression systems;
* crafting;
* weapon upgrade trees;
* procedural generation;
* multiplayer;
* PvP;
* modding;
* new save architecture;
* major rendering rewrite;
* new inventory model;
* live-service functionality;
* account systems;
* cloud backend.

Any one of these would reopen the project's architecture and destabilise Beta.

---

# 6. Feature Freeze

At Phase 5 start, declare:

```text
FEATURE FREEZE
```

Allowed changes:

```text
bug fix
performance fix
accessibility fix
balance fix
usability fix
platform compatibility fix
presentation polish
release requirement
```

Changes requiring explicit review:

```text
new enemy
new weapon
new mission mechanic
new objective type
new persistence concept
new platform
```

---

# 7. Beta Branching Strategy

Continue trunk-based development unless release stabilisation requires a temporary branch.

Preferred:

```text
main
  ↓
short-lived fix branches
  ↓
PR
  ↓
main
```

Near release, optionally create:

```text
release/0.9
```

only when a Release Candidate truly exists.

Do not maintain a permanent `develop` branch.

---

# 8. Versioning

Suggested Beta development versions:

```text
0.6.x — early Beta hardening
0.7.x — platform/balance Beta
0.8.0 — Beta milestone
0.9.x — Release Candidate
1.0.0 — release
```

Phase 5 completes at:

```text
v0.8.0
```

---

# 9. Beta Entry Criteria

Before beginning Phase 5, verify:

* [ ] missions 1–8 complete;
* [ ] New Game → ending works;
* [ ] credits exist;
* [ ] save/resume works;
* [ ] difficulty modes exist;
* [ ] keyboard/mouse gameplay works;
* [ ] controller gameplay works;
* [ ] mobile gameplay works;
* [ ] CI green;
* [ ] all campaign missions smoke-test successfully;
* [ ] no major system remains intentionally unfinished.

If these are not true, finish Phase 4 rather than redefining unfinished Alpha work as Beta.

---

# 10. Beta Exit Criteria

Phase 5 succeeds when:

* no known blocker bugs remain;
* no known critical bugs remain;
* save corruption is not reproducible;
* campaign can be completed repeatedly;
* all supported platforms have been tested;
* performance targets are met or documented;
* difficulty has been validated;
* controller and touch controls are usable;
* accessibility settings work consistently;
* all third-party licensing is accounted for;
* remaining bugs are suitable for Release Candidate work.

---

# 11. Bug Severity Model

Use five categories:

```text
P0 — Blocker
P1 — Critical
P2 — Major
P3 — Minor
P4 — Polish
```

---

# 12. P0 — Blocker

Examples:

* game will not start;
* campaign cannot continue;
* save always corrupts;
* mission cannot be completed;
* startup crash on supported platform;
* data loss affecting normal play.

Required response:

> Fix before any lower-priority work.

---

# 13. P1 — Critical

Examples:

* frequent crash;
* mission objective frequently breaks;
* checkpoint often restores invalid state;
* controller unusable on one target platform;
* severe performance failure making gameplay effectively impossible;
* player becomes permanently stuck through normal gameplay.

Must be fixed before Beta exit.

---

# 14. P2 — Major

Examples:

* enemy regularly becomes stuck;
* checkpoint occasionally restores wrong enemy state;
* objective wording causes widespread confusion;
* frame rate drops significantly in major encounter;
* UI blocks important content;
* audio system behaves incorrectly after suspend/resume.

Most should be fixed before Beta exit.

---

# 15. P3 — Minor

Examples:

* animation pop;
* isolated clipping;
* minor incorrect sound;
* small visual inconsistency;
* non-critical objective notification issue.

Can remain into Release Candidate if necessary.

---

# 16. P4 — Polish

Examples:

* timing improvements;
* minor VFX adjustments;
* subtle sound balance;
* cosmetic UI alignment.

Should never block high-impact fixes.

---

# 17. Bug Report Template

Every actionable bug should contain:

```text
Title

Build version
Platform
Mission
Room / encounter ID
Difficulty
Input method
Checkpoint

Steps to reproduce

Expected result

Actual result

Frequency

Screenshot/video/log if available
```

Example:

```text
M06 Reactor — coolant objective fails after checkpoint reload

Build:
0.7.3

Platform:
Windows

Checkpoint:
reactor_checkpoint_2

Frequency:
100%
```

---

# 18. Reproduction First

Do not immediately patch symptoms.

For significant bugs:

```text
reproduce
    ↓
identify cause
    ↓
add regression test where practical
    ↓
fix
    ↓
verify
```

A reproducible bug is far easier to fix correctly than one addressed through guesswork.

---

# 19. Regression Testing

Every P0/P1 fix should consider:

> Can an automated regression test reasonably protect this behaviour?

Good candidates:

* objective state;
* save migration;
* inventory state;
* mission progression;
* difficulty calculations;
* checkpoint flags.

Not every physics or rendering bug needs automation.

---

# 20. Campaign Regression Suite

By Beta, maintain a regression matrix for all eight missions.

For each mission:

```text
launch
objective progression
checkpoint 1
checkpoint 2
checkpoint 3
mission complete
campaign progression
```

Automate what is reasonable.

Manually test the rest.

---

# 21. Automated Mission Validation

CI should continue checking:

```text
all mission scenes load
all mission definitions valid
all objective IDs valid
all checkpoint IDs valid
all required dependencies exist
all resources validate
```

Failures must block merge.

---

# 22. Save System Hardening

Persistence is one of the highest-risk Beta areas.

Test:

* new save;
* normal save;
* overwrite;
* backup;
* checkpoint save;
* mission completion save;
* app crash during/near save;
* corrupted primary file;
* old schema;
* unsupported newer schema;
* missing fields;
* interrupted mobile lifecycle.

---

# 23. Save Atomicity

Retain or implement:

```text
serialize state
      ↓
write temporary file
      ↓
flush/close
      ↓
validate
      ↓
replace primary
```

Optionally:

```text
previous primary → backup
```

Do not directly overwrite the only valid file without protection.

---

# 24. Save Recovery

Recommended order:

```text
load primary
   ↓
valid?
   ├── yes → continue
   └── no
        ↓
      load backup
        ↓
      valid?
        ├── yes → restore
        └── no → safe error UI
```

Do not crash into a Godot error screen.

---

# 25. Save Error UX

Player-facing message should be concise:

```text
SAVE DATA COULD NOT BE LOADED

A backup save is available.
```

or:

```text
SAVE DATA IS DAMAGED

Start a new game or return to menu.
```

Development builds can expose technical detail separately.

---

# 26. Save Compatibility Matrix

Maintain tests such as:

| Saved With     | Loaded With | Expected    |
| -------------- | ----------- | ----------- |
| 0.5            | 0.8         | migrate     |
| 0.6            | 0.8         | migrate     |
| 0.7            | 0.8         | load        |
| invalid schema | 0.8         | fail safely |

Once public testers have builds, save migration discipline becomes much more important.

---

# 27. Checkpoint Hardening

For every checkpoint verify:

```text
player position
health
weapon state
ammo
credentials
objectives
power
doors
hazards
encounters
persistent world flags
```

restores correctly.

---

# 28. Unsafe Checkpoints

A checkpoint must not restore:

* inside an enemy;
* inside a closed door;
* directly in active hazard;
* surrounded by immediately attacking enemies;
* after consuming required item but before recording state.

If necessary, include a short post-load grace period.

---

# 29. Checkpoint Grace

Optional:

```text
0.5–1.5 seconds
```

where enemies do not immediately acquire/attack player after restore.

Use only if testing shows reload deaths are unfair.

Do not make checkpoint loading exploitable.

---

# 30. Soft-Lock Testing

Beta should intentionally attempt to break mission sequencing.

Test:

* acquiring credentials early;
* opening door before objective activates;
* killing enemy before scripted encounter;
* restoring power early;
* revisiting completed objective;
* leaving an objective area halfway through;
* saving during unusual world state;
* dying during objective completion;
* activating terminal twice;
* destroying mission object prematurely.

---

# 31. Sequence Independence

Where possible, mission logic should resolve from actual state.

For example:

```text
if player already possesses medical access:
    complete acquire_medical_access objective
```

rather than requiring a specific pickup event after objective activation.

This dramatically improves robustness.

---

# 32. Campaign Completion Testing

Run repeated complete campaigns.

Target Beta testing:

```text
at least 5–10 full internal campaign completions
```

across different:

* difficulties;
* platforms;
* input methods.

External Beta will increase this substantially.

---

# 33. Difficulty Balancing

Phase 5 should establish final-ish balance for:

```text
Explorer
Standard
Survivor
```

Standard remains reference experience.

---

# 34. Standard Difficulty Goal

Standard should:

* punish careless combat;
* allow recovery;
* encourage ammo management;
* make noise matter;
* avoid frequent unavoidable deaths;
* allow a first-time player to finish with reasonable persistence.

---

# 35. Explorer Goal

Explorer should:

* retain all game systems;
* provide more health/ammo;
* reduce enemy damage;
* make aim easier;
* reduce pressure;
* preserve story and exploration.

Do not turn Explorer into invulnerability mode by default.

---

# 36. Survivor Goal

Survivor should:

* punish poor positioning;
* make loud weapons more consequential;
* reduce excess ammunition;
* increase enemy lethality;
* preserve enemy time-to-kill close to Standard.

Avoid excessive health multipliers.

---

# 37. Difficulty Test Profiles

Create representative player profiles:

```text
Novice
Average
Experienced
Developer
```

Developer performance should not drive Standard difficulty.

Developers know:

* enemy spawns;
* map routes;
* secrets;
* weapon balance.

That makes developer-only balancing unreliable.

---

# 38. Resource Economy Pass

For each mission record:

```text
starting ammo
ammo placed
expected enemies
average rounds consumed
health pickups
average damage taken
```

Not to turn design into spreadsheet optimisation, but to identify impossible or excessively generous missions.

---

# 39. Resource Safety Margin

Standard should generally include enough ammunition that a competent but imperfect player can finish.

Avoid tuning around:

```text
90% accuracy
perfect headshots
zero wasted rounds
```

That is not representative.

---

# 40. Mandatory Encounter Ammo

Before encounters critical to progression, consider guaranteed minimum resources.

Examples:

```text
ammo cache
fallback weapon
enemy drop
```

Do not rely entirely on optional exploration if running out could soft-lock progression.

---

# 41. Enemy Balance

For each enemy evaluate:

* time-to-kill;
* player damage;
* reaction time;
* telegraph quality;
* noise response;
* speed;
* encounter role.

---

# 42. Drone Beta Goal

Drone should remain:

> predictable baseline pressure.

Avoid allowing later tuning to make the most common enemy irritating.

---

# 43. Hunter Beta Goal

Hunter should:

* feel fast;
* create lateral pressure;
* remain readable;
* avoid impossible off-screen instant attacks.

Audio cues are especially important.

---

# 44. Spitter Beta Goal

Spitter should:

* encourage movement/cover;
* have readable projectile;
* provide attack wind-up;
* avoid firing through impossible geometry.

---

# 45. Swarm Beta Goal

Swarm must:

* feel numerous;
* remain performant;
* not create chaotic unavoidable collision locking;
* remain readable under particles and blood.

---

# 46. Stalker Beta Goal

Stalker must be scary but fair.

Test:

* dark displays;
* bright displays;
* mobile screens;
* reduced effects mode.

The player must receive enough audiovisual information to react.

---

# 47. Brute Beta Goal

If retained:

* should control space;
* should not simply be a massive health sponge;
* should have readable vulnerability;
* should not trap player in narrow geometry unfairly.

If it still does not add distinct gameplay, cut it even during early Beta.

---

# 48. Boss Balance

Brood Entity must be tested for:

* fight length;
* resource requirements;
* readability;
* checkpoint placement;
* phase transitions;
* add-spawn pressure.

Target fight duration:

roughly:

```text
3–6 minutes
```

depending on difficulty.

Avoid 15-minute attrition fights.

---

# 49. Weapon Balance

Every weapon should retain a reason to exist.

---

# 50. Sidearm

Questions:

* Is it useful or merely fallback trash?
* Does its accuracy matter?
* Is ammo economy attractive?
* Is it quiet enough to create a tactical niche?

---

# 51. Pulse Rifle

Questions:

* Is it too universally good?
* Does it consume enough ammo to create decisions?
* Does recoil/spread make sustained fire distinct?

---

# 52. Shotgun

Questions:

* Does close-range burst justify noise?
* Is the noise penalty obvious?
* Does it dominate Swarms too easily?

---

# 53. Plasma Cutter

Questions:

* Is it meaningfully better against armour?
* Is projectile/fire behaviour readable?
* Does it overlap too much with rifle?

---

# 54. Incinerator

Questions:

* Is area control useful enough?
* Does it obscure the screen?
* Does fire remain performant on mobile?
* Is damage-over-time understandable?

---

# 55. Weapon Switching

Test responsiveness.

Switching should not:

* silently delete reload state unexpectedly;
* duplicate ammunition;
* leave projectile origin incorrect;
* break aim direction;
* produce HUD desynchronisation.

---

# 56. Input Hardening

Input now receives dedicated platform testing.

Required methods:

```text
keyboard/mouse
Xbox-style controller
PlayStation-style controller where available
touch
```

Optional:

```text
Steam Deck controls
```

---

# 57. Keyboard/Mouse Testing

Verify:

* remapping;
* unusual keyboard layouts where practical;
* high-DPI displays;
* window resizing;
* mouse sensitivity;
* cursor confinement/fullscreen behaviour;
* aim correctness after resolution changes.

---

# 58. Controller Testing

Verify:

* dead zones;
* trigger thresholds;
* stick drift;
* simultaneous movement/aim;
* menu navigation;
* hot-plug;
* disconnect/reconnect;
* multiple controllers connected;
* controller switching mid-game.

---

# 59. Controller Disconnect

If active controller disconnects:

```text
CONTROLLER DISCONNECTED
```

Game should:

* pause where appropriate;
* allow keyboard/mouse fallback;
* resume once input available.

Avoid leaving player character moving because a stick value froze.

---

# 60. Input Prompt Switching

If prompts show buttons:

```text
keyboard activity
→ keyboard prompts

controller activity
→ controller prompts
```

Touch:

```text
touch layout
```

Do not rapidly flicker prompts if mouse motion occurs incidentally.

---

# 61. Controller Aim Curve

Beta should evaluate whether linear analogue mapping is sufficient.

Possible response curve:

```text
small stick movement
→ fine aim

large stick movement
→ rapid turning
```

If needed, introduce configurable:

```text
aim response exponent
```

but avoid overcomplicating player-facing settings unless necessary.

---

# 62. Aim Assist

Aim assist should primarily help:

```text
controller
touch
```

Potential mechanisms:

* slight direction magnetism;
* target friction;
* projectile tolerance;
* snap assistance.

Avoid strong auto-targeting that removes aiming skill.

---

# 63. Touch Input Hardening

Mobile gameplay must now receive serious testing.

Validate:

* stick placement;
* stick drift;
* finger occlusion;
* aim/fire threshold;
* button size;
* accidental interaction;
* reload accessibility;
* weapon switching;
* pause.

---

# 64. Touch Safe Areas

Test:

* display notches;
* rounded corners;
* home indicators;
* camera holes.

HUD and controls must respect safe-area margins.

---

# 65. Touch Control Layout

Recommended final baseline:

```text
left lower area:
move

right lower area:
aim/fire

right edge:
interact
reload
weapon

top:
pause
objective
```

Avoid placing important controls under common grip positions where fingers obscure gameplay.

---

# 66. Touch Customization

Beta should expose:

* movement stick size;
* aim stick size;
* opacity;
* sensitivity.

Optional:

* floating vs fixed stick.

Full arbitrary repositioning is nice but not mandatory for v1.

---

# 67. Mobile Aim/Fire Testing

The Phase 2 model:

```text
aim stick exceeds threshold
→ fire
```

must now be evaluated against:

* accidental shots;
* difficulty aiming without firing;
* weapon types requiring precision.

Potential alternative:

```text
right stick = aim
separate fire button
```

If testers consistently struggle, change the scheme during Beta.

This is exactly the kind of major usability decision Phase 5 should still permit.

---

# 68. Mobile Weapon Behaviour

Semi-automatic weapons may need special treatment.

Possible:

```text
aim stick held
→ repeated fire only for automatic weapons
```

Sidearm might fire:

```text
on aim-stick tap/release
```

or via fire button.

Test actual usability rather than forcing desktop semantics onto touch.

---

# 69. Mobile Pause / Lifecycle

Test:

```text
home button
incoming call
screen lock
app switch
notification interruption
```

Game should:

* pause;
* retain state;
* restore audio correctly;
* not continue combat invisibly.

---

# 70. Android Lifecycle

Test repeatedly:

```text
launch
background
resume
lock
unlock
rotate attempt
memory pressure
```

Landscape orientation must remain stable.

---

# 71. iOS Lifecycle

Test similar:

* background;
* foreground;
* interruption;
* audio session changes;
* controller pairing;
* safe area.

---

# 72. Desktop Window Behaviour

Test:

```text
windowed
fullscreen
borderless if supported
resolution changes
alt-tab
multiple monitors
high DPI
```

Mouse aiming must remain correct.

---

# 73. macOS Testing

Verify:

* signing workflow eventually;
* Retina scaling;
* controller support;
* fullscreen;
* permissions if any;
* suspend/resume.

---

# 74. Linux Testing

Test at least:

* common desktop distribution environment;
* controller;
* audio;
* fullscreen;
* Steam Deck if available.

---

# 75. Steam Deck

Target:

```text
60 FPS
```

where feasible.

Test:

* 1280×800;
* 16:10 UI;
* gamepad prompts;
* suspend/resume;
* text readability.

This is a natural platform for Hull Breach.

---

# 76. Resolution Matrix

Desktop Beta should include tests at:

```text
1280×720
1920×1080
2560×1440
3840×2160
1280×800
1920×1200
ultrawide where possible
```

Verify:

* HUD anchors;
* world scaling;
* interaction prompts;
* aim calculations.

---

# 77. UI Scale

UI scale setting should make:

```text
HUD
menus
objective text
subtitles
```

larger without corrupting layout.

Test at 4K.

---

# 78. Font Readability

Ensure:

* text remains crisp;
* small text is readable on phones;
* line lengths reasonable;
* contrast sufficient.

Avoid extremely small pixel fonts for important objective text.

---

# 79. Menu Usability

All menus must be usable via:

* mouse;
* keyboard;
* controller;
* touch.

No screen should require hover.

---

# 80. Menu Focus

Controller focus must:

* begin on sensible control;
* move predictably;
* never disappear;
* remain visible.

Godot UI focus bugs should be treated seriously because controller players cannot recover via mouse.

---

# 81. Confirmation Dialogs

Require confirmation for destructive actions:

```text
Start New Game
Delete Save
Reset Settings
Quit Mission
```

Do not confirm trivial actions.

---

# 82. Pause Menu

Final-ish structure:

```text
Resume
Objectives
Settings
Restart Checkpoint
Restart Mission
Quit to Main Menu
```

Consider confirmation for restart/quit.

---

# 83. Death Screen

Keep restart quick.

Preferred:

```text
YOU DIED

Restart Checkpoint
Restart Mission
Quit
```

Default focus:

```text
Restart Checkpoint
```

Avoid lengthy death animation before each retry unless intentional.

---

# 84. Objective UX

Beta playtesting should determine whether objective wording is sufficient.

Good:

```text
Restore auxiliary power in Engineering
```

Weak:

```text
Restore power
```

when player has no idea where.

---

# 85. Objective History

Consider objective screen listing:

```text
Current
Completed
```

This helps after returning to a game several days later.

Do not build complex quest journal.

---

# 86. Resume Context

When loading a save after application restart, optionally show:

```text
CURRENT OBJECTIVE

Reach Engineering
```

for a short duration.

Useful for players returning after time away.

---

# 87. Navigation Testing

Blind testers should identify:

* rooms frequently missed;
* signs not noticed;
* loops mistaken for dead ends;
* doors confused with decoration.

Fix level language before adding intrusive objective arrows.

---

# 88. Navigation Assistance

If testing demonstrates need, add optional:

```text
objective direction hint
```

under Explorer/accessibility settings.

Potential:

* subtle compass edge indicator;
* temporary path hint;
* objective pulse when map button held.

Avoid permanent glowing trail by default.

---

# 89. Minimap Decision

Beta is the right time for final decision.

Add minimap only if:

* navigation repeatedly frustrates testers;
* environmental signage cannot solve it;
* mission maps are large enough to justify it.

If added, consider:

```text
reveals explored areas only
```

rather than full-level display.

---

# 90. Audio Hardening

Perform full audio mix pass.

Balance:

```text
weapons
enemy cues
ambience
alarms
UI
music
```

Critical gameplay cues must remain audible over ambience.

---

# 91. Audio Priority

Important sounds:

```text
enemy attack wind-up
enemy nearby
player hit
weapon dry fire
objective change
alarm
```

must not disappear under loud ambience.

---

# 92. Audio Ducking

If necessary:

```text
critical dialogue/objective cue
→ slightly reduce ambience/music
```

Keep subtle.

Do not over-process the audio mix.

---

# 93. Spatial Audio

Review attenuation distances.

A player should be able to infer:

```text
enemy nearby
```

but not hear every creature across the whole map.

---

# 94. Audio Repetition

Repeated weapon/enemy sounds can become tiring.

Use small variations:

```text
pitch variation
multiple samples
volume variation
```

carefully.

Avoid cartoonish pitch changes.

---

# 95. Mobile Audio

Test:

* speaker;
* headphones;
* Bluetooth;
* interruption;
* background/foreground.

Ensure loud weapon effects are not uncomfortably clipped.

---

# 96. Music Pass

Ensure music does not:

* restart unnecessarily at checkpoints;
* overlap after reload;
* play twice after scene transitions;
* ignore volume settings.

---

# 97. Visual Polish Pass

Priorities:

1. gameplay readability;
2. visual consistency;
3. atmosphere;
4. decorative polish.

Readability always wins.

---

# 98. Player Readability

Player silhouette must remain clear against:

* bright floors;
* dark rooms;
* explosion effects;
* Hive environments.

Potential:

* subtle rim light;
* shadow;
* contrast outline.

Do not make the player hard to locate for atmosphere.

---

# 99. Enemy Readability

Each enemy needs distinct:

```text
silhouette
movement
audio
attack telegraph
```

Colour alone is insufficient.

---

# 100. Projectile Readability

Player and enemy projectiles must be visually distinct.

Example:

```text
player: cool/bright pulse
enemy: organic/acid projectile
```

But use shape/motion in addition to colour.

---

# 101. Hazard Readability

Electrical:

* arcs;
* light;
* audio.

Fire:

* visible flame;
* heat effects if appropriate.

Gas:

* haze;
* warning lights;
* audio/particle cues.

Player should know why damage occurred.

---

# 102. Damage Feedback

Player damage feedback must remain noticeable without excessive flashing.

Potential:

```text
small screen tint
audio
controller vibration
sprite reaction
```

Reduced-flash setting must modify effects.

---

# 103. Screen Shake Audit

Every source should respect global intensity:

```text
weapon
explosion
damage
boss
environment
```

At setting:

```text
0%
```

no shake should occur.

---

# 104. Vibration / Haptics

Controller/mobile haptics can be used for:

* firing;
* damage;
* explosion;
* low-ammo feedback sparingly.

Expose intensity or enable/disable setting.

---

# 105. Accessibility Hardening

Test rather than merely expose settings.

Required areas:

* reduced flashes;
* screen shake;
* UI scale;
* aim assist;
* subtitles;
* control sensitivity;
* remapping where implemented;
* colour-independent indicators.

---

# 106. Subtitle Requirements

If spoken dialogue exists:

* subtitles enabled by default or easily enabled;
* speaker identification where useful;
* readable contrast;
* adequate display time.

Optional:

```text
subtitle size
```

if UI scale does not cover it.

---

# 107. Colour-Blind Readability

Test important states:

```text
door locked
door unlocked
door unpowered
hazard
access level
health
```

using non-colour cues.

Example door indicator:

```text
LOCKED icon + red
POWER icon + amber
OPEN icon + green
```

---

# 108. Flashing Effects

Reduced-flash mode should:

* disable rapid light flicker;
* reduce full-screen flashes;
* reduce explosion intensity;
* avoid rapid alarm strobes.

---

# 109. Difficulty Accessibility

Explorer can serve as a strong accessibility option.

Avoid hiding it behind judgmental labels.

Describe clearly:

```text
Explorer — More resources, reduced incoming damage and stronger aim assistance.
```

---

# 110. Performance Hardening

Performance should now be treated as a product requirement.

Measure:

```text
average frame time
worst frame time
memory
loading
CPU
GPU
enemy counts
```

for representative encounters.

---

# 111. Performance Test Scenes

Maintain dedicated:

```text
combat_stress
swarm_stress
lighting_stress
hazard_stress
```

development scenes.

Do not use campaign levels exclusively for profiling.

---

# 112. Frame-Time Targets

60 FPS:

```text
16.67 ms/frame
```

Aim to remain below this under normal load.

Prefer headroom around:

```text
10–13 ms
```

on target/reference hardware where realistic.

---

# 113. Frame-Time Spikes

Average FPS can hide bad stutters.

Pay attention to:

```text
95th percentile
99th percentile
```

or profiler spikes.

Common causes:

* mass spawning;
* resource loading;
* particle creation;
* save operations;
* excessive navigation updates.

---

# 114. Enemy Spawning Performance

Avoid spawning 20 complex enemies on the same frame.

Use staggered spawning where appropriate:

```text
spawn
wait short interval
spawn
```

unless instant reveal is critical.

---

# 115. Resource Preloading

Frequently used combat assets may be preloaded at mission start where that prevents hitching.

Do not preload entire campaign unnecessarily.

---

# 116. Scene Loading

Profile:

```text
main menu → mission
checkpoint reload
mission transition
```

A 2D title should generally feel responsive.

If loading is visible, use simple loading/fade screen rather than freezing unexplained.

---

# 117. Loading Progress

Only implement progress bars if loading is sufficiently long to justify them.

Otherwise:

```text
fade
loading indicator
fade in
```

is cleaner.

---

# 118. Object Pooling Decision

Phase 5 is the time to revisit pooling based on real measurements.

Candidates:

* projectiles;
* hit effects;
* swarm enemies;
* common particles.

Only pool where profiling shows meaningful benefit.

---

# 119. AI Processing

Optimisation candidates:

```text
perception frequency
navigation refresh
off-screen sleep
distance-based processing
```

Gameplay must remain deterministic enough.

---

# 120. Dormant Enemies

Review Phase 4 dormancy behaviour.

Ensure dormant enemies still respond to:

```text
large alarm
mission activation
nearby noise
player approach
```

No enemy should sleep through a mission event incorrectly.

---

# 121. Navigation Performance

Watch for:

* path recalculation every frame;
* too many avoidance agents;
* navigation churn after door changes.

Tune refresh rates based on encounter needs.

---

# 122. Swarm Performance

If Swarms remain expensive, consider:

* simpler navigation;
* fewer collision checks;
* shared target updates;
* reduced off-screen processing;
* fewer animation updates.

Do not reduce perceived swarm size unnecessarily if cheaper simulation works.

---

# 123. Lighting Performance

Profile worst dark missions.

Potential reductions:

* fewer overlapping dynamic lights;
* simpler light textures;
* static emissive sprites;
* quality-level differences on mobile.

Important gameplay lighting must not disappear.

---

# 124. Particle Performance

Limit:

* giant transparent smoke;
* excessive sparks;
* overlapping blood effects.

Mobile quality setting may reduce decorative effects.

---

# 125. Memory Hardening

Profile:

```text
main menu
→ M1
→ M2
→ M3
→ menu
```

Memory should stabilise rather than increase indefinitely.

---

# 126. Memory Leak Investigation

Common suspects:

* autoload references to freed nodes;
* signals;
* cached scenes;
* audio;
* debug overlays;
* encounter lists;
* projectile pools;
* mission-state references.

---

# 127. Mobile Thermal Testing

Run:

```text
20–30 minute sessions
```

on representative phones.

Observe:

* thermal throttling;
* battery consumption;
* sustained FPS.

A game that performs well for two minutes but collapses after fifteen is not mobile-ready.

---

# 128. Mobile Quality Policy

If needed:

```text
Effects Quality:
Low
Normal
```

Low may reduce:

* decorative particles;
* secondary dynamic lights;
* non-essential post effects.

Do not reduce:

* enemy telegraphs;
* objective cues;
* hazardous-area readability.

---

# 129. Battery Considerations

Optional mobile setting:

```text
Frame Rate:
30
60
```

30 FPS can improve battery life.

60 remains default on capable devices if stable.

---

# 130. Crash Logging

Ensure development/Beta builds preserve enough logs to diagnose crashes.

Useful context:

```text
version
platform
mission
checkpoint
recent error
```

Do not log sensitive personal data.

---

# 131. Error Reporting

For external Beta, establish a simple reporting workflow.

Could be:

```text
GitHub Issues private/internal
form
email
shared tracker
```

depending on tester audience.

Do not build an in-game telemetry backend solely for Beta.

---

# 132. Beta Build Identification

Every build should expose:

```text
Hull Breach 0.7.4
Build abc1234
```

in:

* settings/about;
* pause screen footer;
* logs.

Bug reporters must be able to identify build easily.

---

# 133. Build Metadata

Recommended:

```text
semantic version
+
short Git commit
```

Example:

```text
0.7.4+8f3c211
```

Production UI may hide commit hash later.

---

# 134. CI Beta Pipeline

By Phase 5 CI should include:

```text
import
unit tests
integration tests
content validation
mission smoke tests
campaign state tests
desktop builds
```

Manual release workflow can produce:

```text
Windows
Linux
macOS
Android
```

depending on signing environment.

---

# 135. Build Artefact Naming

Use predictable names:

```text
hull-breach-0.8.0-windows-x86_64.zip
hull-breach-0.8.0-linux-x86_64.tar.gz
hull-breach-0.8.0-macos.zip
hull-breach-0.8.0-android.aab
```

Avoid:

```text
final_build_new2.zip
```

---

# 136. Reproducible Build Check

A clean CI environment must create same logical build from tagged source.

No developer-local asset should be required.

---

# 137. Platform Release Configuration

Separate:

```text
debug
beta
release
```

behaviour where needed.

Beta may include:

* extra logging;
* build number;
* optional debug report screen.

Production release should disable developer cheats.

---

# 138. Debug Feature Audit

Search for:

```text
god mode
spawn keys
skip objectives
mission unlock
teleport
```

Ensure production export cannot activate them.

---

# 139. Development Assets Audit

Ensure release package does not contain unnecessary:

* raw source files;
* test maps;
* developer screenshots;
* unused asset packs;
* debug data.

---

# 140. Licensing Audit

By Beta, create a complete inventory of every external asset expected in release.

For each:

```text
asset
creator
source
licence
required attribution
usage
modified?
```

No unresolved entries.

---

# 141. Credits Audit

Ensure credits include all required attribution.

Even CC0 assets may be voluntarily credited for transparency.

---

# 142. Open-Source Software Credits

Consider including:

```text
Godot Engine
testing tools
other redistributable components
```

according to their licence obligations.

---

# 143. Asset Replacement Deadline

All assets marked:

```text
REPLACE
```

must be replaced before Beta exit unless formally accepted as final.

Do not carry unknown placeholder art into Release Candidate.

---

# 144. Audio Replacement Deadline

Same rule for:

```text
temporary weapon sounds
temporary ambience
temporary music
```

If it ships, licensing and quality must be known.

---

# 145. Visual Consistency Pass

Review entire campaign for:

* mismatched tile scale;
* inconsistent outlines;
* inconsistent light colour logic;
* UI style conflicts;
* inconsistent blood effects;
* placeholder props.

Prioritise obvious inconsistencies.

---

# 146. Environment State Consistency

Power state should always communicate through consistent language.

Example:

```text
online:
steady lights
green/white indicator

emergency:
red/amber
slow pulse

offline:
dark
dead panel
```

Do not vary arbitrarily between missions.

---

# 147. Access State Consistency

Credential UI/doors should behave consistently:

```text
Engineering
Medical
Security
Command
```

Player should not relearn access logic each mission.

---

# 148. Interaction Consistency

Every interactable uses:

```text
same interaction range
same prompt style
same input semantics
```

unless there is a strong gameplay reason otherwise.

---

# 149. Tutorial Cleanup

By Beta, initial tutorial prompts must be:

* concise;
* accurate;
* dismissible where appropriate;
* controller-aware;
* touch-aware.

Remove obsolete Phase 1/2 development hints.

---

# 150. First-Run Experience

Perform clean-install test:

```text
install
launch
New Game
choose difficulty
start M1
```

No prior settings/save files.

Verify:

* default audio sensible;
* default controls sensible;
* UI fits screen;
* tutorial begins correctly.

---

# 151. Returning Player Experience

Test:

```text
launch
Continue
```

Player should quickly understand:

* where they are;
* current objective;
* current weapon/ammo.

---

# 152. Settings Reset

Provide:

```text
Reset to Defaults
```

for settings.

Useful when experimental settings create poor configuration.

---

# 153. Input Reset

If remapping exists:

```text
Reset Controls
```

must restore a usable configuration.

Avoid letting player unbind every way to operate menus.

---

# 154. Remapping Safety

Require at least:

```text
menu confirm
menu back
movement
```

to remain recoverable.

Potentially allow reset using mouse/touch.

---

# 155. Controller Glyphs

If implementing controller-specific glyphs:

support at least generic:

```text
South Button
East Button
RT
LT
```

or detect Xbox/PlayStation style where practical.

Generic glyphs are acceptable if simpler.

---

# 156. Localization Preparation

If localisation is planned after Beta:

perform string audit now.

Find:

* hardcoded UI text;
* objective text;
* enemy names;
* settings labels;
* errors;
* tutorial prompts.

Move to translation-friendly resources.

---

# 157. Text Expansion

Test UI with approximately:

```text
30–50% longer text
```

to catch layouts that only work with short English labels.

---

# 158. Store-Safe Content Review

Begin checking:

* game title;
* logos;
* screenshots;
* icon;
* copyright;
* credits.

Ensure no remaining Alien Breed branding or copied distinctive material exists.

Hull Breach must stand independently.

---

# 159. Content Rating Preparation

Document:

* violence;
* gore;
* horror;
* language;
* online interaction: none;
* purchases: if none, explicitly none.

This will simplify store submissions later.

---

# 160. Privacy Review

If Hull Breach has no analytics/accounts:

prefer retaining that simplicity.

Document:

```text
no advertising
no account required
no user tracking
```

if true at release.

Do not introduce analytics casually during Beta without considering privacy/store requirements.

---

# 161. External Beta Strategy

Recommended tester groups:

```text
Group A — technical testers
Group B — genre players
Group C — less experienced players
Group D — mobile players
```

Different groups expose different problems.

---

# 162. Technical Testers

Focus:

* crashes;
* save;
* controller;
* platform;
* unusual resolutions;
* resume behaviour.

---

# 163. Genre Players

Focus:

* combat;
* difficulty;
* weapon roles;
* enemy behaviour;
* campaign pacing.

---

# 164. Less Experienced Players

Focus:

* onboarding;
* navigation;
* objectives;
* accessibility;
* Explorer difficulty.

These testers are particularly useful because developers and genre veterans compensate for poor UX automatically.

---

# 165. Mobile Testers

Focus:

* touch comfort;
* aim;
* finger fatigue;
* screen readability;
* battery;
* thermal performance.

---

# 166. Tester Questionnaire

Keep concise.

Ask:

```text
Which mission was most enjoyable?

Which mission was weakest?

Were you ever unsure where to go?

Did you run out of ammunition?

Which weapon did you use most?

Which enemy felt unfair?

Did noise affect how you played?

Did lighting affect how you played?

Did you encounter a bug preventing progress?

Would you continue playing?
```

---

# 167. Avoid Leading Questions

Do not ask:

> Don't you think the noise mechanic is really cool?

Ask:

> Did weapon noise affect your decisions?

Better feedback comes from neutral questions.

---

# 168. Playtest Observation

What testers do is often more valuable than what they say.

Example:

Tester says:

> Navigation was fine.

Video shows:

```text
wanders for 7 minutes
checks same door 4 times
```

Treat behaviour as evidence.

---

# 169. Beta Feedback Triage

Classify feedback:

```text
bug
usability
balance
preference
feature request
```

Not every feature request should be implemented.

---

# 170. Repeated Feedback Rule

If one player asks for something:

note it.

If five independent players encounter the same problem:

investigate seriously.

Look for patterns rather than reacting to every opinion.

---

# 171. Balance Telemetry Without Backend

Manual test sheets can capture enough:

```text
mission
difficulty
completion time
deaths
ammo remaining
weapon usage
```

No need to build online analytics.

---

# 172. Campaign Completion Target

For Standard first-time testers:

Aim for:

```text
3–5 hours
```

without excessive repetition.

If most players take 8 hours due to getting lost, that is not extra value.

---

# 173. Mission Duration Review

Suggested targets:

| Mission             |    Target |
| ------------------- | --------: |
| Station Blackout    | 10–15 min |
| Medical Wing        | 15–20 min |
| Cargo Deck          | 20–25 min |
| Research Sector     | 20–25 min |
| Engineering Complex | 20–30 min |
| Reactor Core        | 20–30 min |
| The Hive            | 25–30 min |
| Evacuation          | 20–30 min |

These are guides, not strict limits.

---

# 174. Pacing Outliers

If one mission consistently takes twice as long as others:

ask why.

Potential:

* too much backtracking;
* unclear objective;
* repeated combat;
* oversized level.

Do not assume longer means better.

---

# 175. Backtracking Audit

Review every mandatory backtrack.

Ask:

> What changed?

Valid:

```text
new enemies
new route
power state
new hazard
new objective pressure
```

Weak:

```text
same empty corridor
```

---

# 176. Combat Density Audit

Map each mission:

```text
combat
quiet
exploration
system interaction
```

Ensure campaign has rhythm.

---

# 177. Enemy Encounter Audit

Identify repeated patterns.

If many rooms are:

```text
3 Drones + 1 Spitter
```

redesign some.

Use:

* terrain;
* direction;
* power;
* noise;
* hazard;
* lighting;
* objectives;

to create variety without more enemies.

---

# 178. Weapon Usage Audit

If one weapon represents:

```text
>70% of player shots
```

for most testers, investigate.

Potential causes:

* weapon too strong;
* ammunition too plentiful;
* alternatives unclear;
* other weapons too situational.

---

# 179. Noise Mechanic Audit

By Beta, players should reliably understand:

```text
loud weapon
→ larger risk
```

If not:

improve:

* enemy approach audio;
* level encounter design;
* noise differences;
* tutorial context.

Do not solve only with explanatory text.

---

# 180. Lighting Mechanic Audit

Verify lighting affects behaviour enough to matter but not enough to frustrate.

Especially Stalker encounters.

---

# 181. Power Mechanic Audit

Power should not always mean:

```text
OFF bad
ON good
```

Across campaign, players should have learned that restoring power can create consequences.

---

# 182. Hazard Audit

Ensure hazard damage is predictable.

Players should rarely say:

> I don't know what hurt me.

---

# 183. Boss Audit

Test with players unfamiliar with encounter.

Observe whether they understand:

* vulnerability;
* phase changes;
* objective;
* damage feedback.

Avoid requiring trial-and-error deaths just to understand the mechanic.

---

# 184. Tutorial Difficulty Audit

Mission 1 should not become tedious for replaying players.

Consider option:

```text
tutorial prompts: enabled / minimal
```

or automatically reduce prompts after completion.

Not mandatory if prompts are unobtrusive.

---

# 185. Pause/Resume Testing

Pause must freeze:

* player;
* enemies;
* projectiles;
* mission timers where appropriate.

Potential exception:

real-time platform lifecycle.

Be explicit about timed objectives during pause.

Recommendation:

Pause timed objectives too.

---

# 186. Timer Fairness

Reactor timers should pause:

* pause menu;
* app background.

Do not punish real-life interruptions.

---

# 187. Application Background Save

On mobile background:

consider creating a safe checkpoint/save if appropriate.

Do not blindly save arbitrary mid-combat scene state unless supported.

At minimum ensure current persistent checkpoint remains valid.

---

# 188. Suspend/Resume Audio

After app resumes:

* no duplicate ambience;
* no duplicate music;
* no missing audio bus state.

This is a common class of mobile bugs worth explicit testing.

---

# 189. Controller Resume

After system suspend:

controller may reconnect differently.

Ensure input remains functional.

---

# 190. Platform Certification Mindset

Even before store submission, treat:

```text
startup
suspend
resume
controller
save
permissions
quit
```

as product features.

Platform-level failures are more damaging than a missing particle effect.

---

# 191. Build Size Review

Review exported size.

Remove:

* unused open-source pack files;
* duplicate audio;
* large editable source assets;
* development scenes where not needed.

Do not aggressively compress assets at cost of visible quality unless necessary.

---

# 192. Mobile Installation Size

Especially monitor:

* uncompressed WAV;
* raw music;
* unused texture packs.

Convert release audio appropriately.

Keep editable masters in repository/LFS where needed but exclude them from export.

---

# 193. Audio Formats

Use appropriate runtime formats for:

```text
short SFX
music
ambience
```

based on Godot/platform testing.

Do not ship large uncompressed files unnecessarily.

---

# 194. Shader Compatibility

Audit all custom shaders under Compatibility renderer.

Test on:

* desktop integrated GPU if available;
* older Android;
* iOS.

Provide fallback or remove shader if unreliable.

---

# 195. Asset Import Warnings

Beta should aim for:

```text
zero unexplained import warnings
```

Do not ignore large volumes of warnings because "the game still runs."

Warnings hide genuine problems.

---

# 196. Runtime Logging

Likewise aim for:

```text
zero repeated runtime errors
zero repeated warnings
```

during normal gameplay.

A clean log significantly improves confidence.

---

# 197. CI Warnings

Where practical, make validation fail on known serious content problems.

Do not necessarily treat every engine warning as failure.

---

# 198. Beta Performance Matrix

Maintain table:

| Platform          | Target FPS | Resolution    | Status |
| ----------------- | ---------: | ------------- | ------ |
| Windows desktop   |        60+ | 1080p         |        |
| Linux desktop     |        60+ | 1080p         |        |
| macOS             |        60+ | native/scaled |        |
| Steam Deck        |         60 | 1280×800      |        |
| Android mid-range |  60 target | native        |        |
| Android low tier  |      30–60 | native        |        |
| iPhone target     |         60 | native        |        |

Fill with actual tested data.

---

# 199. Minimum Supported Hardware

Phase 5 should establish provisional minimum hardware requirements based on real measurements.

Do not publish speculative requirements.

Record tested hardware and results.

---

# 200. Desktop Graphics Options

Only add options that solve measured compatibility/performance issues.

Potential:

```text
VSync
fullscreen
resolution
effects quality
screen shake
```

Do not create meaningless options like:

```text
Texture Quality Ultra
```

for a tiny pixel-art asset set.

---

# 201. Beta Security Review

Ensure no:

```text
API tokens
signing credentials
test passwords
personal paths
```

appear in repository/export.

Review:

```text
.env
export credentials
CI logs
build scripts
```

---

# 202. Signing Preparation

Phase 5 should prepare, though not necessarily finalise:

* Android signing;
* Apple signing;
* desktop signing/notarisation strategy.

Secrets belong in secure CI/store configuration, not Git.

---

# 203. Android Store Build

Produce:

```text
AAB
```

for internal testing.

Validate:

* install/update;
* save preservation across update;
* lifecycle;
* touch.

---

# 204. iOS TestFlight Candidate

Produce at least one Beta/TestFlight-compatible build before Phase 5 exit if iOS is a v1 platform.

Validate:

* install;
* safe areas;
* save;
* controller;
* lifecycle.

---

# 205. Desktop Distribution Test

Test game from exported package, not only editor.

A Godot editor run can hide packaging issues.

Every Beta candidate must be played as a real exported build.

---

# 206. Clean Machine Test

On a machine without Godot project:

```text
download build
extract/install
launch
play
```

No development dependencies should be required.

---

# 207. Upgrade Test

Install earlier Beta.

Create save.

Install newer Beta over it.

Verify:

* settings retained;
* save migrates;
* campaign continues.

This closely resembles actual release updates.

---

# 208. Uninstall/Reinstall Behaviour

Understand platform behaviour.

If save persists after uninstall on some platform and not others, that may be acceptable, but test it.

Do not promise cloud persistence without cloud saves.

---

# 209. Credits and Legal Screen

By Beta, credits should be functionally complete enough to verify formatting and attribution.

Do not leave legal/licensing work to final release day.

---

# 210. Privacy Policy Decision

If mobile stores require a privacy policy even for minimal/no-data apps, prepare one during release preparation.

Product behaviour should match what is stated.

Do not add unnecessary data collection.

---

# 211. Store Asset Preparation

Phase 5 should begin collecting:

* screenshots;
* icon;
* capsule/key art;
* short description;
* long description;
* trailer footage.

Final marketing polish may happen Phase 6.

But game visuals need to be stable enough to capture.

---

# 212. Screenshot Mode

Optional useful developer feature:

```text
hide debug UI
hide touch controls if desired
capture clean frame
```

Do not build elaborate photo mode.

---

# 213. Trailer Capture

Ensure Beta can run:

```text
stable
without debug overlays
at high resolution
```

for capture.

---

# 214. Performance Capture

When recording video, frame rate may differ.

Do not misdiagnose recorder overhead as game performance.

---

# 215. Phase 5 Development Backlog

Suggested major issues:

```text
P5-001 Declare Beta feature freeze

P5-002 Review all Alpha P0/P1 issues

P5-003 Campaign soft-lock audit

P5-004 Checkpoint validation Mission 1

P5-005 Checkpoint validation Mission 2

P5-006 Checkpoint validation Mission 3

P5-007 Checkpoint validation Mission 4

P5-008 Checkpoint validation Mission 5

P5-009 Checkpoint validation Mission 6

P5-010 Checkpoint validation Mission 7

P5-011 Checkpoint validation Mission 8

P5-012 Save corruption/recovery testing

P5-013 Save migration regression suite

P5-014 Standard difficulty full balance pass

P5-015 Explorer difficulty full balance pass

P5-016 Survivor difficulty full balance pass

P5-017 Campaign ammo economy pass

P5-018 Campaign health economy pass

P5-019 Enemy balance pass

P5-020 Weapon balance pass

P5-021 Boss balance pass

P5-022 Keyboard/mouse regression

P5-023 Xbox controller regression

P5-024 PlayStation controller regression

P5-025 Controller disconnect/reconnect

P5-026 Touch control UX pass

P5-027 Android lifecycle testing

P5-028 Android performance pass

P5-029 Android thermal test

P5-030 iOS lifecycle testing

P5-031 iOS performance pass

P5-032 Steam Deck test

P5-033 Desktop resolution matrix

P5-034 UI scale pass

P5-035 Menu controller navigation pass

P5-036 Objective clarity pass

P5-037 Navigation/wayfinding pass

P5-038 Accessibility pass

P5-039 Screen-shake audit

P5-040 Reduced-flash audit

P5-041 Audio mix pass

P5-042 Enemy audio cue pass

P5-043 Visual consistency pass

P5-044 Hazard readability pass

P5-045 Campaign performance profiling

P5-046 Swarm optimization if required

P5-047 Navigation optimization if required

P5-048 Lighting optimization if required

P5-049 Memory/leak testing

P5-050 Build size audit

P5-051 Remove unused assets

P5-052 Third-party licence audit

P5-053 Credits audit

P5-054 Debug-feature production audit

P5-055 External Beta round 1

P5-056 Beta feedback triage

P5-057 External Beta round 2

P5-058 Beta regression pass

P5-059 Clean install/upgrade tests

P5-060 Produce v0.8.0 Beta build
```

---

# 216. Recommended Implementation Sequence

Phase 5 should not simply attack random bugs from an issue tracker.

Use structured passes.

---

## Step 1 — Freeze Scope

Review Phase 4 backlog.

Classify unfinished items:

```text
required for v1
cut
post-launch
```

Remove ambiguous "maybe" work.

---

# 217. Step 2 — Fix P0/P1 Bugs

Before balance or visual polish.

The game must first become trustworthy.

---

# 218. Step 3 — Save/Checkpoint Hardening

Persistence failure is catastrophic.

Complete full campaign save tests.

---

# 219. Step 4 — Soft-Lock Pass

Intentionally break mission order.

Fix sequencing.

---

# 220. Step 5 — Standard Balance Pass

Play entire campaign on Standard.

Tune:

```text
enemy damage
enemy health
ammo
health
checkpoint spacing
```

Use Standard as baseline.

---

# 221. Step 6 — Weapon/Enemy Balance

Tune tactical roles.

Do not adjust mission content and weapon stats simultaneously where avoidable.

---

# 222. Step 7 — Explorer/Survivor

Tune from stable Standard.

---

# 223. Step 8 — Input Pass

Dedicated:

```text
keyboard
controller
touch
```

play sessions.

Do not merely switch inputs for five minutes.

---

# 224. Step 9 — Platform Lifecycle

Desktop alt-tab/suspend.

Android/iOS background/resume.

Controller reconnection.

---

# 225. Step 10 — Performance Pass

Profile campaign mission by mission.

Fix worst cases.

---

# 226. Step 11 — UI/Navigation Pass

Use blind tester data.

Improve environment and prompts.

---

# 227. Step 12 — Accessibility Pass

Systematically test every setting.

---

# 228. Step 13 — Audio/Visual Polish

Only after major gameplay stability.

---

# 229. Step 14 — External Beta Round 1

Small group.

Goal:

```text
find severe unknown issues
```

not marketing.

---

# 230. Step 15 — Triage

Categorize findings.

Fix highest-frequency/highest-severity problems.

---

# 231. Step 16 — External Beta Round 2

Larger and more diverse group.

Focus:

* campaign pacing;
* platform issues;
* accessibility;
* remaining balance.

---

# 232. Step 17 — Regression

Run:

```text
automated suite
campaign smoke
save migration
platform matrix
```

---

# 233. Step 18 — Beta Release

Tag:

```text
v0.8.0
```

No known P0/P1 defects.

---

# 234. Phase 5 Definition of Done — Stability

* [ ] no known blocker bugs;
* [ ] no known critical bugs;
* [ ] no reproducible save corruption;
* [ ] no common campaign soft locks;
* [ ] all missions complete repeatedly;
* [ ] all checkpoints validated;
* [ ] no normal-play crashes on tested platforms;
* [ ] logs substantially clean.

---

# 235. Definition of Done — Save

* [ ] primary save load works;
* [ ] backup recovery works;
* [ ] migration works;
* [ ] corrupted save fails safely;
* [ ] application update preserves saves;
* [ ] mission completion state correct;
* [ ] settings survive application update;
* [ ] save indicator accurate.

---

# 236. Definition of Done — Balance

* [ ] Standard completed by multiple testers;
* [ ] Explorer verified;
* [ ] Survivor verified;
* [ ] ammo economy acceptable;
* [ ] health economy acceptable;
* [ ] no weapon universally dominates;
* [ ] enemy roles remain distinct;
* [ ] boss fight duration acceptable;
* [ ] difficulty spikes addressed.

---

# 237. Definition of Done — Input

* [ ] keyboard/mouse full campaign works;
* [ ] controller full campaign works;
* [ ] controller menu navigation works;
* [ ] controller reconnect works;
* [ ] touch campaign works;
* [ ] touch controls comfortable enough for full mission sessions;
* [ ] input prompts switch correctly;
* [ ] sensitivity/dead-zone settings persist.

---

# 238. Definition of Done — Platform

* [ ] Windows exported build tested;
* [ ] Linux exported build tested;
* [ ] macOS exported build tested;
* [ ] Android real-device build tested;
* [ ] iOS real-device build tested if launch target;
* [ ] Steam Deck tested if launch target;
* [ ] suspend/resume works;
* [ ] app backgrounding safe;
* [ ] common resolutions validated.

---

# 239. Definition of Done — Performance

* [ ] all missions profiled;
* [ ] worst encounters identified;
* [ ] normal gameplay meets target FPS;
* [ ] mobile thermal test completed;
* [ ] memory does not grow uncontrollably;
* [ ] loading acceptable;
* [ ] no severe frame spikes from common spawning/saving.

---

# 240. Definition of Done — UI/UX

* [ ] objectives understandable;
* [ ] menus support all input modes;
* [ ] UI scale tested;
* [ ] resume context clear;
* [ ] death/restart fast;
* [ ] destructive actions confirm;
* [ ] navigation pain points addressed;
* [ ] no important information relies on hover.

---

# 241. Definition of Done — Accessibility

* [ ] screen shake 0–100% works;
* [ ] reduced flashes works;
* [ ] UI scale works;
* [ ] aim assist works;
* [ ] subtitles work if required;
* [ ] colour-independent status indicators;
* [ ] touch sensitivity works;
* [ ] controller sensitivity works;
* [ ] vibration control works if haptics used.

---

# 242. Definition of Done — Audio

* [ ] complete gameplay audio coverage;
* [ ] final-ish mix;
* [ ] enemy attack cues readable;
* [ ] ambience balanced;
* [ ] music transitions correct;
* [ ] volume settings apply correctly;
* [ ] suspend/resume does not duplicate audio;
* [ ] all audio licensing known.

---

# 243. Definition of Done — Art

* [ ] no unidentified placeholders;
* [ ] production direction consistent;
* [ ] player readable;
* [ ] enemy silhouettes readable;
* [ ] hazards readable;
* [ ] projectiles distinguishable;
* [ ] reduced-flash compatible effects;
* [ ] all shipping third-party art licensed.

---

# 244. Definition of Done — Build

* [ ] CI green;
* [ ] clean-machine build works;
* [ ] exported build does not require Godot;
* [ ] debug cheats disabled;
* [ ] build version visible;
* [ ] unused development files excluded where practical;
* [ ] release asset names consistent.

---

# 245. Definition of Done — Legal / Credits

* [ ] third-party asset inventory complete;
* [ ] licence obligations verified;
* [ ] required attribution included;
* [ ] credits screen complete enough for release;
* [ ] no copied Alien Breed content remains;
* [ ] project has independent branding.

---

# 246. Beta Acceptance Scenario

A new external tester should be able to:

```text
download build

↓
install

↓
launch

↓
choose difficulty

↓
complete multiple missions

↓
quit application

↓
resume later

↓
change controller/settings

↓
complete campaign

↓
see ending

↓
see credits
```

without:

```text
developer intervention
save loss
soft lock
unknown mandatory control
critical platform issue
```

---

# 247. Full Campaign Acceptance

At least one Beta build should be completed end-to-end using:

```text
keyboard/mouse
```

and one using:

```text
controller
```

For mobile:

at minimum several full missions should be completed, and preferably the entire campaign once on a representative device.

---

# 248. Beta Performance Acceptance

Normal campaign gameplay must meet target performance on supported reference devices.

One-off stress tests may run below target.

Normal intended gameplay may not.

---

# 249. Beta Bug Threshold

Before Phase 5 exits:

```text
P0: 0
P1: 0
```

P2:

small known list acceptable only with explicit plan.

P3/P4:

can remain for Release Candidate.

---

# 250. Beta Exit Decision

Perform formal review.

## GO

Proceed to Phase 6 if:

* campaign stable;
* P0/P1 zero;
* saves reliable;
* target platforms work;
* balance acceptable;
* performance acceptable;
* external testers can complete game.

---

## HOLD

Remain in Phase 5 if:

* save corruption remains;
* common soft lock exists;
* major mobile issue remains;
* one mission is consistently broken/confusing;
* major performance issue remains.

---

# 251. Do Not Move Bugs Into Phase 6 Just to Hit Schedule

Phase 6 is Release Candidate work.

It should not inherit known foundational Beta problems.

A Release Candidate should be plausibly releasable.

---

# 252. Phase 5 Release

Version:

```text
0.8.0
```

Tag:

```text
v0.8.0
```

Suggested release notes:

```text
Hull Breach v0.8.0 — Beta

This milestone represents the first externally testable,
feature-complete and content-complete build intended for
release hardening.

Includes:

- complete eight-mission campaign
- campaign balancing across Explorer, Standard and Survivor
- hardened save/checkpoint system
- save migration and backup recovery
- campaign soft-lock fixes
- keyboard/mouse hardening
- controller hardening
- touch-control UX pass
- Android lifecycle/performance validation
- iOS validation
- Steam Deck validation where available
- accessibility pass
- UI/UX improvements
- navigation and objective clarity improvements
- audio mix and enemy cue improvements
- visual consistency pass
- campaign-wide performance optimisation
- memory and loading improvements
- complete third-party licensing audit
- Beta build and release infrastructure

Known remaining work should be limited primarily to:
- minor bugs
- final polish
- store integration
- signing/notarisation
- release compliance
- final marketing assets
```

---

# 253. Phase 6 Handoff

Phase 6 becomes:

# Release Candidate

Its purpose is not to improve the fundamental design.

It is to make a specific build releasable.

The expected work becomes:

```text
remaining bugs
store integration
signing
notarisation
release builds
metadata
privacy/legal
final performance verification
final compatibility tests
final screenshots/trailer
```

---

# 254. The Phase 5 Quality Bar

The most useful question is:

> If Hull Breach accidentally went live tomorrow, what would make us regret it?

Phase 5 should systematically remove those things.

Examples:

```text
save corruption
crash
impossible mission
terrible touch controls
unfair checkpoint
broken controller
40 FPS final boss
unreadable UI
unknown asset licence
```

Those matter far more than adding another weapon skin or particle effect.

---

# 255. Phase 5 Core Product Test

The Beta should survive situations such as:

```text
player uses Shotgun in dark corridor

↓
multiple enemies hear it

↓
Hunter flanks

↓
player retreats through powered hazard

↓
switches weapon

↓
takes damage

↓
opens pause menu

↓
controller disconnects

↓
controller reconnects

↓
continues

↓
dies

↓
reloads checkpoint

↓
world state restores correctly

↓
quits application

↓
returns next day

↓
Continue

↓
same mission/objective state restored
```

Nothing about that scenario is exotic.

It is normal product use.

Phase 5 succeeds when the game handles all of it reliably.

---

# 256. Phase 5 Final Principle

Phase 1 was about:

> **feel**

Phase 2 was about:

> **identity**

Phase 3 was about:

> **reuse**

Phase 4 was about:

> **content**

Phase 5 is about:

> **trust**

The player must be able to trust that:

```text
their save will work
their controls will respond
the game will run
the objective can be completed
damage is understandable
difficulty is fair
the game will not lose progress
```

Once Hull Breach is predictable technically while remaining unpredictable tactically, Phase 5 is complete.

The game should now be something you would be comfortable handing to somebody who has never spoken to the developers and simply saying:

> **Play it.**

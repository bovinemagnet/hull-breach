# Hull Breach — Phase 6 Product Requirements and Implementation Plan

**Phase:** 6 — Release Candidate
**Project:** Hull Breach
**Status:** Proposed
**Engine:** Godot 4.7.2 Standard
**Language:** GDScript
**Renderer:** Compatibility
**Depends On:** Phases 0–5 complete
**Target Version:** `0.9.0` → `1.0.0`
**Estimated Effort:** 2–4 focused development weeks
**Primary Deliverable:** A signed, packaged, store-ready release candidate that can be promoted to v1.0 with no code or content changes beyond explicitly approved release fixes

---

# 1. Purpose

Phase 6 converts the stable Beta into a releasable commercial product.

Phase 5 answered:

> Can players trust the game?

Phase 6 must answer:

> Can we ship this exact build?

This phase is about release engineering, compliance, packaging, store readiness, final regression testing, signing, final assets, legal verification and launch preparation.

The mindset changes again.

Phase 6 is not:

```text
make the game better
```

It is:

```text
prove that this build is releasable
```

---

# 2. Release Candidate Definition

A Release Candidate is a build that is expected to become production unless a release-blocking problem is discovered.

That means:

* no planned gameplay features remain;
* no planned campaign content remains;
* no unresolved critical defects remain;
* save/load is stable;
* supported platforms build successfully;
* store packaging is valid;
* legal/licensing review is complete;
* release configuration is correct;
* debug systems are disabled;
* final version information is correct.

A true Release Candidate should be capable of being renamed:

```text
1.0.0
```

without rebuilding gameplay content.

---

# 3. Phase 6 Core Principle

The most important rule is:

> **Every change after RC1 increases release risk.**

Therefore:

```text
RC1
 ↓
test
 ↓
only release-blocking fixes
 ↓
RC2
 ↓
test
 ↓
ship
```

Do not use Release Candidate work as an excuse for:

* a last-minute weapon rebalance;
* a new enemy;
* a redesigned HUD;
* a rewritten save system;
* a larger ending;
* a new mobile control scheme.

Those changes belong in Beta or post-launch.

---

# 4. Phase 6 Goals

Phase 6 must deliver:

* final release configuration;
* release versioning;
* production signing;
* packaging;
* store-ready builds;
* final privacy/legal review;
* final third-party licensing verification;
* final credits;
* final store metadata;
* final icons/artwork;
* final screenshots;
* final trailer;
* release notes;
* clean install testing;
* upgrade testing;
* full regression testing;
* platform compliance testing;
* final save compatibility verification;
* final performance verification;
* Release Candidate build;
* production v1.0 tag.

---

# 5. Non-Goals

Phase 6 must not introduce:

* new missions;
* new enemies;
* new weapons;
* new game modes;
* procedural generation;
* achievements unless already implemented and verified;
* cloud saves unless already implemented;
* multiplayer;
* substantial balance redesign;
* new renderer;
* new save format;
* new UI architecture;
* new campaign structure.

Any requirement appearing now that would significantly alter gameplay should normally be deferred to:

```text
1.1+
```

---

# 6. Release Branch Strategy

Create a release branch only now, if desired:

```text
release/1.0
```

Recommended model:

```text
main
  ↓
release/1.0
  ↓
RC fixes only
  ↓
v1.0.0
```

Meanwhile:

```text
main
```

may either remain frozen or later accept post-launch work after the production tag.

For a small team, an alternative is to continue using `main` with strict freeze.

Either model is valid.

The key requirement is:

> release state must be unambiguous.

---

# 7. Versioning

Suggested sequence:

```text
0.9.0-rc.1
0.9.0-rc.2
0.9.0-rc.3
```

or:

```text
1.0.0-rc.1
1.0.0-rc.2
1.0.0
```

Recommendation:

```text
1.0.0-rc.1
```

because it clearly indicates the candidate is intended to become 1.0.

Final:

```text
1.0.0
```

---

# 8. Build Metadata

Every RC build should expose:

```text
Version: 1.0.0-rc.1
Commit: abc1234
Build Date: YYYY-MM-DD
Channel: Release Candidate
```

Production:

```text
Version: 1.0.0
```

The short Git commit can remain in logs/About.

---

# 9. Release Freeze

At RC1 declare:

```text
CODE FREEZE
CONTENT FREEZE
ASSET FREEZE
LOCALIZATION FREEZE
```

Allowed changes:

```text
P0 blocker
P1 critical
platform rejection
legal/compliance fix
store packaging fix
severe regression
```

Potentially allowed after review:

```text
very low-risk P2 fix
```

Not allowed:

```text
polish because it would be nice
```

---

# 10. Release Blocker Definition

A Release Candidate may not ship with:

* reproducible crash in normal play;
* save corruption;
* campaign soft lock;
* platform startup failure;
* broken purchase/store declaration;
* unsupported OS/package error;
* serious privacy mismatch;
* missing required attribution;
* invalid code signing;
* broken controller on a promised platform;
* severe performance failure on minimum supported hardware;
* incorrect executable/package identity.

---

# 11. Release Checklist Ownership

Create:

```text
docs/release/release_checklist.md
```

This becomes the authoritative release procedure.

Every release candidate should follow the same checklist.

Do not depend on memory.

---

# 12. Release Directory

Recommended documentation:

```text
docs/release/
├── release_checklist.md
├── platform_matrix.md
├── store_metadata.md
├── known_issues.md
├── signing.md
├── versioning.md
└── launch_runbook.md
```

Keep secrets out of documentation.

---

# 13. Production Build Configuration

Create a distinct production configuration.

Production must:

* disable debug menus;
* disable cheats;
* disable verbose development logging;
* disable developer mission select;
* disable debug visualisations;
* disable test input shortcuts;
* use production app identifier;
* use production icons;
* use release signing;
* use final version.

---

# 14. Debug Code Audit

Search codebase for:

```text
OS.is_debug_build()
DEBUG
dev_
cheat
god_mode
teleport
skip_objective
spawn_enemy
unlock_all
```

Verify behaviour.

A debug feature may remain compiled if unreachable and harmless, but preferably exclude or safely gate it.

---

# 15. Developer Scene Audit

Review:

```text
levels/dev/
tests/
tools/
```

Decide what should be excluded from exports.

Do not accidentally package:

* combat stress scenes;
* AI debug maps;
* prototype assets;
* test-only audio;
* internal screenshots.

---

# 16. Export Filters

Configure export exclusions appropriately.

Candidate exclusions:

```text
tests/**
tools/**
docs/**
*.psd
*.kra
*.aseprite
*.blend
raw_audio/**
source_art/**
```

Only if these are not required at runtime.

Do not exclude imported runtime assets accidentally.

---

# 17. Production Logging

Release logging should retain useful errors without flooding output.

Allow:

```text
error
critical warning
version/platform information
```

Avoid:

```text
every enemy state transition
every projectile spawn
every noise event
```

unless behind debug flag.

---

# 18. Release App Identity

Lock final application identity.

Examples:

```text
Display Name:
Hull Breach
```

Package/app identifiers might resemble:

```text
com.yourstudio.hullbreach
```

or appropriate company namespace.

Once released, changing identifiers is disruptive.

---

# 19. Final Product Name Audit

Search project for:

* old working titles;
* `Project Hull Breach`;
* placeholder names;
* Alien Breed references intended only for design discussion.

Final shipped content should consistently use:

```text
Hull Breach
```

or the final legal title chosen.

---

# 20. Intellectual Property Audit

Ensure the game does not ship with copied:

* Alien Breed logos;
* maps;
* sprite art;
* sound;
* distinctive text;
* title branding;
* proprietary level layouts;
* character names.

Inspiration is fine.

Derivative copied assets are not.

---

# 21. Final Third-Party Asset Audit

Every shipping third-party asset must be documented.

Required fields:

```text
asset
creator
source URL
license
license version
required attribution
modifications
shipping path
credits entry
```

No:

```text
unknown
probably CC0
found online
```

entries are acceptable.

---

# 22. Asset License Categories

Group final assets:

```text
CC0
CC BY
MIT/BSD/Apache software
commercially licensed
original
```

Avoid assets with unclear or incompatible obligations.

---

# 23. Attribution Verification

For every attribution-required asset, verify:

* creator spelled correctly;
* asset name correct;
* licence named;
* licence link/information included where required;
* modifications disclosed if necessary.

Credits should not rely solely on web availability after launch.

---

# 24. Godot License Compliance

Include Godot licence information as required.

Common approach:

```text
Credits / Licenses
```

screen or bundled licence text.

Review current Godot licensing obligations at release time.

---

# 25. Test Framework Shipping Audit

Testing addons such as GdUnit4 should generally not be included in production exports unless required.

Verify export filtering.

---

# 26. Privacy Review

Determine actual data behaviour.

If game has:

```text
no accounts
no ads
no analytics
no online multiplayer
no backend
```

document exactly that.

Do not claim:

```text
we collect no data
```

if platform SDKs or analytics do otherwise.

---

# 27. Privacy Policy

Prepare final privacy policy if required by mobile/store channels.

It must reflect actual behaviour.

Possible sections:

```text
Data collected
Third-party services
Local save data
Contact
Children/privacy
Changes
```

Keep it simple if no data collection exists.

---

# 28. Network Audit

If Hull Breach is intended offline:

test with:

```text
airplane mode
no network
blocked DNS
```

Game should function.

No accidental startup dependency on network should exist.

---

# 29. Permissions Audit

Mobile apps should request only required permissions.

Avoid unnecessary access to:

* contacts;
* location;
* microphone;
* photos;
* storage;
* advertising ID.

If no permission is needed, do not request it.

---

# 30. Android Release Requirements

Produce final Android:

```text
AAB
```

with:

* production application ID;
* version code;
* version name;
* release keystore;
* correct orientation;
* correct icon;
* correct target SDK requirements;
* final permissions;
* final signing.

Current store requirements should be rechecked at submission time.

---

# 31. Android Versioning

Use:

```text
version name:
1.0.0
```

and monotonically increasing:

```text
version code
```

Never reuse an uploaded production version code.

---

# 32. Android Signing

Production keystore must:

* be backed up securely;
* not be committed;
* have recovery/documentation strategy;
* have password stored securely.

Losing signing identity can make future updates difficult or impossible depending on distribution setup.

---

# 33. Android Update Test

Install Beta build.

Create save.

Install RC over Beta.

Verify:

```text
app updates
save retained
settings retained
campaign resumes
```

Then test RC → production if separate package build is used.

---

# 34. Android Fresh Install Test

On clean device:

```text
install
launch
start new game
background
resume
quit
continue
uninstall
```

Record expected save behaviour.

---

# 35. Android Store Listing Inputs

Prepare:

* app name;
* short description;
* long description;
* category;
* content rating answers;
* privacy declarations;
* screenshots;
* phone graphics;
* tablet graphics if required;
* feature graphics;
* icon.

---

# 36. iOS Release Requirements

Produce final Xcode/App Store build with:

* production bundle identifier;
* version;
* build number;
* signing;
* provisioning;
* icons;
* launch behaviour;
* orientations;
* privacy declarations.

---

# 37. iOS Build Number

Each upload requires monotonically increasing build number.

Example:

```text
Version:
1.0.0

Build:
100
101
102
```

---

# 38. iOS Signing

Verify:

* distribution certificate;
* provisioning;
* App Store Connect team;
* bundle ID;
* capabilities;
* production entitlements.

Do not store private signing keys in repository.

---

# 39. TestFlight Final Validation

Before production submission:

upload RC to TestFlight.

Test:

* install;
* launch;
* New Game;
* Continue;
* controller;
* touch;
* background/resume;
* save;
* mission transition;
* purchase/network absence if relevant.

Use the actual submitted-style build.

---

# 40. iOS Safe Area Final Pass

Validate on:

* notched device;
* Dynamic Island-style device where relevant;
* older rectangular device.

No critical button or HUD element may overlap system UI.

---

# 41. Windows Release Build

Prepare:

```text
HullBreach.exe
```

plus required `.pck`/embedded package depending export configuration.

Recommended distribution:

```text
ZIP
```

or store installer.

Test on clean Windows machine without Godot installed.

---

# 42. Windows Code Signing

Code signing is recommended if distributing outside trusted store channels.

It can reduce SmartScreen concerns over time.

If not available at v1, document the decision.

---

# 43. Windows Compatibility

Test:

* supported Windows versions;
* high DPI;
* different controllers;
* no admin permissions;
* non-English username/path if possible.

Game must not assume writable install directory.

Use:

```text
user://
```

for saves/settings.

---

# 44. Linux Release

Produce x86_64 build unless other architectures are explicitly supported.

Test:

* launch;
* audio;
* controller;
* fullscreen;
* save path;
* executable permission.

Distribution:

```text
tar.gz
```

or platform/store package.

---

# 45. Steam Deck Release Validation

If Steam is a target:

test production-style Linux/Steam build at:

```text
1280×800
```

Verify:

* gamepad-only operation;
* text readability;
* resume;
* performance;
* virtual keyboard only if text entry exists.

---

# 46. macOS Release

Prepare:

```text
.app
```

with:

* correct bundle ID;
* icon;
* signing;
* notarization if required;
* version;
* entitlements.

Test on clean macOS environment.

---

# 47. macOS Notarization

If distributing outside Mac App Store, notarization may be required for smooth user experience.

Document exact release process without storing credentials in repo.

---

# 48. Universal vs Architecture-Specific macOS Build

Decide whether to ship:

```text
Universal
```

or separate architectures based on Godot export support and build-size requirements.

Test actual target hardware.

---

# 49. Store Strategy

Potential initial stores:

```text
Steam
itch.io
Google Play
Apple App Store
```

Potential later:

```text
GOG
Epic Games Store
console stores
```

Do not expand platforms in Phase 6 unless already planned/tested.

---

# 50. Steam Release Preparation

If Steam is a launch platform, prepare:

* App ID;
* depots;
* branches;
* launch options;
* store page;
* capsule artwork;
* screenshots;
* trailer;
* controller description;
* system requirements;
* cloud-save decision;
* achievements decision.

---

# 51. Steam Cloud

If not already implemented and tested:

do not add Steam Cloud at the last minute.

Local saves are acceptable for v1.

Cloud save can be a post-launch feature.

---

# 52. Achievements

Same policy.

If achievements were not already implemented in Beta:

defer to post-launch.

Do not add platform SDK integration during RC without a compelling reason.

---

# 53. Steam Input

If using native gamepad handling through Godot, verify Steam Input compatibility.

Test:

* Xbox;
* PlayStation;
* Steam Deck.

Avoid contradictory double-remapping.

---

# 54. Steam Launch Options

Ensure executable and launch configuration point to final build.

Test launch through Steam client, not only direct executable.

---

# 55. itch.io

If distributing via itch.io:

prepare platform archives and metadata.

Potentially use:

```text
butler
```

for upload if desired.

Do not make itch-specific build architecture unless needed.

---

# 56. App Store Product Description

Prepare concise final description.

It should describe Hull Breach as its own game.

Suggested positioning:

```text
A tense top-down sci-fi survival shooter where every gunshot can attract something worse.
```

Avoid marketing it as:

```text
an Alien Breed clone
```

in store metadata.

---

# 57. Store Feature Bullets

Potential:

```text
Explore claustrophobic research facilities
Fight using twin-stick combat
Use sound and lighting tactically
Restore and manipulate facility systems
Manage limited ammunition and health
Face enemies with distinct hunting behaviours
Play on desktop or mobile
```

Only claim features actually present.

---

# 58. Final System Requirements

Determine based on actual Beta test hardware.

Do not invent minimum specifications.

Record:

```text
CPU
RAM
GPU/API
storage
OS
controller
```

for desktop stores.

---

# 59. Recommended Requirements

Also derive from tested hardware.

Keep realistic.

A 2D game should not advertise unnecessarily high hardware requirements due to developer workstation assumptions.

---

# 60. Storage Requirement

Measure actual installed size.

Store listing should include reasonable margin.

Example:

```text
Actual: 1.2 GB
Requirement: 2 GB available
```

not an unmeasured guess.

---

# 61. Final Build Size Audit

Before RC:

remove unused:

* source art;
* raw WAVs;
* prototype maps;
* duplicate assets;
* unused third-party packs;
* development logs;
* screenshots.

Compare Alpha vs RC size.

---

# 62. Asset Compression

Review runtime formats.

Music/ambience should use appropriate compressed format.

Short SFX may remain higher-quality if size is acceptable.

Avoid destructive compression solely to minimize download size.

---

# 63. Final Performance Matrix

Create final document:

```text
docs/release/platform_matrix.md
```

For every supported platform record:

```text
device/hardware
OS
resolution
FPS target
observed FPS
controller/touch
status
```

---

# 64. Minimum Hardware Validation

Test actual minimum/reference hardware.

No platform should be marketed as supported based solely on theoretical Godot requirements.

---

# 65. Final Campaign Performance Pass

Run through worst known areas:

```text
M03 Swarm encounter
M04 Stalker dark sector
M06 Reactor climax
M07 Brood Entity
M08 final evacuation
```

These are likely performance hotspots.

---

# 66. Final Memory Test

Run full campaign or multiple mission transitions.

Check:

```text
memory at startup
memory after M2
memory after M5
memory after M8
memory after return to menu
```

Look for sustained growth unrelated to loaded content.

---

# 67. Final Thermal Test

Mobile:

play a long session on production-style build.

Verify:

* no catastrophic thermal throttling;
* battery use acceptable;
* touch remains responsive.

---

# 68. Final Loading Test

Measure:

```text
cold startup
main menu → mission
checkpoint restart
mission transition
```

No significant regression from Beta.

---

# 69. Save Compatibility Freeze

Once RC1 exists:

freeze save schema if at all possible.

Any save schema change after RC1 requires:

* migration;
* automated test;
* Beta/RC upgrade test.

Avoid it unless release blocking.

---

# 70. Final Save Test Matrix

Test:

### Fresh Save

```text
new install
→ New Game
→ save
→ continue
```

### Beta Upgrade

```text
0.8 save
→ 1.0 RC
→ migrate
```

### RC Upgrade

```text
RC1 save
→ RC2
```

### Corruption

```text
damaged primary
→ backup recovery
```

### Missing Save

```text
no save
→ Continue disabled/handled correctly
```

---

# 71. Final Campaign Regression

For RC:

complete campaign at least once from:

```text
New Game
```

to:

```text
Credits
```

using the release build.

Not editor.

---

# 72. Full Release-Build Playthrough

This is mandatory.

An editor playthrough is insufficient because exports can differ in:

* resources;
* file paths;
* debug flags;
* platform APIs;
* asset inclusion;
* signing/package behaviour.

---

# 73. Input Final Pass

Complete at least significant play sessions with:

```text
keyboard/mouse
controller
touch
```

Production build only.

---

# 74. Controller-Only Launch Test

Test:

```text
launch game
→ start New Game
→ change settings
→ play
→ quit
```

without touching mouse/keyboard.

---

# 75. Touch-Only Launch Test

On mobile:

```text
install
→ launch
→ New Game
→ settings
→ mission
→ pause
→ resume
```

without external controller.

---

# 76. Accessibility Final Pass

Every accessibility setting must be tested in production build.

Checklist:

* screen shake 0%;
* screen shake 100%;
* reduced flashes;
* large UI;
* aim assist;
* subtitles;
* vibration off;
* controller sensitivity;
* touch sensitivity.

---

# 77. Accessibility Persistence

Change settings.

Quit application.

Relaunch.

Verify settings remain.

---

# 78. Reduced Flash Audit

Replay:

* alarms;
* explosions;
* power activation;
* reactor critical;
* boss;
* evacuation.

Ensure reduced-flash mode affects all relevant effects.

---

# 79. Screen Shake Audit

Search code for camera shake triggers.

Verify each goes through common configurable mechanism.

No direct hidden shake.

---

# 80. Audio Final Mix

Perform mix using release build.

Test:

* headphones;
* laptop speakers;
* phone speaker;
* TV/monitor speakers if likely.

Critical enemy cues must remain audible.

---

# 81. Final Audio Normalisation

Avoid:

* clipping;
* wildly different weapon loudness;
* UI sounds louder than combat;
* dialogue buried under music.

Use consistent loudness approach where practical.

---

# 82. Mute Behaviour

At:

```text
Master Volume = 0
```

game should be silent.

No rogue audio player should bypass the bus.

---

# 83. Music Volume

At:

```text
Music = 0
```

ambience/SFX remain.

At:

```text
SFX = 0
```

music remains.

Verify bus routing.

---

# 84. Credits Finalization

Credits should include:

```text
Game Development
Art
Audio
Music
Testing
Special Thanks
Open Source Software
Third-Party Assets
Licenses
```

Do not forget external testers if promised/appropriate.

---

# 85. Legal Text

Include:

* copyright;
* trademark notices where appropriate;
* third-party licences;
* privacy information location.

Avoid unnecessary legal clutter in primary gameplay UI.

---

# 86. Copyright Notice

Example:

```text
© 2026 <Studio/Developer>. All rights reserved.
```

Use actual rights holder.

Do not invent entity names in production.

---

# 87. Final Logo

Lock:

```text
Hull Breach
```

logo and icon.

Ensure:

* readable at small sizes;
* works in square/mobile icon;
* works on store capsule;
* does not resemble Alien Breed branding too closely.

---

# 88. Game Icon

Prepare platform-specific variants.

Test at:

```text
16×16
32×32
64×64
128×128
512×512
```

or required platform sizes.

The icon should remain recognizable when tiny.

---

# 89. Splash Screen

Optional.

If used:

```text
studio logo
→ title
```

Keep fast.

Do not make players sit through long unskippable splash sequences.

---

# 90. Startup Time

Target:

```text
launch
→ interactive menu
```

as quickly as practical.

A small 2D game should not feel heavy.

---

# 91. Store Screenshots

Capture actual gameplay from release candidate.

Recommended set:

1. dark corridor / flashlight;
2. combat with multiple enemy types;
3. power restoration;
4. Hive environment;
5. mobile or UI shot if store appropriate;
6. boss/finale without major spoiler.

Do not heavily mock up screenshots beyond store policy.

---

# 92. Screenshot Quality

Capture:

* native high resolution;
* no debug overlay;
* no placeholder text;
* no development watermark;
* no unlicensed temporary asset.

---

# 93. Trailer

Target:

```text
45–90 seconds
```

Potential structure:

```text
0–10 sec:
atmosphere

10–30:
combat

30–50:
systems / power / darkness / noise

50–70:
enemy variety / Hive

final:
title + platforms
```

Do not overpromise content not in game.

---

# 94. Trailer Build

Capture using RC or a code-identical build.

Avoid footage from obsolete mechanics.

---

# 95. Store Description Accuracy

Review every claim against production build.

If store says:

```text
dynamic enemy AI reacts to sound
```

ensure that is consistently true.

If store says:

```text
five weapons
```

ship five.

---

# 96. Content Rating

Complete platform rating questionnaires based on actual final content.

Review:

* blood;
* gore;
* horror;
* language;
* weapons;
* online interaction;
* purchases.

Do not guess age rating.

Use platform process.

---

# 97. Store Policy Check

Before submission, recheck current:

* Google Play requirements;
* Apple App Store requirements;
* Steam requirements;
* macOS notarization requirements.

These change over time.

This is a release-time verification task.

---

# 98. Crash-Free Target

RC should have:

```text
0 known reproducible crashes in normal gameplay
```

Rare hardware-specific crash may require explicit assessment.

No crash should be dismissed as:

```text
probably fine
```

without investigation.

---

# 99. Known Issues Document

Create:

```text
docs/release/known_issues.md
```

Remaining issues should be:

* low severity;
* understood;
* non-blocking.

Do not hide serious defects by listing them as known.

---

# 100. Known Issue Example

Acceptable:

```text
On some ultrawide monitors, decorative background may expose additional black margin.
Gameplay unaffected.
```

Not acceptable:

```text
Mission 6 sometimes cannot be completed after reloading.
```

---

# 101. Release Candidate Test Passes

Every RC should go through:

```text
automated
platform smoke
save/load
campaign progression
input
performance hotspot
legal/package
```

Do not run a subset because change was "small."

---

# 102. Automated RC Gate

CI must pass:

* unit tests;
* integration tests;
* save tests;
* migrations;
* content validation;
* mission smoke tests;
* campaign progression;
* release export.

---

# 103. Release Build CI

Use a manually triggered protected release workflow.

Inputs may include:

```text
version
platform set
release channel
```

Avoid arbitrary build scripts on developer machines becoming the only release path.

---

# 104. Release Workflow Security

Release workflow secrets:

```text
signing credentials
store tokens
notarization credentials
```

must be protected.

Restrict who can run production publish actions.

---

# 105. Build vs Publish Separation

Prefer:

```text
build
→ test
→ review
→ publish
```

not:

```text
push tag
→ instantly release everywhere
```

for v1.

Manual approval before publish reduces risk.

---

# 106. Artifact Checksums

Optional but useful:

generate checksums for direct-download builds.

Example:

```text
SHA-256
```

Useful for integrity verification.

---

# 107. Release Artifact Archive

Store final release artifacts in a durable release location.

Keep:

* source tag;
* build logs;
* checksums;
* signed packages;
* release notes.

Do not rely only on local machine.

---

# 108. Rebuild Ability

Ensure source tag:

```text
v1.0.0
```

plus documented toolchain can reproduce the logical release.

Signing timestamps may differ, but build inputs should be known.

---

# 109. Godot Version Freeze

Do not upgrade Godot during Phase 6 unless required to fix a release blocker.

A late engine upgrade creates large regression risk.

If an engine security/platform fix is mandatory:

* dedicated PR;
* full regression;
* new RC.

---

# 110. Dependency Freeze

Likewise freeze addons.

Do not update GdUnit, plugins, or tools just because a new version exists.

Only release-relevant changes.

---

# 111. Asset Freeze

Do not replace assets after RC1 unless:

* legal problem;
* critical visual issue;
* missing asset;
* release blocker.

Every changed asset can affect import/export.

---

# 112. Balance Freeze

After RC1:

no balance changes unless:

* encounter impossible;
* major exploit;
* severe unfairness.

Normal preference feedback waits for 1.0.x/1.1.

---

# 113. Localization Freeze

If shipping localized text:

freeze strings before RC.

Any string change requires translation update.

If English-only v1:

ensure UI is still localization-ready for later.

---

# 114. Final Tutorial Verification

Install fresh profile and play Mission 1.

Verify:

* correct prompts;
* correct input glyphs;
* no developer assumptions;
* no stale text.

---

# 115. Final Continue Verification

Use old Beta save.

Upgrade.

Launch.

Select:

```text
Continue
```

Verify correct mission/objective.

This is one of the most realistic production scenarios.

---

# 116. Final New Game Verification

With existing save:

select:

```text
New Game
```

Confirm destructive action.

Ensure previous campaign handling matches intended design.

---

# 117. Multiple Save Slots

If supporting multiple slots:

test:

* create;
* overwrite;
* delete;
* switch;
* corrupted one slot does not destroy others.

---

# 118. Final Difficulty Verification

Start all three modes.

Verify difficulty name persists and correct multipliers apply.

Do not perform major tuning.

---

# 119. Final Boss Verification

Complete boss from checkpoint on:

* Explorer;
* Standard;
* Survivor.

Ensure no last-minute difficulty-specific bug.

---

# 120. Final Mission Verification

Mission 8 is especially important.

Test:

* start from previous mission transition;
* start from mission checkpoint;
* complete;
* ending;
* credits;
* post-credits state.

---

# 121. Post-Campaign State

Decide final behaviour.

Options:

```text
return to main menu
unlock mission select
allow replay
```

Document and test.

Do not leave player in undefined state after credits.

---

# 122. Credits Exit

Credits should be:

* skippable after reasonable input;
* controller/touch compatible;
* return safely to menu.

---

# 123. Final Menu State

After completing campaign:

```text
Continue
```

should have intentional meaning.

Potential:

```text
replay final checkpoint
```

or:

```text
disabled / mission select
```

Choose and test.

---

# 124. Production Error UX

No raw stack trace or Godot error should be the expected user experience.

Recoverable errors should display understandable message.

Fatal errors should still log useful diagnostics.

---

# 125. Missing Save UX

If Continue selected with no valid save due to edge case:

handle safely.

No null-reference crash.

---

# 126. Missing Controller UX

Game should remain usable with another supported input.

No startup blocker because expected controller absent.

---

# 127. Low Storage Handling

Mobile save files are small, but consider write failure.

If save fails:

* log;
* show warning;
* do not pretend save succeeded.

---

# 128. Save Indicator Accuracy

Only show:

```text
SAVED
```

after successful write.

Not before.

---

# 129. Final Resume Testing

Mobile:

background during:

* normal gameplay;
* pause;
* mission transition;
* death screen.

Resume safely.

---

# 130. Final Alt-Tab Testing

Desktop:

alt-tab during:

* combat;
* pause;
* fullscreen;
* loading.

Verify cursor/audio state.

---

# 131. Final Fullscreen Testing

Change:

```text
windowed
→ fullscreen
→ windowed
```

Aim remains correct.

UI remains positioned.

---

# 132. Final Resolution Change Test

Change resolution mid-session.

Verify:

* mouse world position;
* crosshair;
* HUD;
* touch unaffected on mobile.

---

# 133. Final Controller Hot-Plug Test

Start keyboard.

Connect controller.

Use controller.

Disconnect.

Return keyboard.

No stuck movement.

---

# 134. Final Input Rebind Test

If remapping exists:

bind unusual keys.

Restart game.

Verify persistence.

Reset defaults.

---

# 135. Final Audio Device Change Test

Where practical:

switch:

```text
speakers
→ headphones
```

or Bluetooth on mobile.

Game should recover without restart if platform supports it.

---

# 136. Final Performance Hotspot Gate

Each known hotspot must meet release requirement.

Example:

```text
M03 swarm bay
M07 boss
M08 evacuation
```

If one still fails:

fix before release or reduce supported hardware claim.

---

# 137. Final Mobile Quality Defaults

Choose final defaults based on tested devices.

Do not default to high effects if common phones overheat.

Safe defaults improve first impression.

---

# 138. Final Desktop Defaults

Recommended:

```text
VSync on
native/current display resolution
reasonable UI scale
screen shake moderate
```

Actual choice based on testing.

---

# 139. Final Accessibility Defaults

Potential:

```text
subtitles on
screen shake 70%
reduced flashes off
aim assist controller/touch moderate
```

Choose intentionally.

---

# 140. Final Save Location Documentation

Support docs should know where saves live.

Useful for debugging/support.

Do not expose complex filesystem instructions in normal game UI.

---

# 141. Support Contact

Store page and About/Credits should provide support route.

Could be:

```text
support email
website
issue form
```

Use actual final details.

---

# 142. Support Build Information

Support requests should ask for:

```text
version
platform
mission
save/checkpoint
```

Build version must be easy to find.

---

# 143. Release Notes

Prepare v1.0 notes.

Do not write giant development changelog.

Focus on product.

Example:

```text
Hull Breach 1.0

- Eight-mission sci-fi campaign
- Twin-stick combat
- Sound-reactive enemies
- Dynamic power and lighting systems
- Five weapons
- Seven enemy archetypes
- Three difficulty modes
- Controller and touch support
```

Only list final features.

---

# 144. Changelog

Maintain internal detailed changelog if useful.

Public release notes can be concise.

---

# 145. Launch Runbook

Create:

```text
docs/release/launch_runbook.md
```

Include:

```text
final tag
build workflow
artifact verification
store upload
store submission
publication order
rollback process
support monitoring
```

---

# 146. Rollback Plan

Before launch, know what happens if severe issue discovered.

Potential options:

* pause release;
* revert store build;
* publish hotfix;
* disable problematic platform release.

Do not invent response during crisis.

---

# 147. Hotfix Branch Strategy

After v1.0:

```text
hotfix/1.0.1
```

for release blockers.

Keep fixes minimal.

---

# 148. First Patch Version

Reserve:

```text
1.0.1
```

for immediate post-launch fixes.

Do not mix major feature additions into it.

---

# 149. Launch Order

Consider staggered launch if operationally useful.

Example:

```text
Steam/desktop
→ mobile
```

or simultaneous.

This is a product/business decision.

Technically, all advertised launch platforms must be ready.

---

# 150. Store Review Timing

Apple/Google review times can vary.

Submission should account for platform approval process.

Do not promise an exact public launch date without factoring approval uncertainty.

---

# 151. Pre-Launch Internal Sign-Off

Before publishing, explicitly sign off:

```text
Gameplay
Engineering
QA
Art
Audio
Legal/licensing
Platform builds
Store metadata
```

For solo development, this is still useful as a checklist of hats.

---

# 152. Release Candidate Review Meeting

Questions:

### Stability

Any P0/P1?

### Saves

Any migration risk?

### Performance

Any platform below minimum?

### Input

All advertised methods work?

### Legal

All licences accounted for?

### Store

All metadata ready?

### Build

Is RC reproducible?

### Product

Would we be comfortable if this became 1.0 unchanged?

If yes:

ship.

---

# 153. RC1 Definition of Done

* [ ] production configuration complete;
* [ ] version correct;
* [ ] release exports generated;
* [ ] signing works;
* [ ] store identifiers correct;
* [ ] debug features disabled;
* [ ] licensing audit complete;
* [ ] credits complete;
* [ ] campaign regression pass;
* [ ] save migration pass;
* [ ] input pass;
* [ ] performance hotspot pass;
* [ ] accessibility pass;
* [ ] clean install pass;
* [ ] upgrade pass.

---

# 154. RC2 Rule

Create RC2 only if RC1 requires changes.

Do not create a new RC simply because time passed.

Every RC requires complete release gate again.

---

# 155. Release Candidate Bug Threshold

For final RC:

```text
P0 = 0
P1 = 0
```

P2 should be:

```text
0 or explicitly accepted
```

Remaining issues should not materially affect normal play.

---

# 156. Accepted Known Issue Criteria

A known issue can ship only if:

* low severity;
* workaround exists or impact negligible;
* no data loss;
* no mission blocker;
* no platform rejection;
* no major accessibility issue.

---

# 157. Final Release Build

Once RC approved:

produce final:

```text
1.0.0
```

Ideally from exact same commit as final RC, changing only release metadata if required.

Best case:

```text
RC commit == production commit
```

---

# 158. Production Tag

Create:

```text
v1.0.0
```

Tag should be immutable in practice.

Never move a published release tag to another commit.

---

# 159. Production Artifact Verification

Before upload:

verify:

```text
filename
version
checksum
signing
startup
save
platform ID
```

for every artifact.

---

# 160. Windows Production Artifact

Example:

```text
hull-breach-1.0.0-windows-x86_64.zip
```

Verify executable properties/version metadata.

---

# 161. Linux Production Artifact

Example:

```text
hull-breach-1.0.0-linux-x86_64.tar.gz
```

Verify executable flag survives packaging.

---

# 162. macOS Production Artifact

Example:

```text
HullBreach-1.0.0-macos.zip
```

Verify signing/notarization.

---

# 163. Android Production Artifact

Example:

```text
hull-breach-1.0.0.aab
```

Verify signed release variant.

---

# 164. iOS Production Artifact

Upload through production App Store workflow.

Verify exact build selected.

---

# 165. Final Installation Verification

Install the exact production artifact that will be distributed.

Do not rely on equivalent local build.

Smoke test:

```text
launch
New Game
save
Continue
mission transition
settings
quit
```

---

# 166. Final Steam Verification

Use release branch/depot through Steam client.

Test:

```text
install
launch
controller
save
update
uninstall
```

before public release.

---

# 167. Final Mobile Store Verification

Use internal/closed release track where available.

Install from store infrastructure rather than local sideload only.

This catches package/store differences.

---

# 168. Release Day Monitoring

After launch, monitor:

* crash reports if available;
* support messages;
* store reviews;
* save issues;
* platform-specific failures.

Do not immediately respond to every balance opinion with a patch.

Prioritize:

```text
crash
save
progression
platform
```

---

# 169. Hotfix Threshold

Immediate patch if:

* common crash;
* data loss;
* campaign blocker;
* severe platform failure.

Not immediate patch for:

* weapon slightly too weak;
* cosmetic issue;
* preference feedback.

---

# 170. Day-One Patch Philosophy

Ideally:

```text
none
```

The purpose of RC is to avoid needing a day-one patch.

But if necessary, keep it focused.

---

# 171. Post-Launch Backlog

Move deferred feature ideas to:

```text
post-launch
```

Examples:

* achievements;
* Steam Cloud;
* challenge maps;
* survival mode;
* new campaign;
* new weapons;
* local co-op.

Do not mix them with 1.0 hotfixes.

---

# 172. Final Phase 6 Backlog

Suggested major issues:

```text
P6-001 Declare release freeze

P6-002 Create release/1.0 branch

P6-003 Final production configuration

P6-004 Final app/package identifiers

P6-005 Production versioning

P6-006 Debug cheat audit

P6-007 Export exclusion audit

P6-008 Final third-party asset audit

P6-009 Final license/credits audit

P6-010 Final privacy review

P6-011 Final permissions audit

P6-012 Android release signing

P6-013 Android AAB production validation

P6-014 Android update-from-Beta test

P6-015 iOS production signing

P6-016 TestFlight RC validation

P6-017 Windows release package

P6-018 Windows clean-machine test

P6-019 Linux release package

P6-020 Linux clean-machine test

P6-021 macOS signing/notarization

P6-022 Steam release branch/depot validation

P6-023 Steam Deck production validation

P6-024 Final platform requirements

P6-025 Final build-size cleanup

P6-026 Final save migration freeze

P6-027 Final save compatibility matrix

P6-028 Full release-build campaign playthrough

P6-029 Final controller-only test

P6-030 Final touch-only test

P6-031 Final accessibility test

P6-032 Final performance hotspot test

P6-033 Final mobile thermal test

P6-034 Final memory regression

P6-035 Final audio mix verification

P6-036 Final visual consistency check

P6-037 Final tutorial pass

P6-038 Final credits pass

P6-039 Final store screenshots

P6-040 Final trailer

P6-041 Final store descriptions

P6-042 Content rating submissions

P6-043 Final privacy/store declarations

P6-044 Create RC1

P6-045 RC1 regression

P6-046 Fix release blockers

P6-047 Create RC2 if necessary

P6-048 Final release sign-off

P6-049 Build v1.0.0

P6-050 Tag v1.0.0

P6-051 Upload production artifacts

P6-052 Publish release notes

P6-053 Launch monitoring
```

---

# 173. Recommended Implementation Sequence

Phase 6 should follow a rigid sequence.

---

## Step 1 — Freeze

Stop normal development.

Classify every remaining issue:

```text
ship blocker
post-launch
won't fix
```

---

# 174. Step 2 — Final Legal and Asset Audit

Do this early.

A licensing surprise at the end can force asset replacement and regression.

---

# 175. Step 3 — Production Build Configuration

Set:

```text
IDs
icons
versioning
debug flags
release settings
```

---

# 176. Step 4 — Signing

Make every platform capable of producing signed production-like packages.

Do not postpone signing until final day.

---

# 177. Step 5 — Store Package Validation

Upload internal builds where possible.

Validate actual store pipeline.

---

# 178. Step 6 — Full Release Campaign Test

Complete the full campaign using production configuration.

This is the central RC test.

---

# 179. Step 7 — Save Upgrade Test

Upgrade from public/latest Beta.

Verify migration.

---

# 180. Step 8 — Platform Matrix

Run final:

```text
Windows
Linux
macOS
Android
iOS
Steam Deck
```

as applicable.

---

# 181. Step 9 — Accessibility/Input

Dedicated final pass.

---

# 182. Step 10 — Store Assets

Capture final screenshots/video only after game is visually frozen.

---

# 183. Step 11 — RC1

Create:

```text
v1.0.0-rc.1
```

Distribute internally/closed Beta.

---

# 184. Step 12 — RC1 Observation

Do not immediately change things.

Allow testing to reveal release blockers.

---

# 185. Step 13 — Fix Only Blockers

Every code change must answer:

> Why is this worth invalidating the Release Candidate?

If answer is weak:

defer.

---

# 186. Step 14 — RC2

Only if necessary.

Repeat complete release gate.

---

# 187. Step 15 — Final Sign-Off

Approve exact commit/build.

---

# 188. Step 16 — Production

Tag:

```text
v1.0.0
```

Build/upload/publish.

---

# 189. Phase 6 Definition of Done — Engineering

* [ ] code/content freeze active;
* [ ] production configuration correct;
* [ ] debug cheats disabled;
* [ ] CI green;
* [ ] full campaign release-build playthrough complete;
* [ ] no P0/P1;
* [ ] save migration stable;
* [ ] final build reproducible;
* [ ] production tag created.

---

# 190. Definition of Done — Windows

* [ ] production export works;
* [ ] clean install/extract works;
* [ ] save works;
* [ ] controller works;
* [ ] fullscreen/resolution works;
* [ ] final packaging complete;
* [ ] signing decision implemented.

---

# 191. Definition of Done — Linux

* [ ] production export works;
* [ ] executable permissions correct;
* [ ] audio works;
* [ ] controller works;
* [ ] save works;
* [ ] package tested cleanly.

---

# 192. Definition of Done — macOS

* [ ] production build works;
* [ ] correct bundle ID;
* [ ] signing works;
* [ ] notarization works if required;
* [ ] Retina/UI scaling tested;
* [ ] save works;
* [ ] controller works.

---

# 193. Definition of Done — Android

* [ ] production AAB generated;
* [ ] production signing works;
* [ ] version code correct;
* [ ] version name correct;
* [ ] app ID final;
* [ ] permissions correct;
* [ ] internal store install tested;
* [ ] Beta upgrade tested;
* [ ] saves preserved;
* [ ] lifecycle verified.

---

# 194. Definition of Done — iOS

* [ ] production bundle ID final;
* [ ] signing/provisioning correct;
* [ ] version/build correct;
* [ ] TestFlight RC installed;
* [ ] safe areas validated;
* [ ] save works;
* [ ] lifecycle works;
* [ ] touch works;
* [ ] controller works.

---

# 195. Definition of Done — Store

* [ ] title final;
* [ ] descriptions final;
* [ ] screenshots final;
* [ ] trailer final;
* [ ] icons final;
* [ ] system requirements final;
* [ ] content ratings complete;
* [ ] privacy declarations complete;
* [ ] support contact correct.

---

# 196. Definition of Done — Legal

* [ ] all shipping assets accounted for;
* [ ] all licence obligations met;
* [ ] credits accurate;
* [ ] Godot licence obligations met;
* [ ] privacy policy matches product;
* [ ] no copied third-party proprietary content remains.

---

# 197. Definition of Done — Save

* [ ] fresh save works;
* [ ] Beta migration works;
* [ ] backup recovery works;
* [ ] corrupted save handled safely;
* [ ] final schema frozen;
* [ ] mission progress stable;
* [ ] ending state stable.

---

# 198. Definition of Done — Performance

* [ ] final hotspot pass completed;
* [ ] minimum/reference hardware tested;
* [ ] mobile thermal test passed;
* [ ] no catastrophic frame spikes;
* [ ] loading acceptable;
* [ ] memory stable across campaign.

---

# 199. Definition of Done — Accessibility

* [ ] final settings all work;
* [ ] all settings persist;
* [ ] reduced-flash audit complete;
* [ ] screen-shake audit complete;
* [ ] UI scale verified;
* [ ] colour-independent indicators verified;
* [ ] subtitles verified if applicable.

---

# 200. Definition of Done — Input

* [ ] keyboard/mouse production build verified;
* [ ] controller-only production flow verified;
* [ ] touch-only production flow verified;
* [ ] hot-plug verified;
* [ ] resume verified;
* [ ] input prompts correct.

---

# 201. Release Candidate Acceptance Scenario

The final RC must survive:

```text
clean device/machine
    ↓
install
    ↓
launch
    ↓
New Game
    ↓
play campaign
    ↓
save
    ↓
quit
    ↓
update from prior build
    ↓
Continue
    ↓
complete campaign
    ↓
ending
    ↓
credits
    ↓
return to menu
```

while also tolerating:

```text
controller disconnect
background/resume
fullscreen change
settings change
player death
checkpoint reload
```

without data loss or campaign corruption.

---

# 202. Final Ship Decision

Before launch, answer:

### Stability

Would we trust a player's only save to this build?

### Progression

Can every mission complete reliably?

### Platforms

Does every advertised platform actually work?

### Input

Can each advertised input method operate the whole game?

### Performance

Do stated requirements match reality?

### Accessibility

Do promised settings work?

### Legal

Can every shipping asset be accounted for?

### Store

Are all product claims accurate?

### Build

Can we reproduce and identify this release?

If every answer is yes:

```text
SHIP
```

---

# 203. Phase 6 Release

Final version:

```text
1.0.0
```

Tag:

```text
v1.0.0
```

Suggested public release notes:

```text
Hull Breach 1.0

Hull Breach is now available.

Explore eight hostile sci-fi facilities in a top-down survival shooter where combat has consequences.

Features:

- Eight-mission single-player campaign
- Twin-stick keyboard/mouse, controller and touch combat
- Enemies that react to weapon noise
- Dynamic power, lighting and environmental systems
- Multiple distinct alien behaviours
- Five tactical weapon types
- Environmental hazards and access systems
- Explorer, Standard and Survivor difficulty modes
- Persistent checkpoints and campaign saves
- Desktop and mobile support
```

Adjust final feature count to the actual shipped roster.

---

# 204. Immediate Post-Launch Handoff

After 1.0, development enters:

# Phase 7 — Post-Launch

Initial priorities should be:

```text
monitor
triage
hotfix
stabilise
```

not:

```text
immediately build expansion
```

Wait until actual player behaviour is understood.

---

# 205. Recommended First Post-Launch Window

Focus on:

* P0/P1 reports;
* save issues;
* platform-specific failures;
* store issues;
* controller/mobile problems.

Balance feedback can be collected before acting.

---

# 206. Phase 6 Core Quality Bar

A successful RC should feel boring from an engineering perspective.

There should be no dramatic architecture work.

No major systems.

No heroic rewrites.

The work should look like:

```text
verify
package
test
sign
fix one issue
retest
document
ship
```

That is a good release process.

---

# 207. Phase 6 Core Product Test

The question is no longer:

> Is Hull Breach fun?

That should have been answered months ago.

It is:

> **Would we be comfortable charging someone money for this exact build today?**

That means the player should be able to trust:

```text
install
launch
controls
save
resume
campaign
performance
settings
ending
```

without ever knowing how the project is structured internally.

---

# 208. Final Principle

Phase 0 built the foundation.

Phase 1 proved the combat.

Phase 2 proved the game's identity.

Phase 3 proved content could be produced efficiently.

Phase 4 produced the complete game.

Phase 5 made that game trustworthy.

Phase 6 proves the exact product can be shipped.

The milestone is finished when the team can point at one immutable commit and one set of signed artifacts and say:

> **This is Hull Breach 1.0. Ship it.**

# Hull Breach — Phase 0 Product Requirements and Implementation Plan

**Phase:** 0 — Project Foundation
**Project:** Hull Breach
**Status:** Proposed
**Engine:** Godot 4.7.2 Standard
**Language:** GDScript
**Renderer:** Compatibility
**Source Control:** Git / GitHub
**Primary Development Platform:** Desktop
**Initial CI Target:** Linux
**Estimated effort:** 1–3 focused development days

---

# 1. Purpose

Phase 0 establishes the technical and project foundation for Hull Breach.

At the end of Phase 0, a developer must be able to:

1. clone the repository;
2. install the required Godot version;
3. open the project without errors;
4. run the development bootstrap scene;
5. run automated tests;
6. execute a headless project validation;
7. create at least one desktop debug export;
8. understand the repository conventions;
9. understand how third-party assets must be recorded;
10. begin Phase 1 without needing to restructure the project.

Phase 0 is explicitly **not** intended to build gameplay.

The goal is:

> Establish the smallest reliable foundation necessary to start building the game.

---

# 2. Phase 0 Success Criteria

Phase 0 succeeds when the repository is reproducible from a clean checkout.

A clean checkout must support:

```text
clone
  ↓
install Godot
  ↓
open project
  ↓
import assets
  ↓
run tests
  ↓
run game
  ↓
export debug build
```

No local undocumented configuration should be required.

---

# 3. Non-Goals

Phase 0 must not implement:

* player movement;
* weapons;
* enemies;
* combat;
* inventory;
* AI;
* navigation;
* mission systems;
* save games;
* procedural generation;
* multiplayer;
* final UI;
* final artwork;
* production sound;
* dependency injection frameworks;
* custom entity-component-system frameworks;
* elaborate game event buses;
* custom build systems.

If significant gameplay code appears during Phase 0, scope has expanded unnecessarily.

---

# 4. Guiding Principles

## 4.1 Keep Phase 0 small

Infrastructure should enable gameplay development rather than delaying it.

Target:

> Phase 1 gameplay development should begin within days, not weeks.

---

## 4.2 Pin important tooling

The repository must identify the expected Godot version.

Initial version:

```text
Godot 4.7.2 Standard
```

Do not automatically use:

```text
Godot 4.8-dev
```

or later development builds.

Engine upgrades must occur deliberately.

---

## 4.3 Prefer Godot conventions

Do not recreate enterprise application architecture inside Godot.

Prefer:

* scenes;
* nodes;
* resources;
* signals;
* autoloads where justified;
* InputMap;
* editor configuration.

Avoid unnecessary:

* service locators;
* dependency-injection containers;
* repository layers;
* generic event frameworks;
* DTO layers.

---

## 4.4 Keep assets and code easy to locate

Use primarily feature-oriented organization.

For example:

```text
features/player/
    player.gd
    player.tscn
    player_config.gd
```

rather than:

```text
scripts/
    player.gd

scenes/
    player.tscn

resources/
    player_config.tres
```

The first form keeps one feature together.

---

# 5. Required Deliverables

Phase 0 must produce:

* Git repository;
* GitHub repository;
* Godot project;
* pinned Godot version;
* project directory structure;
* `.gitignore`;
* `.gitattributes`;
* `.editorconfig`;
* Git LFS configuration;
* README;
* CONTRIBUTING document;
* third-party asset register;
* architecture decision records;
* bootstrap scene;
* initial InputMap;
* automated test infrastructure;
* at least one smoke test;
* CI workflow;
* export preset;
* automated headless validation;
* desktop debug export;
* Phase 1-ready `main` branch.

---

# 6. Repository

Repository name:

```text
hull-breach
```

Recommended GitHub repository visibility during early development:

```text
Private
```

The project can later be made public if desired.

---

# 7. Repository Creation

Create the repository locally:

```bash
mkdir hull-breach
cd hull-breach

git init -b main
```

Create the Godot project in this directory.

Project name:

```text
Hull Breach
```

Renderer:

```text
Compatibility
```

Version control metadata:

```text
Git
```

Godot project file:

```text
project.godot
```

---

# 8. GitHub Repository

Using GitHub CLI:

```bash
gh repo create hull-breach \
  --private \
  --source=. \
  --remote=origin
```

Do not push until the initial repository baseline has been created and reviewed.

---

# 9. Initial Repository Structure

Create:

```text
hull-breach/
│
├── .github/
│   ├── workflows/
│   │   └── ci.yml
│   │
│   └── pull_request_template.md
│
├── addons/
│
├── assets/
│   ├── original/
│   │
│   └── third_party/
│
├── audio/
│
├── core/
│   ├── events/
│   ├── settings/
│   ├── state/
│   └── utilities/
│
├── features/
│
├── levels/
│   ├── campaign/
│   ├── dev/
│   └── shared/
│
├── resources/
│   ├── enemies/
│   ├── items/
│   └── weapons/
│
├── shaders/
│
├── tests/
│   ├── integration/
│   └── unit/
│
├── tools/
│
├── ui/
│   ├── common/
│   ├── hud/
│   ├── menus/
│   └── mobile/
│
├── docs/
│   ├── adr/
│   ├── architecture/
│   └── development/
│
├── .editorconfig
├── .gitattributes
├── .gitignore
├── .godot-version
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── THIRD_PARTY_ASSETS.md
├── export_presets.cfg
└── project.godot
```

Not every directory needs content immediately.

Use `.gdkeep` files where Git needs to preserve currently empty directories.

---

# 10. Godot Version Pin

Create:

```text
.godot-version
```

Contents:

```text
4.7.2
```

Also record the version prominently in:

```text
README.md
```

Example:

```text
## Development Requirements

Godot Engine 4.7.2 Standard

Do not use the .NET build.
```

---

# 11. Engine Upgrade Policy

Godot upgrades require a separate pull request.

Example branch:

```text
chore/godot-4.7.3
```

The engine upgrade PR must:

* update `.godot-version`;
* update README;
* successfully import the project;
* execute automated tests;
* execute headless validation;
* produce the desktop debug export;
* document significant migration issues.

Do not perform engine upgrades as incidental changes inside gameplay PRs.

---

# 12. `.gitignore`

Create:

```gitignore
# ---------------------------------------------------------
# Godot
# ---------------------------------------------------------

.godot/

# ---------------------------------------------------------
# Builds / exports
# ---------------------------------------------------------

build/
builds/
dist/
exports/

# ---------------------------------------------------------
# Godot sensitive export credentials
# ---------------------------------------------------------

.godot/export_credentials.cfg

# ---------------------------------------------------------
# Local environment
# ---------------------------------------------------------

.env
.env.*
!.env.example

# ---------------------------------------------------------
# IDE
# ---------------------------------------------------------

.idea/
.vscode/

# ---------------------------------------------------------
# OS
# ---------------------------------------------------------

.DS_Store
Thumbs.db
Desktop.ini

# ---------------------------------------------------------
# Temporary files
# ---------------------------------------------------------

*.tmp
*.temp
*.log
*~

# ---------------------------------------------------------
# Signing credentials
# ---------------------------------------------------------

*.keystore
*.jks
*.p12
*.mobileprovision

# ---------------------------------------------------------
# Editor backup files
# ---------------------------------------------------------

*.bak
```

Godot's imported project cache under `.godot/` must not be committed.

The repository should contain source assets, not generated import artefacts.

---

# 13. Git LFS

Install Git LFS:

```bash
git lfs install
```

Track large editable/source assets.

Recommended initial configuration:

```bash
git lfs track "*.aseprite"
git lfs track "*.psd"
git lfs track "*.kra"
git lfs track "*.blend"
git lfs track "*.wav"
git lfs track "*.flac"
git lfs track "*.mp4"
git lfs track "*.mov"
```

Do not automatically put all PNG files under LFS.

Small sprites and tilesheets generally work well in normal Git.

Generated `.gitattributes` should resemble:

```gitattributes
*.aseprite filter=lfs diff=lfs merge=lfs -text
*.psd filter=lfs diff=lfs merge=lfs -text
*.kra filter=lfs diff=lfs merge=lfs -text
*.blend filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.flac filter=lfs diff=lfs merge=lfs -text
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text
```

---

# 14. Text File Normalisation

Extend `.gitattributes`:

```gitattributes
* text=auto

*.gd text eol=lf
*.tscn text eol=lf
*.tres text eol=lf
*.godot text eol=lf
*.cfg text eol=lf
*.md text eol=lf
*.yml text eol=lf
*.yaml text eol=lf
*.json text eol=lf
```

This avoids unnecessary line-ending differences between:

* Windows;
* macOS;
* Linux.

---

# 15. `.editorconfig`

Create:

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.gd]
indent_style = tab
indent_size = 4

[*.{md,yml,yaml,json}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
```

GDScript should follow the formatting produced by Godot's own editor where possible.

---

# 16. Godot Project Configuration

Configure:

```text
Project Name:
Hull Breach
```

Renderer:

```text
Compatibility
```

Main scene:

```text
res://levels/dev/bootstrap.tscn
```

Initial logical design resolution:

```text
Width: 640
Height: 360
```

Display mode:

```text
Windowed desktop development
```

Mobile orientation:

```text
Landscape
```

Stretch behaviour should preserve aspect ratio while allowing sensible expansion on wider screens.

---

# 17. Rendering Defaults

Initial rendering choices:

```text
Renderer:
Compatibility

Default texture filtering:
Nearest

2D pixel snapping:
evaluate during Phase 1
```

Do not enable unnecessary post-processing effects in Phase 0.

The goal is a reliable baseline.

---

# 18. Input Map

Create InputMap actions before gameplay code exists.

Actions:

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

weapon_next
weapon_previous

pause
map
```

---

# 19. Default Keyboard Bindings

Configure:

```text
move_left       A
move_right      D
move_up         W
move_down       S

fire            Mouse Button 1
secondary_fire  Mouse Button 2

interact        E
reload          R
sprint          Shift

weapon_next     Mouse Wheel Down
weapon_previous Mouse Wheel Up

pause           Escape
map             Tab
```

---

# 20. Default Controller Bindings

Configure:

```text
Movement:
Left Stick

Aim:
Right Stick

Fire:
Right Trigger

Secondary:
Left Trigger

Interact:
A / Cross

Reload:
X / Square

Weapon Previous:
Left Shoulder

Weapon Next:
Right Shoulder

Pause:
Start

Map:
View / Select
```

Do not embed device-specific input codes in gameplay scripts.

Gameplay code talks only to named actions.

For example:

```gdscript
var movement := Input.get_vector(
    "move_left",
    "move_right",
    "move_up",
    "move_down"
)
```

This is an architectural requirement.

---

# 21. Bootstrap Scene

Create:

```text
levels/dev/bootstrap.tscn
```

Scene structure:

```text
Bootstrap
└── UI
    └── Panel
        └── VBoxContainer
            ├── Title
            ├── Version
            └── Environment
```

The development scene should display:

```text
HULL BREACH

Development Bootstrap

Godot: 4.7.2
Build: Development
```

This proves:

* project opens;
* main scene resolves;
* UI renders;
* fonts render;
* project settings load.

---

# 22. Bootstrap Script

Create:

```text
levels/dev/bootstrap.gd
```

Suggested implementation:

```gdscript
extends Node

const GAME_NAME := "Hull Breach"
const GAME_VERSION := "0.0.1"

func _ready() -> void:
    print("%s %s" % [GAME_NAME, GAME_VERSION])
    print("Godot: %s" % Engine.get_version_info().string)
```

Do not introduce a global application framework for this.

---

# 23. Game Version

Start at:

```text
0.0.1
```

Version semantics:

```text
0.0.x
Phase 0 / infrastructure

0.1.x
Combat prototype

0.2.x
Vertical slice

0.5.x
Alpha

0.8.x
Beta

0.9.x
Release candidate

1.0.0
Production release
```

---

# 24. Build Information

Eventually builds should expose:

```text
version
commit
build configuration
```

Phase 0 only needs:

```text
version
```

Do not build elaborate automated version-generation logic yet.

---

# 25. Testing Strategy

Testing is required from Phase 0, but should remain pragmatic.

Test:

* deterministic game logic;
* resource validation;
* state transitions;
* damage calculations;
* inventory rules;
* save serialization;
* mission transitions.

Do not attempt to unit test:

* every animation;
* every scene transform;
* trivial node wiring.

---

# 26. Testing Framework

Initial preferred framework:

```text
GdUnit4
```

Use the current compatible 6.2.x generation.

The compatibility of the chosen GdUnit release with the pinned Godot patch release must be confirmed as part of Phase 0.

Do not silently upgrade either dependency later.

Record the selected test framework version in:

```text
docs/development/testing.md
```

and preferably pin the addon version.

---

# 27. First Unit Test

Create a trivial deterministic class.

Example:

```text
core/utilities/game_version.gd
```

```gdscript
class_name GameVersion

const MAJOR := 0
const MINOR := 0
const PATCH := 1

static func as_string() -> String:
    return "%d.%d.%d" % [
        MAJOR,
        MINOR,
        PATCH
    ]
```

Create:

```text
tests/unit/test_game_version.gd
```

Test:

```text
GameVersion.as_string()
```

returns:

```text
0.0.1
```

The point is not the version test itself.

The point is verifying:

```text
test discovery
+
test execution
+
CI execution
```

end-to-end.

---

# 28. Smoke Test

Add a smoke test that loads:

```text
res://levels/dev/bootstrap.tscn
```

The test passes if the scene:

* exists;
* loads;
* instantiates;
* produces no fatal error.

This catches broken scene references.

---

# 29. Command-Line Validation

Create:

```text
tools/validate.sh
```

Conceptually:

```bash
#!/usr/bin/env bash

set -euo pipefail

godot \
  --headless \
  --path . \
  --import

echo "Godot project validation successful."
```

Godot supports `--headless` and `--import`, making this suitable for CI validation.

Also create equivalent Windows PowerShell helper if Windows is a primary development environment:

```text
tools/validate.ps1
```

Avoid requiring developers to remember complicated commands.

---

# 30. Local Developer Commands

Recommended scripts:

```text
tools/
├── bootstrap.sh
├── validate.sh
├── test.sh
├── export-debug.sh
│
├── bootstrap.ps1
├── validate.ps1
├── test.ps1
└── export-debug.ps1
```

Scripts should wrap commonly used commands.

Example usage:

```bash
./tools/validate.sh
./tools/test.sh
./tools/export-debug.sh
```

---

# 31. Do Not Introduce Make/Gradle

Do not add:

```text
Gradle
Maven
Make
CMake
Taskfile
Just
```

solely to wrap three Godot commands.

Shell and PowerShell scripts are sufficient initially.

If build complexity later justifies a task runner, introduce it then.

---

# 32. Export Presets

Create Godot export presets for:

```text
Linux
Windows Desktop
macOS
Android
iOS
```

Phase 0 requires a working export for at least:

```text
Linux
```

and ideally the developer's desktop OS.

Android and iOS presets can exist without signing configuration.

---

# 33. Export Directory

All generated files go under:

```text
build/
```

Example:

```text
build/
├── linux/
├── windows/
├── macos/
├── android/
└── ios/
```

The entire directory is ignored by Git.

---

# 34. Debug Export Script

Example Linux implementation:

```bash
#!/usr/bin/env bash

set -euo pipefail

mkdir -p build/linux

godot \
  --headless \
  --path . \
  --export-debug \
  "Linux" \
  build/linux/hull-breach.x86_64
```

The export preset name must match `export_presets.cfg`.

---

# 35. Release Exports

Phase 0 does not require production signing.

Do not commit:

* Apple certificates;
* Android keystores;
* store passwords;
* API keys;
* signing passwords.

Release signing will be configured in later phases using environment secrets.

---

# 36. Continuous Integration

Create:

```text
.github/workflows/ci.yml
```

CI triggers:

```text
push to main
pull request targeting main
manual workflow dispatch
```

CI responsibilities:

```text
checkout
   ↓
install pinned Godot
   ↓
install export templates
   ↓
import project
   ↓
run validation
   ↓
run tests
   ↓
produce Linux debug export
```

---

# 37. CI Pipeline Stages

Logical stages:

## validate

Confirm Godot can import the project.

---

## test

Execute automated test suite.

---

## build

Produce a Linux debug executable.

---

# 38. CI Failure Policy

A pull request may not merge if:

```text
project import fails
OR
tests fail
OR
debug build fails
```

No coverage percentage requirement exists during Phase 0.

---

# 39. CI Artefact

Upload:

```text
build/linux/hull-breach.x86_64
```

as a GitHub Actions artefact.

Name:

```text
hull-breach-linux-debug
```

Retention may remain short, for example:

```text
7 days
```

This is not a release artifact.

Its purpose is validating reproducible builds.

---

# 40. Git Workflow

Use trunk-based development.

Permanent branch:

```text
main
```

Feature branches:

```text
feature/player-movement
feature/weapon-system
feature/enemy-perception

fix/controller-deadzone

chore/godot-4.7.3
docs/phase-1-design
```

Branches should be short lived.

---

# 41. Do Not Create a `develop` Branch

Avoid:

```text
main
develop
integration
staging
release
```

for a small game project.

They introduce process without providing useful isolation.

Use:

```text
short-lived branch
       ↓
pull request
       ↓
main
```

---

# 42. Commit Convention

Use Conventional Commit-style prefixes:

```text
feat:
fix:
perf:
refactor:
test:
docs:
build:
ci:
chore:
```

Examples:

```text
chore: bootstrap Godot project

build: add Linux debug export

ci: validate project using Godot headless

test: add bootstrap scene smoke test

docs: document third-party asset policy
```

---

# 43. Pull Request Rules

Every non-trivial change should use a pull request.

A PR should:

* explain what changed;
* explain why;
* identify testing performed;
* include screenshots/video for visual changes where useful;
* pass CI.

Do not require heavyweight enterprise review processes for a one-person project.

PRs remain useful even for solo development because they provide:

* coherent change units;
* history;
* CI gates;
* future reviewability.

---

# 44. Pull Request Template

Create:

```text
.github/pull_request_template.md
```

Contents:

```markdown
## Summary

What does this change do?

## Why

Why is the change required?

## Testing

- [ ] Project opens
- [ ] Automated tests pass
- [ ] Relevant scene tested manually

## Screenshots / Video

Add when relevant.

## Checklist

- [ ] No unrelated changes
- [ ] Third-party assets documented
- [ ] No credentials committed
```

---

# 45. Branch Protection

Protect:

```text
main
```

Require:

* pull request before merge;
* CI passing.

Optional during solo early development:

```text
required reviewer count = 0
```

As collaborators join:

```text
required reviewer count = 1
```

---

# 46. Merge Strategy

Preferred:

```text
Squash merge
```

This gives one coherent commit per feature/fix.

Example history:

```text
feat: add player movement

feat: add pulse rifle firing

feat: add basic drone enemy

fix: stop bullets passing through doors
```

rather than dozens of:

```text
fix typo
oops
again
wip
try this
```

commits.

---

# 47. README

Create a useful README immediately.

Sections:

```text
Hull Breach

Overview

Requirements

Getting Started

Running the Game

Running Tests

Creating a Debug Build

Repository Structure

Development Conventions

Third-Party Assets

Architecture Decisions
```

---

# 48. README — Getting Started

Recommended content:

```bash
git clone <repository>
cd hull-breach

git lfs install
git lfs pull

godot --editor --path .
```

Developer should then be able to press:

```text
F6 / F5
```

and start the project.

---

# 49. README — Requirements

Document:

```text
Required:
- Git
- Git LFS
- Godot 4.7.2 Standard

Recommended:
- GitHub CLI
- Aseprite
- VS Code or Godot's script editor
```

Do not make optional art tools required to build the project.

---

# 50. Third-Party Asset Policy

Create:

```text
THIRD_PARTY_ASSETS.md
```

Every third-party asset requires:

```text
name
author
source
licence
download date
local path
usage
modified?
```

---

# 51. Asset Register Template

Use:

```markdown
## Asset Name

**Author:**  
Author Name

**Source:**  
https://example.com

**Licence:**  
CC0 1.0

**Downloaded:**  
YYYY-MM-DD

**Local path:**  
`assets/third_party/author/asset-name/`

**Usage:**  
Prototype environment artwork.

**Modified:**  
No
```

---

# 52. Third-Party Asset Directory Convention

Use:

```text
assets/third_party/
    <creator>/
        <pack>/
```

Example:

```text
assets/third_party/
├── kenney/
│   └── top_down_shooter/
│
└── ansimuz/
    └── warped_tech_lab/
```

Do not dump unrelated external assets into:

```text
assets/
```

without provenance.

---

# 53. Source Information Next to Assets

Where practical, each asset pack also contains:

```text
SOURCE.md
```

Example:

```text
Source:
https://...

Author:
Kenney

License:
CC0 1.0

Retrieved:
2026-08-25
```

This protects provenance if the central register becomes incomplete.

---

# 54. Asset Import Rule

Third-party assets must not be merged until:

```text
licence verified
AND
source recorded
AND
local ownership/path understood
```

Unknown licence means:

```text
DO NOT USE
```

---

# 55. Phase 0 Prototype Assets

Phase 0 should import only enough content to prove asset handling.

Recommended:

* one CC0 floor tile;
* one CC0 character sprite;
* optionally one UI element.

Do not import hundreds of megabytes of prototype art yet.

Bulk asset adoption belongs in later phases.

---

# 56. Architecture Decision Records

Create:

```text
docs/adr/
```

ADR naming:

```text
0001-use-godot.md
0002-use-gdscript.md
0003-use-compatibility-renderer.md
0004-feature-oriented-project-layout.md
0005-use-trunk-based-development.md
0006-prefer-cc0-prototype-assets.md
```

---

# 57. ADR Template

Use:

```markdown
# ADR-XXXX: Decision

## Status

Accepted

## Context

Why is this decision required?

## Decision

What have we chosen?

## Consequences

What benefits and trade-offs result?
```

Keep ADRs short.

The purpose is historical context, not bureaucratic documentation.

---

# 58. ADR-0001 — Godot

Decision:

```text
Use Godot 4.x as the game engine.
```

Rationale:

* strong 2D support;
* cross-platform;
* open source;
* suitable mobile support;
* lightweight;
* no engine royalty;
* appropriate level/editor workflow.

---

# 59. ADR-0002 — GDScript

Decision:

```text
Use GDScript for gameplay.
```

Do not mix languages without a specific requirement.

C++/GDExtension may later be introduced for measured performance problems.

Not before.

---

# 60. ADR-0003 — Compatibility Renderer

Decision:

```text
Use Compatibility renderer initially.
```

Reason:

* primarily 2D;
* mobile targets;
* lower hardware requirements;
* broader device support.

Revisit only when a feature requires another renderer.

---

# 61. ADR-0004 — Feature-Oriented Structure

Decision:

```text
Organize gameplay features together.
```

Example:

```text
features/doors/
├── door.gd
├── door.tscn
├── door_config.gd
└── door_audio.tres
```

Avoid global directories containing thousands of unrelated scripts.

---

# 62. Coding Conventions

Follow Godot/GDScript conventions unless there is a reason not to.

Classes:

```gdscript
class_name HealthComponent
```

Files:

```text
health_component.gd
```

Variables:

```gdscript
var current_health: float
```

Constants:

```gdscript
const MAX_HEALTH := 100.0
```

Signals:

```gdscript
signal health_changed(current: float, maximum: float)
```

Private implementation details should normally use:

```text
_leading_underscore
```

where useful.

---

# 63. Static Typing

Prefer typed GDScript for important game logic.

Example:

```gdscript
var speed: float = 200.0

func apply_damage(amount: float) -> void:
    ...
```

Prefer:

```gdscript
func get_weapon() -> WeaponDefinition:
```

over untyped:

```gdscript
func get_weapon():
```

Typed GDScript improves:

* editor assistance;
* refactoring;
* readability;
* error detection.

---

# 64. Warnings

Treat meaningful GDScript warnings seriously.

Do not globally suppress warnings merely to obtain a clean editor.

Warnings should be either:

* fixed;
* understood;
* intentionally suppressed locally.

---

# 65. Autoload Policy

Phase 0 should have **zero or very few autoloads**.

Do not immediately create:

```text
GameManager
AudioManager
SceneManager
SaveManager
EnemyManager
WeaponManager
EverythingManager
```

Future autoloads require a clear cross-scene lifecycle requirement.

A global singleton should be the exception, not the default.

---

# 66. Signal Policy

Signals should be used where they reduce coupling.

Do not create a global message bus in Phase 0.

Local Godot signals are enough until a demonstrated cross-system need exists.

---

# 67. Resource Policy

Future configuration should favour custom Resources.

Examples:

```text
WeaponDefinition
EnemyDefinition
ItemDefinition
DifficultyDefinition
```

No production Resources are required in Phase 0 beyond simple tests if desired.

---

# 68. Logging

Use ordinary Godot logging initially:

```gdscript
print()
push_warning()
push_error()
```

Do not build a complex logging framework in Phase 0.

Production logging requirements can be assessed later.

---

# 69. Development Scene Convention

Development-only scenes live under:

```text
levels/dev/
```

Examples later:

```text
bootstrap.tscn
combat_sandbox.tscn
lighting_sandbox.tscn
ai_sandbox.tscn
weapon_sandbox.tscn
```

These are first-class development tools and should remain in source control.

---

# 70. Documentation Structure

Use:

```text
docs/
├── adr/
├── architecture/
└── development/
```

Initial documents:

```text
docs/development/
├── setup.md
├── testing.md
├── exporting.md
└── assets.md
```

README should link to these rather than duplicate every detail.

---

# 71. CHANGELOG

Create:

```text
CHANGELOG.md
```

Initial:

```markdown
# Changelog

## Unreleased

### Added

- Initial Godot project.
- Development bootstrap scene.
- Automated testing infrastructure.
- CI validation.
```

Do not spend significant effort maintaining release notes during prototype development.

---

# 72. Licence File

Add the project's own licence.

If the project remains closed/private, use an appropriate proprietary copyright statement.

Do not accidentally apply a permissive open-source licence to the game's original assets/code unless that is intentional.

Third-party assets retain their own licences independently.

---

# 73. Secrets Policy

Never commit:

```text
Android signing keys
Apple certificates
Steam credentials
API keys
passwords
tokens
private keys
```

GitHub Actions secrets will later hold required CI/CD credentials.

Phase 0 does not require production credentials.

---

# 74. GitHub Issues

Create initial labels:

```text
type:feature
type:bug
type:technical
type:content
type:documentation

area:player
area:combat
area:enemy
area:level
area:ui
area:audio
area:build

priority:p0
priority:p1
priority:p2
priority:p3

phase:0
phase:1
phase:2
```

Do not create dozens of project-management categories prematurely.

---

# 75. Phase 0 Issues

Create roughly the following issues:

```text
P0-001 Bootstrap Godot repository

P0-002 Configure Git and Git LFS

P0-003 Establish repository structure

P0-004 Configure project settings and InputMap

P0-005 Add development bootstrap scene

P0-006 Add automated testing framework

P0-007 Add headless project validation

P0-008 Add GitHub Actions CI

P0-009 Configure desktop export

P0-010 Document developer setup

P0-011 Document third-party asset policy

P0-012 Create initial ADRs

P0-013 Validate clean clone
```

---

# 76. Recommended Implementation Sequence

Execute Phase 0 in this order.

---

## Step 1 — Create Repository

Tasks:

* create directory;
* initialise Git;
* initialise Godot project;
* set renderer;
* configure project name.

Result:

```text
project.godot
```

runs.

---

## Step 2 — Configure Git

Tasks:

* `.gitignore`;
* `.gitattributes`;
* Git LFS;
* `.editorconfig`.

Result:

repository safely handles text and binary assets.

---

## Step 3 — Create Folder Structure

Create standard top-level directories.

Do not populate them with speculative classes.

---

## Step 4 — Configure Godot

Set:

* logical resolution;
* renderer;
* main scene;
* input actions;
* display settings.

---

## Step 5 — Create Bootstrap Scene

Create:

```text
levels/dev/bootstrap.tscn
```

Verify:

```bash
godot --path .
```

runs successfully.

---

## Step 6 — Add Testing

Install selected GdUnit4 version.

Create:

```text
test_game_version.gd
test_bootstrap.gd
```

Verify locally.

---

## Step 7 — Add Command-Line Validation

Verify:

```bash
godot --headless --path . --import
```

runs without failure.

---

## Step 8 — Add Export Preset

Configure Linux desktop export.

Install matching Godot export templates.

Verify:

```bash
godot \
  --headless \
  --path . \
  --export-debug \
  "Linux" \
  build/linux/hull-breach.x86_64
```

---

## Step 9 — Add CI

Pipeline:

```text
import
→ test
→ build
```

Push branch and ensure GitHub Actions succeeds.

---

## Step 10 — Add Documentation

Complete:

* README;
* setup;
* testing;
* exporting;
* third-party asset register;
* ADRs.

---

## Step 11 — Clean Clone Test

Clone repository into a completely separate directory.

Do not reuse existing `.godot` imports.

Execute documented setup exactly.

Verify:

```text
open
run
test
build
```

works.

---

## Step 12 — Merge Phase 0

Create PR:

```text
chore: bootstrap Hull Breach project
```

Merge to:

```text
main
```

Tag:

```text
v0.0.1
```

---

# 77. Clean Clone Validation

This is mandatory.

Example:

```bash
cd /tmp

git clone <repo> hull-breach-clean
cd hull-breach-clean

git lfs pull

godot --headless --path . --import
```

Then:

```bash
./tools/test.sh
```

Then:

```bash
./tools/export-debug.sh
```

If this succeeds, Phase 0's primary technical objective has been achieved.

---

# 78. Developer Experience Requirement

A developer familiar with Git and Godot should be able to go from:

```text
git clone
```

to:

```text
running game
```

in approximately five documented commands or fewer, excluding software installation.

Ideal:

```bash
git clone <repo>
cd hull-breach
git lfs pull
godot --editor --path .
```

Everything else should be discoverable from README.

---

# 79. Performance Requirements

Phase 0 has no meaningful gameplay performance requirements.

Bootstrap scene should:

* start essentially immediately;
* produce no errors;
* produce no repeated warnings;
* remain at the configured frame rate.

No optimization work is justified yet.

---

# 80. Security Requirements

Repository must contain no secrets.

Perform before first push:

```bash
git status
git diff --cached
```

Review:

```text
export credentials
.env files
key stores
private keys
tokens
```

If a secret is ever committed, removing the file from the latest commit is not sufficient.

Rotate the credential.

---

# 81. Phase 0 Test Matrix

| Test                 | Local              | CI                 | Required    |
| -------------------- | ------------------ | ------------------ | ----------- |
| Godot import         | Yes                | Yes                | Yes         |
| Bootstrap scene load | Yes                | Yes                | Yes         |
| Unit test            | Yes                | Yes                | Yes         |
| Linux debug export   | Recommended        | Yes                | Yes         |
| Windows debug export | Yes if Windows dev | Optional initially | Recommended |
| Android export       | No                 | No                 | No          |
| iOS export           | No                 | No                 | No          |
| Controller gameplay  | No gameplay yet    | No                 | No          |

---

# 82. Definition of Done

Phase 0 is complete only when all of the following are true.

## Repository

* [ ] Git repository exists.
* [ ] GitHub repository exists.
* [ ] `main` is default branch.
* [ ] branch protection is configured.
* [ ] `.gitignore` is correct.
* [ ] `.gitattributes` is correct.
* [ ] Git LFS is configured.
* [ ] no secrets are committed.

## Godot

* [ ] Godot 4.7.2 Standard is documented.
* [ ] `.godot-version` exists.
* [ ] Compatibility renderer is configured.
* [ ] project opens without errors.
* [ ] bootstrap scene runs.
* [ ] 640×360 logical resolution is configured.
* [ ] InputMap baseline exists.

## Structure

* [ ] project folder structure exists.
* [ ] development scenes have a defined home.
* [ ] third-party assets have a defined home.
* [ ] test directory exists.
* [ ] documentation directory exists.

## Testing

* [ ] test framework installed and pinned.
* [ ] at least one unit test passes.
* [ ] bootstrap smoke test passes.
* [ ] tests run from command line.

## CI

* [ ] CI triggers on pull requests.
* [ ] CI imports project headlessly.
* [ ] CI runs tests.
* [ ] CI creates desktop debug export.
* [ ] CI failure prevents merge.

## Documentation

* [ ] README exists.
* [ ] setup instructions exist.
* [ ] testing instructions exist.
* [ ] exporting instructions exist.
* [ ] CONTRIBUTING exists.
* [ ] THIRD_PARTY_ASSETS exists.
* [ ] initial ADRs exist.

## Validation

* [ ] clean clone successfully imports.
* [ ] clean clone successfully runs tests.
* [ ] clean clone successfully runs bootstrap.
* [ ] clean clone successfully exports desktop debug build.

---

# 83. Phase 0 Exit Criteria

The final Phase 0 demonstration should consist of:

```text
1. Delete/ignore all local Godot cache.

2. Clone fresh repository.

3. Open project.

4. Run bootstrap scene.

5. Run automated tests.

6. Push branch.

7. Observe green CI.

8. Download CI-generated Linux debug build.

9. Launch exported build.
```

If every step works, Phase 0 passes.

---

# 84. Phase 0 Deliverable

Tag:

```text
v0.0.1
```

Release description:

```text
Hull Breach v0.0.1

Project infrastructure baseline.

Includes:
- Godot 4.7.2 project
- repository structure
- input configuration
- development bootstrap scene
- automated test infrastructure
- CI
- desktop debug build pipeline
- asset licensing policy
- architecture records

No gameplay implemented.
```

---

# 85. First Task After Phase 0

Immediately start Phase 1 with:

```text
feature/player-movement
```

The first gameplay milestone should be:

> A capsule/placeholder character can move smoothly around an empty room using keyboard and controller input.

Then:

```text
aiming
→ shooting
→ damage
→ first alien
```

Do not spend another infrastructure sprint before beginning gameplay.

---

# 86. Expected Phase 0 Commit History

A reasonable sequence would be:

```text
chore: bootstrap Godot project

chore: configure repository conventions

build: configure Git LFS

feat: add development bootstrap scene

test: add GdUnit4 testing baseline

build: add desktop export preset

ci: add project validation and debug build

docs: document project setup and architecture
```

If working solo, these may alternatively be squashed into:

```text
chore: bootstrap Hull Breach project
```

when Phase 0 is merged.

---

# 87. Final Phase 0 Architecture

At completion the architecture should still look deliberately boring:

```text
Hull Breach
│
├── Godot
│
├── bootstrap scene
│
├── InputMap
│
├── project structure
│
├── tests
│
├── CI
│
├── build/export
│
└── documentation
```

There should **not** yet be:

```text
GameEngine
GameContext
DependencyContainer
EntitySystem
EventBroker
RepositoryFactory
ServiceRegistry
AbstractGameManager
```

Those abstractions should only be introduced if actual gameplay later demonstrates a need.

Phase 0 exists to eliminate friction from developing the game.

It does not exist to design the entire game architecture before the game has taught us what architecture it needs.

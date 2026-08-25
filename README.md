# Hull Breach

Hull Breach is a top-down science-fiction survival shooter inspired by classic Amiga games. Version 0.3.0 includes the Station Blackout and Medical Wing campaign missions, three enemy archetypes, three weapons, hazards, difficulty profiles, and persistent campaign progress.

## Development Requirements

Required:

- Git and Git LFS
- Godot Engine 4.7.2 Standard (not the .NET build)

Recommended: GitHub CLI, Aseprite, and either Godot's script editor or VS Code.

## Getting Started

```bash
git clone https://github.com/bovinemagnet/hull-breach.git
cd hull-breach
./tools/bootstrap.sh
godot --editor --path .
```

Press F6 or F5 to open the main menu, then start or continue the campaign. `levels/campaign/station_blackout/` and `levels/campaign/medical_wing/` can also be run directly for development. The combat sandbox remains available at `levels/dev/combat_sandbox/combat_sandbox.tscn`.

## Running Tests and Validation

```bash
./tools/validate.sh
./tools/test.sh
./tools/profile-combat.sh
./tools/profile-phase3.sh
```

Validation performs a clean import plus content-ID, definition, mission-scene, and version checks. Tests use GdUnit4 v6.2.0. The Phase 3 profile exercises 50 mixed enemies and 100 projectiles. See [testing instructions](docs/development/testing.md) for details.

## Creating a Debug Build

Install the Godot 4.7.2 export templates, then run:

```bash
./tools/export-debug.sh
```

The Linux executable is written to `build/linux/hull-breach.x86_64`. See [exporting instructions](docs/development/exporting.md) for other presets.

## Repository Structure

- `core/`: shared, feature-independent utilities
- `features/`: feature-oriented gameplay scenes, scripts, and resources
- `levels/`: campaign, shared, and development scenes
- `ui/`, `audio/`, `shaders/`: presentation systems
- `assets/original/`, `assets/third_party/`: source and licensed external assets
- `tests/unit/`, `tests/integration/`: automated tests
- `docs/`: PRDs, architecture decisions, and development guides
- `tools/`: local workflow scripts

## Development Conventions

Read [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md) before changing the project. Gameplay uses typed GDScript and feature-oriented organization. Engine upgrades must be isolated in their own pull request and pass import, tests, and export validation.

## Third-Party Assets and Architecture

Record every external asset in [THIRD_PARTY_ASSETS.md](THIRD_PARTY_ASSETS.md) and keep its source information beside the files where practical. Architectural decisions are recorded in [`docs/adr/`](docs/adr/).

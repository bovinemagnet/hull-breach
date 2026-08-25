# Hull Breach

Hull Breach is a top-down science-fiction survival shooter inspired by classic Amiga games. Version 0.8.0 Beta hardens the eight-mission campaign with recoverable saves, sequence-independent objectives, lifecycle-safe input, accessibility controls, campaign regression coverage, and platform-ready build presets.

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

Press F6 or F5 to open the main menu, then start or continue the campaign. Development builds expose all eight missions through Mission Select. Individual scenes under `levels/campaign/` can also run directly; the combat sandbox remains at `levels/dev/combat_sandbox/combat_sandbox.tscn`.

## Running Tests and Validation

```bash
./tools/validate.sh
./tools/test.sh
./tools/profile-combat.sh
./tools/profile-phase3.sh
./tools/profile-campaign.sh
./tools/export-beta.sh
```

Validation performs a clean import plus content, release-document, platform-preset, input, and version checks. Tests use GdUnit4 v6.2.0. The campaign profiler records average, p95, p99, and memory observations against the 16.67 ms average frame budget. See [testing instructions](docs/development/testing.md) and the [Beta hardening matrix](docs/development/beta-hardening.md).

## Creating a Debug Build

Install the Godot 4.7.2 export templates, then run:

```bash
./tools/export-debug.sh
```

The Linux executable is written to `build/linux/hull-breach.x86_64`. See [exporting instructions](docs/development/exporting.md) for other presets.

`./tools/export-beta.sh` creates and smoke-tests the versioned Linux package under `build/beta/`.

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

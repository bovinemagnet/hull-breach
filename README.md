# Hull Breach

Hull Breach is a top-down science-fiction survival shooter inspired by classic Amiga games. Version 1.0.0-rc.1 freezes the complete eight-mission campaign behind production configuration, reproducible release packaging, embedded build identity, legal notices, and an evidence-driven ship checklist.

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
./tools/export-release.sh linux
./tools/release-gate.sh linux
```

Validation performs a clean import plus content, release-document, production-preset, input, and version checks. Tests use GdUnit4 v6.2.0. The campaign profiler records average, p95, p99, and memory observations against the 16.67 ms average frame budget. See [testing instructions](docs/development/testing.md) and the authoritative [release checklist](docs/release/release_checklist.md).

## Creating a Debug Build

Install the Godot 4.7.2 export templates, then run:

```bash
./tools/export-debug.sh
```

The Linux executable is written to `build/linux/hull-breach.x86_64`. See [exporting instructions](docs/development/exporting.md) for other presets.

`./tools/export-release.sh linux` creates the versioned RC package, embeds source identity, smoke-tests it, and writes a manifest and SHA-256 checksums under `build/release/`. The complete automated gate is `./tools/release-gate.sh linux`; manual signing, store, real-device, and full-playthrough evidence remains mandatory.

## Repository Structure

- `core/`: shared, feature-independent utilities
- `features/`: feature-oriented gameplay scenes, scripts, and resources
- `levels/`: campaign, shared, and development scenes
- `ui/`, `audio/`, `shaders/`: presentation systems
- `assets/original/`, `assets/third_party/`: source and licensed external assets
- `tests/unit/`, `tests/integration/`: automated tests
- `docs/`: PRDs, architecture decisions, development guides, and release evidence
- `tools/`: local workflow scripts

## Development Conventions

Read [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md) before changing the project. Gameplay uses typed GDScript and feature-oriented organization. Engine upgrades must be isolated in their own pull request and pass import, tests, and export validation.

## Third-Party Assets and Architecture

Record every external asset in [THIRD_PARTY_ASSETS.md](THIRD_PARTY_ASSETS.md) and keep its source information beside the files where practical. Architectural decisions are recorded in [`docs/adr/`](docs/adr/).

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Hull Breach is a top-down sci-fi survival shooter (an *Alien Breed* spiritual successor) built in **Godot 4.7.2 Standard** (not .NET) with **typed GDScript** and the **GL Compatibility** renderer.

The repository is at **Phase 0 — Project Foundation**. There is no gameplay code: only a bootstrap scene, a version constant, the InputMap, tooling, and tests. `docs/prd/phase-1.md` … `phase-6.md` describe *planned* milestones — treat them as plans, never as existing APIs to call.

## Commands

All scripts run from the repository root and honour `GODOT_BIN` (default `godot`). Windows equivalents are `tools/*.ps1`.

```bash
./tools/bootstrap.sh                # One-time setup: checks Godot/LFS, pulls LFS, imports
./tools/validate.sh                 # Headless import — catches broken scenes/resources
./tools/test.sh                     # Full GdUnit4 suite, reports to build/reports/
./tools/export-debug.sh             # Linux debug export to build/linux/hull-breach.x86_64
godot --editor --path .             # Open the editor (F5/F6 runs levels/dev/bootstrap.tscn)
```

Run a single test suite by passing its path instead of the whole `tests` directory:

```bash
godot --headless --path . \
  --script res://addons/gdUnit4/bin/GdUnitCmdTool.gd \
  --add res://tests/unit/test_game_version.gd \
  --ignoreHeadlessMode
```

Useful GdUnit4 CLI flags: `-i <suite>:<test>` to ignore a case, `-c` to continue past the first failure (the default is fail-fast), `-rd <dir>` for the report directory.

`./tools/validate.sh` and `./tools/test.sh` are the minimum before any commit; CI (`.github/workflows/ci.yml`) additionally runs the debug export and will fail if the binary is missing.

**Do not add Gradle, Make, npm, or any other wrapper build system** — the Godot CLI plus `tools/*.sh` is the build system by design (this overrides the generic `gradle21w`/Antora instructions in the global user config, which do not apply to this project).

## Architecture

Layout is **feature-oriented**, not type-oriented (ADR-0004). A feature keeps its scene, script, resources, and audio together — `features/doors/door.gd` beside `door.tscn` — rather than splitting across global `scripts/`, `scenes/` directories.

- `core/` — shared, feature-independent infrastructure. Only promote code here when *multiple* features genuinely need it. Currently just `core/utilities/game_version.gd`; `core/events/`, `core/settings/`, `core/state/` are empty placeholders.
- `features/` — gameplay, one directory per feature (empty in Phase 0).
- `levels/` — `dev/` (bootstrap harness), `campaign/`, `shared/`.
- `ui/`, `audio/`, `shaders/` — presentation systems.
- `assets/original/` vs `assets/third_party/` — provenance separation; every third-party asset must be recorded in `THIRD_PARTY_ASSETS.md`.
- `tests/unit/` (deterministic logic) and `tests/integration/` (scene loading, system boundaries).

Communication is via Godot's own primitives: scenes, nodes, resources, **local** signals, and named InputMap actions. Deliberately absent, and not to be introduced without a demonstrated cross-scene lifecycle need: autoloads, a global event bus, a dependency-injection container, manager singletons, and custom ECS frameworks. Record any durable technical decision as a new ADR in `docs/adr/`.

The 17 InputMap actions in `project.godot` (twin-stick `move_*`/`aim_*`, `fire`, `secondary_fire`, `interact`, `reload`, `sprint`, `weapon_next`/`weapon_previous`, `pause`, `map`) are the stable contract for keyboard/mouse and gamepad. `tests/unit/test_input_map.gd` asserts they all exist — update that list when adding actions.

## Conventions

- **Typed GDScript** for game logic. Tabs (width 4) in `.gd`; two spaces in Markdown/YAML/JSON (`.editorconfig`).
- `snake_case` files and variables, `PascalCase` classes, `UPPER_SNAKE_CASE` constants, descriptive signals (`health_changed`), leading underscore for private members.
- Tests are named `test_<subject>.gd` and extend `GdUnitTestSuite`; use `auto_free()` for instantiated nodes.
- **Commit the `.uid` files** Godot generates alongside `.gd` scripts — they are tracked, and omitting them breaks resource references.
- Binary source assets (`.aseprite`, `.psd`, `.kra`, `.blend`, `.wav`, `.flac`, `.mp4`, `.mov`) go through **Git LFS** (`.gitattributes`).
- Conventional Commit prefixes (`feat:`, `fix:`, `test:`, `docs:`, `refactor:`, `perf:`, `build:`, `ci:`, `chore:`), short-lived branches off `main`, squash merge.
- Never commit credentials, keystores, or `export_credentials.cfg`.

### Version bumps touch several files

The game version is duplicated deliberately; changing it means updating all of:
`core/utilities/game_version.gd` (`MAJOR`/`MINOR`/`PATCH`), `project.godot` (`config/version`), the `Version` label in `levels/dev/bootstrap.tscn`, the assertion in `tests/unit/test_game_version.gd`, and `CHANGELOG.md`.

### Pinned dependencies

- Godot is pinned in `.godot-version` (`4.7.2`) and enforced by `tools/bootstrap.sh`. Engine upgrades require a dedicated `chore/godot-<version>` PR updating `.godot-version`, docs, tests, and export verification — never bundled with other work.
- GdUnit4 v6.2.0 is **vendored** under `addons/gdUnit4/` with a recorded SHA-256 (`docs/development/testing.md`). Do not edit it; change it only in an isolated dependency update.

## Further reading

`AGENTS.md` and `CONTRIBUTING.md` hold the full contributor rules, `docs/architecture/README.md` the architectural stance, `docs/adr/` the decision records, and `docs/development/` setup, testing, exporting, and asset guides.

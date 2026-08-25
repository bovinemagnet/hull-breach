# Repository Guidelines

## Project Structure & Module Organization

This repository contains the Godot project foundation and evolving product plans. `README.md` gives the project summary, while `docs/prd/prd.md` defines the product and `docs/prd/phase-0.md` to `phase-6.md` contain milestone plans. Treat future-phase structures as plans, not existing APIs.

Keep shared infrastructure in `core/`, gameplay grouped by feature under `features/` (for example, `features/doors/door.gd` beside `door.tscn`), levels in `levels/`, UI in `ui/`, configuration resources in `resources/`, and tests in `tests/unit/` or `tests/integration/`. Put original assets in `assets/original/` and licensed external assets in `assets/third_party/`.

## Build, Test, and Development Commands

Use Godot 4.7.2 Standard (not .NET). Run the repository scripts from the project root:

```bash
godot --editor --path .                 # Open the project locally
godot --headless --path . --import      # Validate imports and scene references
./tools/test.sh                         # Run the GdUnit4 suite
./tools/export-debug.sh                 # Produce a debug export
```

Prefer repository scripts once present; do not add Make, Gradle, or another wrapper build system.

## Coding Style & Naming Conventions

Follow Godot conventions and prefer typed GDScript for game logic. Use tabs (width 4) in `.gd` files and two-space indentation in Markdown, YAML, and JSON. Name files and variables `snake_case`, classes `PascalCase`, constants `UPPER_SNAKE_CASE`, signals descriptively (`health_changed`), and private members with a leading underscore. Keep scenes, scripts, resources, and audio for a feature together rather than creating large type-based directories.

## Testing Guidelines

The test framework is vendored and pinned at GdUnit4 v6.2.0. Name tests `test_<subject>.gd`. Unit-test deterministic logic, state transitions, damage, inventory, and serialization; use integration tests for scene loading and system boundaries. Every change should run the full test script plus headless validation. Add a regression test with each bug fix where practical.

## Commit & Pull Request Guidelines

The history currently contains only `Initial commit`; follow the documented Conventional Commit prefixes going forward: `feat:`, `fix:`, `test:`, `docs:`, `refactor:`, `perf:`, `build:`, `ci:`, and `chore:`. Use short-lived branches such as `feature/player-movement` or `fix/controller-deadzone` and squash-merge into `main`.

Pull requests should explain what changed and why, list verification performed, link relevant issues, pass CI, and include screenshots or video for visual changes. Document third-party asset provenance and never commit credentials, signing keys, tokens, or export credentials.

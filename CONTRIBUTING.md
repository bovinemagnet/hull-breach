# Contributing to Hull Breach

## Workflow

Use short-lived branches from `main`, such as `feature/player-movement`, `fix/controller-deadzone`, or `docs/testing-guide`. Keep changes focused and submit non-trivial work through a pull request. Squash merge after CI passes.

Commit messages use Conventional Commit-style prefixes:

```text
feat: add player movement
fix: correct controller deadzone
test: cover bootstrap scene loading
docs: clarify export setup
```

## Before Opening a Pull Request

Run:

```bash
./tools/validate.sh
./tools/test.sh
./tools/export-debug.sh
```

Explain what changed, why it changed, and how it was verified. Add screenshots or video for visual changes. Link relevant issues and avoid unrelated edits.

## Code and Assets

Follow Godot's GDScript conventions, prefer static typing, and keep feature files together under `features/`. Do not add global managers or new autoloads without a demonstrated cross-scene lifecycle need.

Before adding third-party content, verify its licence and record its author, source, download date, local path, use, and modification status in `THIRD_PARTY_ASSETS.md`. Never commit credentials, signing material, tokens, `.env` files, or Godot export credentials.

Engine upgrades require a dedicated `chore/godot-<version>` pull request and updates to `.godot-version`, documentation, tests, and export verification.

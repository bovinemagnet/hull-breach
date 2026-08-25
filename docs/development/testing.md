# Testing

Hull Breach pins GdUnit4 v6.2.0 under `addons/gdUnit4/`. This release line supports Godot 4.7; change it only in a dedicated dependency update with full validation. The vendored source is from the official `v6.2.0` release archive (`SHA-256: 1e9fb8d0259492c21bd8ebb90f0bbf5553337f7a1fe7253163a6d57ad0aa404c`).

Run the complete suite from the repository root:

```bash
./tools/test.sh
```

The script runs GdUnit4 headlessly against `tests/` and writes reports under ignored `build/reports/`. Windows users can run `./tools/test.ps1`. In the editor, use the enabled GdUnit4 plugin's test inspector.

Put deterministic logic tests in `tests/unit/test_<subject>.gd` and scene/system boundary tests in `tests/integration/test_<subject>.gd`. Test state changes, calculations, resource validation, serialization, and regressions. Avoid brittle tests for animation, transforms, or trivial node wiring.

Before submitting a pull request, run `./tools/validate.sh` and `./tools/test.sh`. The validator also checks content IDs, resource definitions, campaign scenes, and version consistency. For performance-sensitive changes, run:

```bash
./tools/profile-station-blackout.sh
./tools/profile-phase3.sh
```

The Phase 3 stress profile covers 50 mixed enemies and 100 projectiles. CI repeats validation and tests before producing the debug build. There is no percentage coverage gate; new systems and bug fixes require focused regression tests.

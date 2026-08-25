# Exporting

Install the Godot 4.7.2 export templates from the editor's **Editor > Manage Export Templates** dialog. Export templates must match the engine patch version.

Create the required Linux debug build from the repository root:

```bash
./tools/export-debug.sh
```

The executable is written to `build/linux/hull-breach.x86_64`. All generated exports belong under `build/` and must not be committed.

Create the versioned Linux Release Candidate, embed build identity, run its standalone startup smoke test, and generate a manifest plus SHA-256 checksums with:

```bash
./tools/export-release.sh linux
```

The archive is named `build/release/hull-breach-1.0.0-rc.1-linux-x86_64.tar.gz`. Use `windows`, `macos`, or `desktop` for review packages. `./tools/release-gate.sh linux` runs validation, tests, campaign profiling, packaging, and smoke verification in the required order.

`export_presets.cfg` defines production-configured Linux, Windows Desktop, macOS, Android AAB, and iOS baselines. Mobile exports require external SDKs and signing; the script requires `HULL_BREACH_SIGNING_READY=1` as an explicit operator acknowledgement. A configured preset or successful cross-export is not platform acceptance—complete `docs/release/platform_matrix.md` on real hardware.

Never commit signing certificates, keystores, passwords, or `.godot/export_credentials.cfg`. Build and publication are deliberately separate. The protected manual workflow produces review artifacts only; see `docs/release/signing.md` and `docs/release/launch_runbook.md`.

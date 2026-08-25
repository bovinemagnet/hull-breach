# Exporting

Install the Godot 4.7.2 export templates from the editor's **Editor > Manage Export Templates** dialog. Export templates must match the engine patch version.

Create the required Linux debug build from the repository root:

```bash
./tools/export-debug.sh
```

The executable is written to `build/linux/hull-breach.x86_64`. All generated exports belong under `build/` and must not be committed.

Create the versioned Beta release package and run its standalone startup smoke test with:

```bash
./tools/export-beta.sh
```

The archive is named `build/beta/hull-breach-0.8.0-linux-x86_64.tar.gz`. CI appends the source commit to its artifact name.

`export_presets.cfg` also defines unsigned Windows Desktop, macOS, Android AAB, and iOS baselines. Mobile and production exports require platform tooling, credentials, and the real-device checks listed in `beta-hardening.md`; a configured preset alone is not platform acceptance.

Never commit signing certificates, keystores, passwords, or `.godot/export_credentials.cfg`. CI installs matching templates, creates the Linux debug export, and retains it as the `hull-breach-linux-debug` artifact for seven days.

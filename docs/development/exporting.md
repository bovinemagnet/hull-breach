# Exporting

Install the Godot 4.7.2 export templates from the editor's **Editor > Manage Export Templates** dialog. Export templates must match the engine patch version.

Create the required Linux debug build from the repository root:

```bash
./tools/export-debug.sh
```

The executable is written to `build/linux/hull-breach.x86_64`. All generated exports belong under `build/` and must not be committed.

`export_presets.cfg` also defines unsigned Windows Desktop, macOS, Android, and iOS baselines. These are preparatory presets, not Phase 0 release targets. Mobile and production exports require later platform setup and credentials.

Never commit signing certificates, keystores, passwords, or `.godot/export_credentials.cfg`. CI installs matching templates, creates the Linux debug export, and retains it as the `hull-breach-linux-debug` artifact for seven days.

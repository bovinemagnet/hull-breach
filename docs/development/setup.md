# Development Setup

## Requirements

Install Git, Git LFS, and Godot 4.7.2 Standard. Do not use the .NET editor. The Compatibility renderer is the project baseline.

## Clean Setup

```bash
git clone https://github.com/bovinemagnet/hull-breach.git
cd hull-breach
./tools/bootstrap.sh
godot --editor --path .
```

The bootstrap script checks the pinned engine version, configures Git LFS for the clone, pulls LFS objects, and performs a headless import. On Windows, use `./tools/bootstrap.ps1` from PowerShell.

Run the main project with F6/F5. It opens `res://levels/dev/bootstrap.tscn` at a 640×360 logical resolution. Generated imports stay under ignored `.godot/`; generated builds stay under ignored `build/`.

## Engine Upgrades

Make engine upgrades in a dedicated `chore/godot-<version>` branch. Update `.godot-version` and README, import from a clean cache, run all tests, and create a Linux debug export before merging.

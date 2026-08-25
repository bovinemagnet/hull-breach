#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"

mkdir -p build/logs

"${godot_bin}" \
	--headless \
	--path . \
	--log-file build/logs/combat-profile.log \
	res://levels/dev/combat_sandbox/combat_stress.tscn

#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"

mkdir -p build/logs

"${godot_bin}" \
	--headless \
	--path . \
	--log-file build/logs/phase3-profile.log \
	--script res://tools/profile-phase3.gd

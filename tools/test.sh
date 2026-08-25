#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"

mkdir -p build/logs build/reports

"${godot_bin}" \
	--headless \
	--path . \
	--log-file build/logs/test.log \
	--script res://addons/gdUnit4/bin/GdUnitCmdTool.gd \
	--add tests \
	--report-directory res://build/reports \
	--ignoreHeadlessMode

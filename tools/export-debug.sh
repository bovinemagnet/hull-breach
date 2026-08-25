#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"
output_path="build/linux/hull-breach.x86_64"

mkdir -p build/linux build/logs
rm -f "${output_path}"

"${godot_bin}" \
	--headless \
	--path . \
	--log-file build/logs/export-debug.log \
	--export-debug \
	"Linux" \
	"${output_path}"

if [[ ! -x "${output_path}" ]]; then
	echo "Linux debug export was not created. Are the Godot 4.7.2 export templates installed?" >&2
	exit 1
fi

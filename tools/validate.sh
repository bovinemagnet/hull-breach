#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"

mkdir -p build/logs

"${godot_bin}" --headless --path . --log-file build/logs/validate.log --import --quit

echo "Godot project validation successful."

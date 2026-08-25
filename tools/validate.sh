#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"

mkdir -p build/logs

"${godot_bin}" --headless --path . --log-file build/logs/validate.log --import --quit
"${godot_bin}" --headless --path . --log-file build/logs/content-validation.log --script res://tools/content-validator.gd

echo "Godot project validation successful."

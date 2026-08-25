#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"
required_version="$(tr -d '[:space:]' < .godot-version)"

command -v git >/dev/null || { echo "Git is required." >&2; exit 1; }
command -v git-lfs >/dev/null || { echo "Git LFS is required. Install it and rerun this script." >&2; exit 1; }
command -v "${godot_bin}" >/dev/null || { echo "Godot ${required_version} Standard is required." >&2; exit 1; }

installed_version="$("${godot_bin}" --version)"
case "${installed_version}" in
	"${required_version}"*) ;;
	*) echo "Expected Godot ${required_version}; found ${installed_version}." >&2; exit 1 ;;
esac

git lfs install --local
git lfs pull
"${godot_bin}" --headless --path . --import --quit

echo "Hull Breach development environment is ready."

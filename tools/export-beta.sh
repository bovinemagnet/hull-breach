#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"
version="$(sed -n 's/^config\/version="\([^"]*\)"/\1/p' project.godot)"
output_dir="build/beta"
output_path="${output_dir}/hull-breach-${version}-linux-x86_64"
archive_path="${output_path}.tar.gz"
smoke_log="$(pwd)/build/logs/beta-smoke.log"

if [[ -z "${version}" ]]; then
	echo "Unable to read application version from project.godot" >&2
	exit 1
fi

mkdir -p "${output_dir}" build/logs
rm -f "${output_path}" "${archive_path}"

"${godot_bin}" \
	--headless \
	--path . \
	--log-file build/logs/export-beta.log \
	--export-release \
	"Linux" \
	"${output_path}"

if [[ ! -x "${output_path}" ]]; then
	echo "Linux Beta export was not created. Install Godot 4.7.2 export templates." >&2
	exit 1
fi

"${output_path}" --headless --log-file "${smoke_log}" --quit-after 2
tar -czf "${archive_path}" -C "${output_dir}" "$(basename "${output_path}")"

echo "Beta package created: ${archive_path}"

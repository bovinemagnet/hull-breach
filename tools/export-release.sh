#!/usr/bin/env bash

set -euo pipefail

godot_bin="${GODOT_BIN:-godot}"
target="${1:-linux}"
version="$(sed -n 's/^config\/version="\([^"]*\)"/\1/p' project.godot)"
expected_version="${RELEASE_VERSION:-${version}}"
release_dir="build/release"
metadata_path="core/utilities/build_metadata.generated.cfg"
commit="${HULL_BREACH_BUILD_ID:-$(git rev-parse --short=12 HEAD 2>/dev/null || echo unknown)}"
build_date="${HULL_BREACH_BUILD_DATE:-$(git show -s --format=%cs HEAD 2>/dev/null || date -u +%F)}"
channel="${HULL_BREACH_RELEASE_CHANNEL:-Release Candidate}"
godot_version="$(${godot_bin} --version | head -n 1)"
artifacts=()
temporary_dirs=()

if [[ -z "${version}" || "${version}" != "${expected_version}" ]]; then
	echo "Release version mismatch: project=${version:-missing}, requested=${expected_version}" >&2
	exit 1
fi
if [[ ! "${version}" =~ ^1\.0\.0(-rc\.[0-9]+)?$ ]]; then
	echo "Release exports require 1.0.0-rc.N or 1.0.0, got ${version}" >&2
	exit 1
fi
if [[ "${godot_version}" != 4.7.2* ]]; then
	echo "Godot 4.7.2 is frozen for this release, got ${godot_version}" >&2
	exit 1
fi

mkdir -p "${release_dir}" build/logs
printf '[build]\nversion="%s"\ncommit="%s"\ndate="%s"\nchannel="%s"\n' \
	"${version}" "${commit}" "${build_date}" "${channel}" > "${metadata_path}"
cleanup() {
	rm -f "${metadata_path}"
	for temporary_dir in "${temporary_dirs[@]}"; do
		if [[ -n "${temporary_dir}" && "${temporary_dir}" == "${release_dir}/"* ]]; then
			rm -rf "${temporary_dir}"
		fi
	done
}
trap cleanup EXIT

copy_notices() {
	local destination="$1"
	cp LICENSE PRIVACY.md THIRD_PARTY_NOTICES.md "${destination}/"
}

export_linux() {
	local package_name="hull-breach-${version}-linux-x86_64"
	local staging
	staging="$(mktemp -d "${release_dir}/linux.XXXXXX")"
	temporary_dirs+=("${staging}")
	mkdir -p "${staging}/${package_name}"
	"${godot_bin}" --headless --path . --log-file build/logs/export-release-linux.log \
		--export-release "Linux" "${staging}/${package_name}/hull-breach"
	if [[ ! -x "${staging}/${package_name}/hull-breach" ]]; then
		echo "Linux release export was not created" >&2
		exit 1
	fi
	copy_notices "${staging}/${package_name}"
	local smoke_log="$(pwd)/build/logs/release-linux-smoke.log"
	"${staging}/${package_name}/hull-breach" --headless --log-file "${smoke_log}" --quit-after 2
	if ! grep -Fq "Version: ${version}" "${smoke_log}" || ! grep -Fq "Commit: ${commit}" "${smoke_log}"; then
		echo "Linux release does not expose the embedded build identity" >&2
		exit 1
	fi
	local archive="${release_dir}/${package_name}.tar.gz"
	tar -czf "${archive}" -C "${staging}" "${package_name}"
	rm -rf "${staging}"
	artifacts+=("${archive}")
}

export_windows() {
	local package_name="hull-breach-${version}-windows-x86_64"
	local staging
	staging="$(mktemp -d "${release_dir}/windows.XXXXXX")"
	temporary_dirs+=("${staging}")
	mkdir -p "${staging}/${package_name}"
	"${godot_bin}" --headless --path . --log-file build/logs/export-release-windows.log \
		--export-release "Windows Desktop" "${staging}/${package_name}/HullBreach.exe"
	if [[ ! -f "${staging}/${package_name}/HullBreach.exe" ]]; then
		echo "Windows release export was not created" >&2
		exit 1
	fi
	copy_notices "${staging}/${package_name}"
	local archive="$(pwd)/${release_dir}/${package_name}.zip"
	(cd "${staging}" && zip -qr "${archive}" "${package_name}")
	rm -rf "${staging}"
	artifacts+=("${archive}")
}

export_macos() {
	local package_name="HullBreach-${version}-macos"
	local staging
	staging="$(mktemp -d "${release_dir}/macos.XXXXXX")"
	temporary_dirs+=("${staging}")
	"${godot_bin}" --headless --path . --log-file build/logs/export-release-macos.log \
		--export-release "macOS" "${staging}/HullBreach.zip"
	if [[ ! -f "${staging}/HullBreach.zip" ]]; then
		echo "macOS release export was not created" >&2
		exit 1
	fi
	mkdir -p "${staging}/${package_name}"
	(cd "${staging}/${package_name}" && unzip -q ../HullBreach.zip)
	copy_notices "${staging}/${package_name}"
	local archive="$(pwd)/${release_dir}/${package_name}.zip"
	(cd "${staging}" && zip -qr "${archive}" "${package_name}")
	rm -rf "${staging}"
	artifacts+=("${archive}")
}

require_signing_acknowledgement() {
	if [[ "${HULL_BREACH_SIGNING_READY:-0}" != "1" ]]; then
		echo "Mobile RC export requires configured external signing and HULL_BREACH_SIGNING_READY=1" >&2
		exit 1
	fi
}

export_android() {
	require_signing_acknowledgement
	local artifact="${release_dir}/hull-breach-${version}.aab"
	"${godot_bin}" --headless --path . --log-file build/logs/export-release-android.log \
		--export-release "Android" "${artifact}"
	artifacts+=("${artifact}")
}

export_ios() {
	require_signing_acknowledgement
	local artifact="${release_dir}/HullBreach-${version}-ios.zip"
	"${godot_bin}" --headless --path . --log-file build/logs/export-release-ios.log \
		--export-release "iOS" "${artifact}"
	artifacts+=("${artifact}")
}

case "${target}" in
	linux) export_linux ;;
	windows) export_windows ;;
	macos) export_macos ;;
	desktop) export_linux; export_windows; export_macos ;;
	android) export_android ;;
	ios) export_ios ;;
	*) echo "Usage: $0 {linux|windows|macos|desktop|android|ios}" >&2; exit 2 ;;
esac

manifest="${release_dir}/manifest-${version}-${target}.json"
printf '{\n  "version": "%s",\n  "commit": "%s",\n  "build_date": "%s",\n  "channel": "%s",\n  "godot": "%s",\n  "target": "%s"\n}\n' \
	"${version}" "${commit}" "${build_date}" "${channel}" "${godot_version}" "${target}" > "${manifest}"
artifacts+=("${manifest}")

checksums="${release_dir}/SHA256SUMS-${version}-${target}.txt"
: > "${checksums}"
for artifact in "${artifacts[@]}"; do
	(cd "${release_dir}" && sha256sum "$(basename "${artifact}")") >> "${checksums}"
done

echo "Release artifacts created for ${version} (${commit}):"
printf '  %s\n' "${artifacts[@]}" "${checksums}"

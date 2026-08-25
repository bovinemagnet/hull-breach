#!/usr/bin/env bash

set -euo pipefail

target="${1:-linux}"

./tools/validate.sh
./tools/test.sh
./tools/profile-campaign.sh
./tools/export-release.sh "${target}"

echo "Release Candidate gate passed for ${target}. Manual platform and sign-off gates remain required."

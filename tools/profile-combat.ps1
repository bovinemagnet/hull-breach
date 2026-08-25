$ErrorActionPreference = "Stop"

$godotBin = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }

New-Item -ItemType Directory -Force -Path "build/logs" | Out-Null

& $godotBin `
  --headless `
  --path . `
  --log-file build/logs/combat-profile.log `
  res://levels/dev/combat_sandbox/combat_stress.tscn

if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

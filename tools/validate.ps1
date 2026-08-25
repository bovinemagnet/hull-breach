$ErrorActionPreference = "Stop"
$GodotBin = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }

New-Item -ItemType Directory -Force -Path "build/logs" | Out-Null
& $GodotBin --headless --path . --log-file build/logs/validate.log --import --quit
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Godot project validation successful."

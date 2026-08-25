$ErrorActionPreference = "Stop"
$GodotBin = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }
$OutputPath = "build/linux/hull-breach.x86_64"

New-Item -ItemType Directory -Force -Path "build/linux", "build/logs" | Out-Null
Remove-Item -Force -ErrorAction SilentlyContinue $OutputPath
& $GodotBin --headless --path . --log-file build/logs/export-debug.log --export-debug "Linux" $OutputPath
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if (-not (Test-Path $OutputPath -PathType Leaf)) {
  throw "Linux debug export was not created. Are the Godot 4.7.2 export templates installed?"
}

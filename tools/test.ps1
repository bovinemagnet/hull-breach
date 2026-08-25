$ErrorActionPreference = "Stop"
$GodotBin = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }

New-Item -ItemType Directory -Force -Path "build/logs", "build/reports" | Out-Null
& $GodotBin --headless --path . --log-file build/logs/test.log --script res://addons/gdUnit4/bin/GdUnitCmdTool.gd --add tests --report-directory res://build/reports --ignoreHeadlessMode
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

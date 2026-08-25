$ErrorActionPreference = "Stop"
$GodotBin = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }
$RequiredVersion = (Get-Content ".godot-version" -Raw).Trim()

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git is required." }
if (-not (Get-Command git-lfs -ErrorAction SilentlyContinue)) { throw "Git LFS is required." }
if (-not (Get-Command $GodotBin -ErrorAction SilentlyContinue)) { throw "Godot $RequiredVersion Standard is required." }

$InstalledVersion = (& $GodotBin --version)
if (-not $InstalledVersion.StartsWith($RequiredVersion)) {
  throw "Expected Godot $RequiredVersion; found $InstalledVersion."
}

git lfs install --local
git lfs pull
& $GodotBin --headless --path . --import --quit
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Hull Breach development environment is ready."

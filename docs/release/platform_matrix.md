# Release Platform Matrix

Only evidence from the exact candidate artifact counts. `Pending` means the platform must not be advertised or shipped yet.

| Platform | Package | Required evidence | Status |
| --- | --- | --- | --- |
| Linux x86_64 | `.tar.gz` | Clean extract/launch, executable bit, audio, save, fullscreen, controller | Automated package smoke available; hardware playthrough pending |
| Windows x86_64 | `.zip` | Clean non-admin machine, high DPI, save, fullscreen, Xbox/PlayStation pads | Pending hardware and signing decision |
| macOS universal | `.zip` | Intel/Apple Silicon launch, Retina, save, controller, signing/notarization | Pending macOS hardware and credentials |
| Android | Signed `.aab` | Internal-store install, 0.8.0 upgrade, touch, lifecycle, safe areas, 30-minute thermal | Pending SDK, keystore, store, and devices |
| iOS | Signed archive | TestFlight install, upgrade, touch/controller, lifecycle, safe areas | Pending Apple team, provisioning, TestFlight, and devices |
| Steam Deck | Linux depot | 1280×800 readability, gamepad-only campaign, suspend/resume, performance | Pending Steam access and hardware |

For each run record: version, commit, checksum, device/OS, resolution, input, install source, mission coverage, duration, average/worst performance, suspend/resume result, tester, date, and evidence link.

## Current Support Claim

The repository provides production-configured presets for five platforms. A preset is not certification. Until the rows above pass, release claims must be restricted to platforms with completed evidence.

# Beta Hardening

Version 0.8.0 is under feature freeze. Accept bug, performance, balance, accessibility, usability, platform-compatibility, presentation, and release-required changes. New missions, enemies, weapons, objective types, or persistence concepts require explicit scope review.

## Automated Gates

Run `./tools/validate.sh`, `./tools/test.sh`, `./tools/profile-campaign.sh`, and `./tools/export-beta.sh`. CI validates all content IDs and five platform presets, exercises every objective/checkpoint boundary, tests save migration/integrity/recovery, profiles all missions, and smoke-tests the standalone Linux Beta package. A release candidate requires zero P0/P1 issues.

## Manual Platform Matrix

Do not mark an untested platform as passing. Record device/OS, build ID, resolution, input, duration, average/worst performance, suspend/resume, and result.

| Platform | Required checks | Status |
| --- | --- | --- |
| Windows | 720p–4K, fullscreen, alt-tab, Xbox/PlayStation controllers | Pending hardware |
| Linux | packaged launch, audio, fullscreen, controller | Automated smoke; playtest pending |
| macOS | Retina, fullscreen, controller, signing path | Pending hardware |
| Android | AAB install/update, touch safe areas, lifecycle, 30-minute thermal | Pending device |
| iOS | install, safe areas, lifecycle, controller, TestFlight path | Pending device |
| Steam Deck | 1280×800, suspend/resume, 60 FPS, readable text | Pending hardware |

## Playtest Record

For each mission capture difficulty, input method, completion time, deaths, ammo/health remaining, navigation confusion, unfair enemy, and blocker. Complete at least one keyboard/mouse and one controller campaign; complete several mobile missions and preferably one mobile campaign.

## Bug Reports

Use severity P0 blocker, P1 critical, P2 major, P3 minor, or P4 polish. Include build, platform, mission/room, difficulty, input, checkpoint, reproduction steps, expected/actual result, frequency, and supporting media/logs. Reproduce first; add regression coverage for state, save, inventory, checkpoint, and progression defects where practical.

# Campaign Alpha

Version 0.5.0 contains the complete eight-mission campaign path. `CampaignCatalog` owns stable ordering and scene paths; missions 3–8 use `CampaignMissionProfile` resources beside their scenes. Keep mission IDs stable even if folders move.

## Mission Matrix

| Mission | Identity | Introduction | Checkpoints |
| --- | --- | --- | --- |
| Station Blackout | Access, power, noise | Pulse Rifle | Start plus major systems |
| Medical Wing | Hazards and route choice | Hunter, Spitter, Shotgun | 4 |
| Cargo Deck | Large-space crowd control | Swarm | 4 |
| Research Sector | Darkness and ambush | Stalker, Plasma Cutter | 4 |
| Engineering Complex | Layered system restoration | Combined roster | 4 |
| Reactor Core | Local time pressure | Incinerator | 4 |
| The Hive | Organic route changes | Brood Entity | 4 |
| Evacuation | Full-system escape | Brute | 4 |

## Content Rules

Every mission requires a valid definition, matching objective positions, an extraction objective, stable checkpoint/objective IDs, briefing, ambience identity, encounters, and a smoke test. Use `./tools/validate.sh` to detect missing scenes, duplicate IDs, or invalid resources. Run `./tools/profile-campaign.sh` after changing encounter density.

The sidearm remains a reliable fallback. Acquired weapons and ammunition persist in campaign saves. Reactor timeout opens a damaging fallback route instead of ending the mission.

## Alpha Audit

Runtime-drawn environment, character, and tone assets are classified `PLACEHOLDER`; they are original and have no external licence requirement. Godot and GdUnit4 attribution is available from the Credits screen and `THIRD_PARTY_ASSETS.md`. Replace presentation without changing stable content IDs.

Physical Android/iOS, controller-only, Steam Deck, blind-playtest, balance, and 3–5 hour duration acceptance remain manual gates. Record results by mission, checkpoint, platform, difficulty, completion time, deaths, health, and ammunition.

## Headless Performance Baseline

Measured on 2026-08-25 with `./tools/profile-campaign.sh`:

| Mission | Average frame |
| --- | ---: |
| Station Blackout | 16.407 ms |
| Medical Wing | 16.526 ms |
| Cargo Deck | 16.410 ms |
| Research Sector | 16.406 ms |
| Engineering Complex | 16.428 ms |
| Reactor Core | 16.402 ms |
| The Hive | 16.408 ms |
| Evacuation | 16.403 ms |

All remain below the 16.667 ms desktop budget. Mobile measurements are still required on representative hardware.

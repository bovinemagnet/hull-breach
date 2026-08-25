# Changelog

## Unreleased

## 0.8.0 - 2026-08-25

### Added

- Beta lifecycle service with controller disconnect pausing, input-method prompts, mobile safe-area handling, and vibration control.
- Campaign-wide objective/checkpoint regression coverage, pause context, restart-mission flow, build identification, and Beta packaging.
- Release/privacy documentation, five-platform preset audit, and campaign p95/p99/memory profiling.

### Changed

- Save schema 3 adds integrity metadata, structural validation, atomic promotion, rollback, and backup/interrupted-write recovery.
- Mission events are sequence-independent, preventing early interactions from creating objective soft locks.
- Settings writes are atomic and recoverable; checkpoint restores sanitize unsafe values and grant a short recovery grace period.

## 0.5.0 - 2026-08-25

### Added

- Complete eight-mission campaign progression from New Game through ending and credits.
- Cargo Deck, Research Sector, Engineering Complex, Reactor Core, The Hive, and Evacuation missions.
- Swarm, Stalker, Brute, and Brood Entity enemies plus light-aware ambush and armour roles.
- Plasma Cutter and Incinerator weapons with five-slot persistent campaign loadouts.
- Timed objective consequences, mission select, campaign validation, smoke tests, and profiling.

## 0.2.0 - 2026-08-25

### Added

- Complete Station Blackout vertical-slice mission with seven sequential objectives.
- Reusable interactions, powered/access-controlled doors, terminals, credentials, and checkpoints.
- Facility power transformation, emergency lighting, flashlight, environmental ambience, and pickups.
- Configurable noise propagation plus Drone hearing, investigation, search, vision, and navigation.
- Mission HUD, extraction flow, debug tools, and landscape twin-stick Android controls.

## 0.1.0 - 2026-08-25

### Added

- Playable combat sandbox with open, corridor, obstacle, and side-room encounters.
- Responsive keyboard/controller movement and independent mouse/controller aiming.
- Data-driven HB-4 Pulse Rifle, physical projectiles, ammunition, reload, and pickups.
- Reusable health, structured damage, Drone pursuit/melee combat, and death flows.
- Signal-driven combat HUD, crosshair, pause menu, restart flow, and debug controls.
- Original code-drawn prototype visuals and generated combat sound effects.
- Deterministic combat tests and repeatable 50-Drone stress profiling scene.

## 0.0.1 - 2026-08-25

### Added

- Initial Godot project.
- Development bootstrap scene.
- Automated testing infrastructure.
- CI validation and Linux debug export.

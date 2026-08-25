# Architecture

Hull Breach uses Godot scenes, nodes, resources, local signals, and named InputMap actions. Gameplay is organized by feature under `features/`; shared infrastructure belongs in `core/` only when multiple features genuinely need it.

Phase 1 establishes composition-based combat. `HealthComponent` owns health rules; `WeaponDefinition`, `PlayerConfig`, and `EnemyDefinition` resources own tuning; runtime scenes own behaviour; and local signals feed the HUD. `DamageInfo` carries source and impact context across combat boundaries. The combat sandbox owns only level lifecycle concerns such as spawning, pause, and restart.

Phase 2 adds reusable interaction, access, power, noise, mission, and checkpoint modules. `StationBlackout` composes those systems and owns only mission-specific orchestration. Doors, terminals, lights, weapons, and enemy listeners communicate through signals and configuration resources; no campaign autoload is required for the in-memory checkpoint boundary.

There is no global event bus, dependency container, combat manager, or manager autoload. Record durable technical choices in `docs/adr/` as the game reveals concrete needs.

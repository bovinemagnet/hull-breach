# Production Level Authoring

Start conventional campaign maps from `levels/templates/production_level_template.tscn`. Save the inherited scene under `levels/campaign/<mission_id>/`, assign a `MissionDefinition`, then add the shared Player, HUD, power, noise, and checkpoint scenes used by the existing campaign missions.

## Encounter Workflow

1. Place `EnemySpawnPoint` nodes under `SpawnPoints` and give each a stable, unique `id` such as `ward_north`.
2. Create `WaveDefinition` resources listing spawn-point IDs, enemy scenes, counts, delays, and spawn intervals.
3. Add those waves to an `EncounterDefinition` with an ID and active-enemy limits.
4. Instantiate `features/encounters/encounter.tscn`. Assign its definition and NodePaths for the spawn root, enemy parent, player target, and optional noise system.
5. Enable `auto_start` or call `start()` from a generic trigger or mission event. Use the `completed` signal to unlock the next authored beat.

Encounters enforce per-frame spawn and active-enemy budgets. Reuse Drone, Hunter, and Spitter scenes directly; do not duplicate their AI scripts.

## Validation Checklist

- Use stable `snake_case` IDs; display text may change independently.
- Keep collision, navigation, doors, hazards, and spawn positions visually aligned.
- Configure hazards through `HazardDefinition` and power circuits.
- Place health and ammo according to the selected difficulty budget.
- Run `./tools/validate.sh`, `./tools/test.sh`, and the appropriate performance profile before review.

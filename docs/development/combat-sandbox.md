# Combat Sandbox

Phase 1 is the first playable Hull Breach milestone. Launch the project with F6/F5 or run the sandbox directly:

```bash
godot --path . res://levels/dev/combat_sandbox/combat_sandbox.tscn
```

The arena is deliberately larger than the viewport and includes open ground, a narrow central route, wall obstacles, side rooms, two ammunition pickups, and seven starting Drones.

## Controls

| Action | Mouse and keyboard | Controller |
| --- | --- | --- |
| Move | WASD or arrow keys | Left stick |
| Aim | Mouse | Right stick |
| Fire | Left mouse | Right trigger |
| Reload | R | X / Square |
| Pause | Escape | Menu / Start |

Aim is independent from movement. Releasing the right stick preserves its last valid direction. The pause and death overlays support keyboard, mouse, and controller focus navigation.

Debug exports additionally provide:

- `F1`: spawn one Drone
- `F2`: spawn ten Drones
- `F3`: clear Drones
- `F4`: toggle invulnerability
- `F5`: restore player health
- `F6`: refill rifle ammunition
- `F7`: spawn fifty Drones

## Combat Architecture

`HealthComponent` provides reusable health and one-shot death rules. Damage crosses object boundaries as a minimal `DamageInfo` value. Player, weapon, and enemy tuning is stored in custom resources rather than behaviour scripts. The rifle emits ammunition and reload signals observed by `CombatHud`; it never references the HUD directly.

The HB-4 Pulse Rifle starts at 20 damage, eight rounds per second, 30 magazine rounds, 120 reserve rounds, and a 1.6-second reload. Drones start at 50 health, move at 90 pixels per second, and deal 10 melee damage after a short telegraph. These values intentionally make one Drone easy and groups progressively more dangerous.

## Verification and Profiling

Run the deterministic and scene-boundary checks with:

```bash
./tools/test.sh
```

The suite covers health limits, single death emission, definition validation, ammunition transfer, fire-rate enforcement, enemy cooldown, sandbox loading, three-hit Drone death, and a 50-Drone spawn.

Run the repeatable headless stress baseline with:

```bash
./tools/profile-combat.sh
```

It simulates 600 process frames with 50 Drones and records frame average and node count in `build/logs/combat-profile.log`. Use the Godot profiler in a rendered development build for final GPU and 60 FPS acceptance; headless throughput is a regression indicator, not a hardware benchmark.

The 2026-08-25 Phase 1 baseline completed with 50 active Drones, 409 nodes, and 6.891 ms average headless process time on the primary development machine.

## Prototype Asset Status

All Phase 1 player, weapon, projectile, Drone, pickup, impact, environment, and HUD visuals are **PROTOTYPE** code-drawn shapes. Combat audio is **PROTOTYPE** runtime synthesis. None is considered final art or sound, and no third-party gameplay assets are included.

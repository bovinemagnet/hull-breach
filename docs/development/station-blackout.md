# Station Blackout

Station Blackout is the Phase 2 vertical slice and default scene. Run it with F6/F5 or directly:

```bash
godot --path . --scene res://levels/campaign/station_blackout/station_blackout.tscn
```

## Mission and Controls

Use WASD or the left stick to move, mouse or the right stick to aim, left mouse/trigger to fire, E/A to interact, R/X to reload, and Escape/Start to pause. On Android, two virtual sticks plus Use, Reload, and Pause controls provide the same actions.

The objective HUD guides the full sequence: inspect Communications, collect Engineering access in Security, enter Engineering, restore auxiliary power, return to Communications, transmit the distress signal, and reach Extraction. Gunshots and doors produce noise; nearby Drones investigate the source before searching. Main power activates blue facility lights, Communications, and a return shortcut. Death restarts from the latest of four in-memory checkpoints.

## Debug Controls

- F1: toggle mission state overlay
- F2: grant Engineering access
- F3: toggle main power
- F4: emit test noise
- F5: trigger the alarm and extraction
- F6: complete the active objective
- F7: reload the current checkpoint
- F8: show or hide touch controls on desktop

## Validation

Run `./tools/validate.sh`, `./tools/test.sh`, and `bash ./tools/profile-station-blackout.sh` before submitting changes. The profiler exercises 20 navigation enemies, weapon projectiles, lights, and repeated noise events against the 16.67 ms desktop target. Real-device Android performance, safe areas, full touch completion, and blind-playtest reactions remain manual acceptance checks.

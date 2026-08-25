# Architecture

Hull Breach uses Godot scenes, nodes, resources, local signals, and named InputMap actions. Gameplay is organized by feature under `features/`; shared infrastructure belongs in `core/` only when multiple features genuinely need it.

Phase 0 intentionally defines no gameplay architecture, global event bus, dependency container, or manager autoloads. Record durable technical choices in `docs/adr/` as the game reveals concrete needs.

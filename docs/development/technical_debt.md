# Technical Debt Register

This register records deliberate constraints discovered while reviewing the Phase 2 vertical slice. Priorities reflect impact on campaign production rather than cosmetic cleanliness.

## TD-001 — Mission composition remains code-assisted

- **Description:** Station Blackout creates some geometry and content from its mission script.
- **Impact:** Visual iteration is less editor-centric than the production target.
- **Priority:** Medium
- **Resolution:** Phase 3 introduces shared level builders, encounters, hazards, and a documented template; migrate more geometry when final tiles arrive.

## TD-002 — Prototype presentation is runtime-generated

- **Description:** Lights, tiles, enemy shapes, and audio use generated placeholder resources.
- **Impact:** Presentation cannot reach shipping quality without an asset replacement pass.
- **Priority:** Medium
- **Resolution:** Phase 4 classifies these assets explicitly as Alpha placeholders; replace them during the Beta presentation pass without changing content IDs.

## TD-003 — Checkpoints omit live enemy transforms

- **Description:** Saves restore authored world state and encounters, not each surviving enemy position.
- **Impact:** Resumed encounters may restart from their configured state.
- **Priority:** Low
- **Resolution:** Defer unless playtesting shows encounter restart is unfair.

## TD-004 — Mobile acceptance needs physical hardware

- **Description:** Touch controls and exports can be validated in software, but thermal behavior and safe areas require a device.
- **Impact:** Mobile performance cannot be signed off in CI.
- **Priority:** High
- **Resolution:** Required manual Alpha gate; complete real-device Android/iOS, controller-first, and blind-playtest passes before declaring the milestone release-ready.

## TD-005 — Runtime level tiles are prototype authoring data

- **Description:** Current missions populate TileMapLayers from code-authored prototype tiles.
- **Impact:** Final environment painting awaits the production tileset.
- **Priority:** Medium
- **Resolution:** Replace the runtime atlas with authored TileSet resources during Phase 4 without changing mission structure.

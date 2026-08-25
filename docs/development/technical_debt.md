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
- **Resolution:** Phase 5 adds lifecycle pausing, safe-area layout, input release, AAB configuration, and a manual test matrix. Real-device Android/iOS, controller-first, thermal, and blind-playtest passes remain release gates.

## TD-006 — Beta platform matrix needs hardware evidence

- **Description:** Linux startup is automated, while Windows, macOS, Android, iOS, and Steam Deck acceptance still requires representative hardware.
- **Impact:** Phase 5 code and presets are complete, but those platform rows cannot honestly be marked passing in CI.
- **Priority:** High
- **Resolution:** Record results in `docs/development/beta-hardening.md` before Phase 6 release-candidate approval.

## TD-007 — External Release Candidate approvals are outstanding

- **Status:** Open release blocker for affected platforms.
- **Context:** Signing/notarization, store submissions, content ratings, final screenshots/trailer, clean-device campaigns, and the Windows/macOS/mobile/Steam Deck evidence matrix require credentials, accounts, hardware, or business decisions unavailable to repository automation.
- **Resolution:** Complete `docs/release/release_checklist.md` and `docs/release/platform_matrix.md` against one immutable candidate before advertising or tagging production.

## TD-005 — Runtime level tiles are prototype authoring data

- **Description:** Current missions populate TileMapLayers from code-authored prototype tiles.
- **Impact:** Final environment painting awaits the production tileset.
- **Priority:** Medium
- **Resolution:** Replace the runtime atlas with authored TileSet resources during Phase 4 without changing mission structure.

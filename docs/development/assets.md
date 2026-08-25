# Asset Policy

Store original project assets in `assets/original/`. Store external packs under `assets/third_party/<creator>/<pack>/`; do not mix unrelated sources in a common directory.

Before merging any external asset:

1. verify its licence permits the intended use;
2. record it in `THIRD_PARTY_ASSETS.md`;
3. include a nearby `SOURCE.md` when practical;
4. identify whether it was modified.

An unknown or unrecorded licence means the asset must not be used. Keep the Phase 0 repository small; bulk prototype art belongs in a later phase.

Large editable/source formats (`.aseprite`, `.psd`, `.kra`, `.blend`, `.wav`, `.flac`, `.mp4`, and `.mov`) use Git LFS. PNG sprites and tilesheets remain in normal Git unless their size justifies a reviewed exception.

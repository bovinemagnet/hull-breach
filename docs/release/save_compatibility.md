# Save Compatibility Matrix

Schema 3 is frozen for 1.0. Release-candidate work must not introduce a new schema. Saves and settings use Godot `user://`; campaign data is stored in `campaign_save.json` with backup/recovery files, and settings in `settings.json` with a backup.

Default support locations are:

- Windows: `%APPDATA%\Godot\app_userdata\Hull Breach\`
- macOS: `~/Library/Application Support/Godot/app_userdata/Hull Breach/`
- Linux: `$XDG_DATA_HOME/godot/app_userdata/Hull Breach/`, normally `~/.local/share/godot/app_userdata/Hull Breach/`
- Android/iOS: the application sandbox; use platform support tooling rather than asking players to browse it

| Scenario | Expected result | Automated | Exact-package evidence |
| --- | --- | --- | --- |
| Fresh install/New Game | Valid schema-3 save; Continue enabled | Covered | Pending RC playthrough |
| 0.8.0 Beta → RC | Existing schema-3 progress/settings retained | Covered by schema/round-trip tests | Pending installed Beta fixture |
| RC → production | Save retained with unchanged schema | Logic covered | Pending production package |
| Backup recovery | Primary restored from last valid backup | Covered | Pending package spot check |
| Interrupted write | Valid temporary save promoted | Covered | Pending package spot check |
| Corrupted/tampered save | Reject safely; recover backup or show damaged-save UX | Covered | Pending package spot check |
| Missing save | Continue disabled; New Game works | Covered | Pending package spot check |
| Campaign completion | Ending state persists; credits return to menu | Covered by progression smoke tests | Pending full playthrough |

Never test upgrade behavior with a different application ID: changing `com.hullbreach.game` creates a separate installation and invalidates the result.

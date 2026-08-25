# Signing and Notarization

Signing material never belongs in Git, build artifacts, logs, issue attachments, or repository documentation. Store credentials in the platform account or protected CI environment and limit production workflow approval.

## Platform Decisions

- **Windows:** Build the ZIP unsigned for internal review. Before direct public distribution, either sign `HullBreach.exe` with an approved code-signing identity or record approval to rely on store signing.
- **macOS:** Use the final bundle ID `com.hullbreach.game`, Developer ID/App Store distribution identity, hardened runtime as required, notarization, and stapling. Validate the resulting archive on a clean Mac.
- **Android:** Use the final application ID `com.hullbreach.game`, version code `10001`, Play App Signing or the approved release keystore, and a signed AAB. Back up the keystore and recovery information outside the repository.
- **iOS:** Use the final bundle ID, Apple distribution certificate, provisioning profile, App Store Connect team, and build `10001`. Validate the exact TestFlight candidate.
- **Linux:** No platform signature is required for the tarball; publish its SHA-256 checksum and verify executable permissions.

`./tools/export-release.sh android|ios` refuses to run without `HULL_BREACH_SIGNING_READY=1`. That acknowledgement does not supply or validate credentials; the operator must configure Godot export credentials locally or through protected CI.

Build and publish remain separate actions. Review signatures, manifests, smoke results, and checksums before any store upload or public release.

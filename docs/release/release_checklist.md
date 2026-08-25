# Release Checklist

This is the authoritative procedure for every Hull Breach release candidate. Record an immutable commit, workflow run, artifact checksum, tester, date, and evidence link. Never infer a pass from an earlier build.

## Candidate Identity

- [ ] Freeze code, content, assets, dependencies, localization, and balance.
- [ ] Confirm `project.godot`, `GameVersion`, platform manifests, and store copy use the approved version.
- [ ] Record commit, build date, channel, Godot 4.7.2, and GdUnit4 6.2.0.
- [ ] Confirm P0 = 0, P1 = 0, and every accepted P2 meets `known_issues.md`.

## Automated Gate

- [ ] Run `./tools/release-gate.sh linux` from a clean checkout.
- [ ] Confirm validation, all tests, campaign profiling, release export, embedded identity smoke test, manifest, and SHA-256 checksums pass.
- [ ] Run the protected **Release Candidate Build** workflow for each unsigned target.
- [ ] Archive workflow logs and artifacts; verify checksums after download.

## Product Regression

- [ ] Complete the campaign from New Game through credits in the exact release package.
- [ ] Continue at every mission boundary and representative checkpoints.
- [ ] Test a fresh save, 0.8.0 Beta upgrade, backup recovery, corruption, missing save, and settings persistence.
- [ ] Exercise death, restart checkpoint, restart mission, quit, resume, and campaign completion.

## Platform, Input, and Accessibility

- [ ] Complete every applicable row in `platform_matrix.md` on real hardware.
- [ ] Verify keyboard/mouse, controller-only, touch-only, hot-plug, focus loss, and suspend/resume.
- [ ] Verify fullscreen, scaling, safe areas, reduced flash, screen shake, vibration, and UI scale.

## Legal, Store, and Sign-off

- [ ] Re-run the asset, license, privacy, network, and permission audit.
- [ ] Approve final store metadata, ratings, screenshots, trailer, support route, and tested system requirements.
- [ ] Produce signed/notarized packages using `signing.md`; do not archive credentials.
- [ ] Verify clean install/update, package identity, signature, version, launch, save, and checksum for every artifact.
- [ ] Obtain gameplay, engineering, QA, art, audio, legal, platform, and store sign-off.

Do not create `v1.0.0` until every required box has evidence. RC2 is created only for a release-blocking RC1 change and repeats this entire gate.

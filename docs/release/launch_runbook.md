# Launch Runbook

## Build and Review

1. Freeze `release/1.0`; triage every open issue as blocker, post-launch, or explicitly accepted.
2. Select the exact commit and run the protected **Release Candidate Build** workflow with the matching version.
3. Download artifacts and logs, then verify every entry in `SHA256SUMS-*`.
4. Complete `release_checklist.md`, the save matrix, full campaign playthrough, and every advertised platform row.
5. Produce signed/notarized store packages according to `signing.md`; archive packages, manifests, checksums, logs, and evidence without credentials.
6. Review final store copy, screenshots, trailer, ratings, privacy declarations, support route, and tested requirements.

## Publish

1. Obtain explicit gameplay, engineering, QA, art, audio, legal, platform, and store sign-off for one immutable commit.
2. Tag the approved commit `v1.0.0`; never move the tag.
3. Build or select only artifacts traced to that commit. Re-verify filename, version, signature, ID, startup, save behavior, and checksum.
4. Upload to private/store review channels. Publication requires a separate manual approval.
5. Publish concise release notes and enable only platforms with completed evidence.

## Rollback and Monitoring

If a blocker appears, pause publication or the affected platform, preserve reports/artifacts, and open a P0/P1 issue. Use `hotfix/1.0.1` for the smallest safe fix, repeat the complete release gate, and publish a new immutable version. Never silently replace an artifact.

Monitor launch, crash/startup reports, save integrity, mission progression, controller/touch behavior, and store feedback. Ask support reports for version, commit, platform, mission, checkpoint, reproduction, and logs. Do not request credentials or unrelated personal data.

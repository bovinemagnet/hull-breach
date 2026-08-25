# Release Versioning

Hull Breach uses semantic product versions and monotonically increasing store build numbers.

| Candidate | Product version | Android code | Apple build |
| --- | --- | --- | --- |
| RC1 | `1.0.0-rc.1` | `10001` | `10001` |
| RC2, only if required | `1.0.0-rc.2` | `10002` | `10002` |
| Production | `1.0.0` | next unused approved code | next unused approved build |

The project setting, `GameVersion`, export manifests, store package, artifact filename, and release notes must agree. Every package embeds version, commit, deterministic source date, and channel through `build_metadata.generated.cfg`; the file is generated during export and never committed.

Tags are immutable: `v1.0.0-rc.1`, optional later RC tags, then `v1.0.0`. Reserve `1.0.1` and `hotfix/1.0.1` for minimal post-launch fixes. Do not reuse a store build number after upload.

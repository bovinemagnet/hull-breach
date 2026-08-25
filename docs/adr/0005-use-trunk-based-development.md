# ADR-0005: Use Trunk-Based Development

## Status

Accepted

## Context

The project is small and needs fast integration without permanent environment branches.

## Decision

Use `main` as the only permanent branch. Merge short-lived feature, fix, chore, and documentation branches through pull requests using squash merge.

## Consequences

Changes integrate frequently and history remains coherent. Pull requests must be small enough to review and must pass CI before merge.

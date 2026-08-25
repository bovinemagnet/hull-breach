# ADR-0004: Use a Feature-Oriented Project Layout

## Status

Accepted

## Context

Scenes, scripts, resources, and audio for one gameplay capability are easier to change when kept together.

## Decision

Organize gameplay under feature directories such as `features/doors/`, with shared infrastructure restricted to `core/`.

## Consequences

Feature ownership and dependencies remain visible. Some file types will appear in several feature directories instead of one global scripts or scenes directory.

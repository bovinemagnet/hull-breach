# ADR-0003: Use the Compatibility Renderer

## Status

Accepted

## Context

Hull Breach is primarily a 2D game with desktop and mobile targets and should support modest hardware.

## Decision

Use Godot's Compatibility renderer initially.

## Consequences

The project favors broad device support and lower rendering requirements. Advanced renderer-only effects are unavailable unless this decision is revisited for a concrete feature.

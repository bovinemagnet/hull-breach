# ADR-0002: Use GDScript

## Status

Accepted

## Context

The project needs one productive gameplay language that integrates directly with Godot's editor and scene model.

## Decision

Use typed GDScript for gameplay. Do not mix languages without a measured requirement.

## Consequences

Gameplay code remains approachable and tightly integrated with Godot. GDExtension or another language may be introduced later only for a demonstrated limitation or measured performance problem.

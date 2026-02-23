---
name: dotfiles
description: Orchestrate dotfiles maintenance tasks by routing to specialized skills in this repository. Use when requests span multiple dotfiles areas (macOS defaults drift/sync, Swift completion maintenance, docs alignment), or when a single entrypoint should choose and sequence the right dotfiles skills.
---

# dotfiles

Coordinate dotfiles workflows by delegating to specialized skills.

## Routing

- Use `$dotfiles-defaults-sync` for macOS defaults drift analysis, `macos/defaults.sh` alignment checks, and root-level key proposals.
- Use `$dotfiles-swift-completion-update` for Swift Package Manager zsh completion refresh and cache-aware regeneration.

## Orchestration Workflow

1. Classify the incoming request by area:
- defaults drift / defaults.sh sync
- Swift completion update
- mixed request across both areas

2. Delegate to one or both specialized skills.
- For mixed requests, run defaults sync first, then Swift completion update.

3. Consolidate results into a single response.
- Include what changed, what was only proposed, and what still needs user approval.

## Rules

- Keep this skill orchestration-only; do not duplicate implementation logic from child skills.
- Reuse child skill scripts/flows instead of creating parallel behavior.
- Respect child-skill guardrails, especially one-by-one user approval before any `macos/defaults.sh` edits or new key/value additions.

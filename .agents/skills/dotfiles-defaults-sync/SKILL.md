---
name: dotfiles-defaults-sync
description: Audit and sync macOS defaults domain drift against a cached baseline and `macos/defaults.sh`. Use when defaults keys change on a machine, when validating `macos/defaults.sh` alignment, and when proposing meaningful root-level keys to add without auto-editing.
---

# macOS Defaults Sync

Run the defaults drift and alignment workflow for this repository.

## Workflow

1. Run per-domain drift checks when needed:
- `.agents/skills/dotfiles-defaults-sync/scripts/defaults-domain-diff.sh <domain>`

2. Run full audit and proposal flow:
- `.agents/skills/dotfiles-defaults-sync/scripts/defaults-audit-sync.sh`

3. Review report sections in order:
- `Top Priority: Changed Root Keys`
- `defaults.sh Keys With Mismatched Values`
- `Suggested Root Keys Missing From defaults.sh`

4. Propose edits to `macos/defaults.sh` to the user.
- Do not auto-edit without confirmation.
- Ask approval for each proposed change one by one.
- Ask approval for each proposed new key/value one by one.

5. Re-run audit after approved edits.

## Rules

- Treat machine current values as proposal truth.
- Use cache drift to prioritize changes.
- Prioritize changed or added root keys first.
- Propose missing keys only for root-level scalar values.
- Do not attempt to include all nested keys from plist domains.
- Never edit `macos/defaults.sh` until the user approves each individual change.
- Never add proposed key/value entries until the user approves each individual proposal.

## Cache

- Cache directory: `.cache/dotfiles-defaults-sync/` at repository root.
- Use `--no-update-cache` to run report-only checks.

## Learn

- The skill may update its own files to fix bugs or improve flow descriptions.
- Keep self-updates scoped to the skill package (`SKILL.md`, `agents/openai.yaml`, `scripts/*`).
- Do not auto-change workflow behavior that edits `macos/defaults.sh`; keep one-by-one user approval requirements intact.

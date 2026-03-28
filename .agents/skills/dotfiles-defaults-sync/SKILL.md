---
name: dotfiles-defaults-sync
description: Audit and sync macOS defaults domain drift against a cached baseline and `macos/defaults.sh`, using dry-run mode by default so differences are listed before any cache updates or proposed edits.
---

# Dotfiles Defaults Sync

Run the defaults drift and alignment workflow for this repository.

## Workflow

1. Run per-domain drift checks in dry-run mode by default:
- `.agents/skills/dotfiles-defaults-sync/scripts/defaults-domain-diff.sh <domain>`

2. Run full audit and proposal flow in dry-run mode by default:
- `.agents/skills/dotfiles-defaults-sync/scripts/defaults-audit-sync.sh`

3. List the report differences to the user before writing anything.

4. Review report sections in order:
- `Top Priority: Changed/Added Root Keys`
- `Nested Changes (Informational)`
- `defaults.sh Keys With Mismatched Values`
- `Suggested Root Keys Missing From defaults.sh`

5. Propose edits to `macos/defaults.sh` to the user.
- Do not auto-edit without confirmation.
- Ask approval for each proposed change one by one.
- Ask approval for each proposed new key/value one by one.
- Place each approved key under the correct section in `macos/defaults.sh`.
- If a matching section does not exist, create a new clearly named section before adding the key.

6. Re-run the audit in dry-run mode after approved edits.

7. Refresh cache only when explicitly requested or when you intentionally want to accept the current machine state as the new baseline:
- `.agents/skills/dotfiles-defaults-sync/scripts/defaults-audit-sync.sh --update-cache`
- `.agents/skills/dotfiles-defaults-sync/scripts/defaults-domain-diff.sh --update-cache <domain>`

## Rules

- Treat machine current values as proposal truth.
- Dry-run mode is the default execution mode.
- In dry-run mode, list differences before updating cache or proposing file edits.
- Use cache drift to prioritize changes.
- Prioritize changed or added root keys first.
- Propose missing keys only for root-level scalar values.
- Do not attempt to include all nested keys from plist domains.
- Do not update cache unless `--update-cache` is explicitly requested.
- Never edit `macos/defaults.sh` until the user approves each individual change.
- Never add proposed key/value entries until the user approves each individual proposal.
- Keep `macos/defaults.sh` organized by section and insert new keys in the appropriate section.
- If no suitable section exists for a new approved key, create one with a clear header and add the key there.

## Cache

- Cache directory: `.cache/dotfiles-defaults-sync/` at repository root.
- Dry-run/report-only is the default mode.
- Use `--update-cache` to create or refresh baseline cache after review.

## References

- Use `references/macos-defaults-sources.md` for external description sources when adding/updating documented key meanings.

## Learn

- The skill may update its own files to fix bugs or improve flow descriptions.
- Keep self-updates scoped to the skill package (`SKILL.md`, `agents/openai.yaml`, `scripts/*`).
- Do not auto-change workflow behavior that edits `macos/defaults.sh`; keep one-by-one user approval requirements intact.

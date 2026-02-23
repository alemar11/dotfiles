---
name: dotfiles-swift-update
description: Update Swift Package Manager zsh completion for dotfiles using a version-aware cache. Use when refreshing `_swift` completion, after Swift updates, or when checking if regeneration is needed.
---

# dotfiles-swift-update

Maintain Swift Package Manager completion in this repository workflow.

## Workflow

1. Run the updater script:
- `.agents/skills/dotfiles-swift-update/scripts/update-spm-completion.sh`

2. If a fresh generation is explicitly needed, force it:
- `.agents/skills/dotfiles-swift-update/scripts/update-spm-completion.sh --force`

3. If the script reports up-to-date, do not regenerate.

## Rules

- Use cache directory `.cache/dotfiles-swift-update/` at repo root.
- Compare current `swift --version` to cached version to decide regeneration.
- Regenerate when `_swift` completion file is missing.
- Regenerate when cached version is missing or changed.

## Cache

- `last-swift-version.txt`: Swift version used for last completion generation.
- `last-generated-at.txt`: UTC timestamp for last generation.

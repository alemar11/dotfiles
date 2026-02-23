#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  REPO_ROOT="$SCRIPT_DIR"
fi

CACHE_DIR="$REPO_ROOT/.cache/dotfiles-swift-update"
CACHE_VERSION_FILE="$CACHE_DIR/last-swift-version.txt"
CACHE_GENERATED_AT_FILE="$CACHE_DIR/last-generated-at.txt"

TARGET_DIR="$HOME/.zsh/completions"
TARGET_FILE="$TARGET_DIR/_swift"

usage() {
  cat <<'USAGE' >&2
Usage: .agents/skills/dotfiles-swift-update/scripts/update-spm-completion.sh [--force]

Options:
  --force    Regenerate completion script even if cached Swift version matches
  -h, --help Show this help message
USAGE
}

force=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      force=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if ! command -v swift >/dev/null 2>&1; then
  echo "error: swift command not found" >&2
  exit 1
fi

swift_version="$(swift --version | head -n 1 | tr -d '\r')"

reason=""
if [[ "$force" == "true" ]]; then
  reason="forced"
elif [[ ! -f "$TARGET_FILE" ]]; then
  reason="missing completion file"
elif [[ ! -f "$CACHE_VERSION_FILE" ]]; then
  reason="missing version cache"
else
  cached_version="$(cat "$CACHE_VERSION_FILE")"
  if [[ "$cached_version" != "$swift_version" ]]; then
    reason="swift version changed"
  fi
fi

if [[ -z "$reason" ]]; then
  echo "Swift completion is up to date for: $swift_version"
  echo "File: $TARGET_FILE"
  exit 0
fi

mkdir -p "$TARGET_DIR" "$CACHE_DIR"

tmp_output="$(mktemp "${TMPDIR:-/tmp}/swift-completion.XXXXXX")"
trap 'rm -f "$tmp_output"' EXIT

swift package completion-tool generate-zsh-script > "$tmp_output"
mv "$tmp_output" "$TARGET_FILE"

printf '%s\n' "$swift_version" > "$CACHE_VERSION_FILE"
date -u '+%Y-%m-%dT%H:%M:%SZ' > "$CACHE_GENERATED_AT_FILE"

echo "Updated Swift completion at: $TARGET_FILE"
echo "Reason: $reason"
echo "Swift: $swift_version"

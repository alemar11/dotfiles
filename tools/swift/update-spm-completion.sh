#!/usr/bin/env bash

set -euo pipefail

if ! command -v swift >/dev/null 2>&1; then
  echo "error: swift command not found" >&2
  exit 1
fi

target_dir="$HOME/.zsh/completions"
target_file="$target_dir/_swift"

mkdir -p "$target_dir"
swift package completion-tool generate-zsh-script > "$target_file"

echo "Updated Swift completion at: $target_file"

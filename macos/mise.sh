#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MISE_CONFIG="${SCRIPT_DIR}/../mise/config.toml"
MISE_BIN="$(command -v mise || true)"

# Homebrew may not be on PATH when this script is run directly.
if [[ -z "$MISE_BIN" && -x /opt/homebrew/bin/mise ]]; then
  MISE_BIN=/opt/homebrew/bin/mise
fi

if [[ -z "$MISE_BIN" ]]; then
  echo "❌ mise is not installed. Run macos/brew.sh first."
  exit 1
fi

if [[ ! -f "$MISE_CONFIG" ]]; then
  echo "❌ mise config not found: $MISE_CONFIG"
  exit 1
fi

echo "🧩 Installing mise-managed tools..."
MISE_GLOBAL_CONFIG_FILE="$MISE_CONFIG" "$MISE_BIN" install "$@"
echo "✅ mise operation completed."

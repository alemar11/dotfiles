#!/bin/bash

# Exit on error, undefined variables, and pipe failures.
set -euo pipefail

# Cursor's standalone installer places its executable in ~/.local/bin. Run it
# before adding this to PATH so it can configure the user's shell profile.
LOCAL_BIN="$HOME/.local/bin"

if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl is required to install the Cursor CLI."
  exit 1
fi

echo "🤖 Installing Cursor CLI..."
curl https://cursor.com/install -fsS | bash

# Make the new binary available for verification in this process.
export PATH="$LOCAL_BIN:$PATH"

echo "🔎 Verifying Cursor CLI..."

CURSOR_BIN=""
if command -v agent >/dev/null 2>&1; then
  CURSOR_BIN="agent"
elif command -v cursor-agent >/dev/null 2>&1; then
  CURSOR_BIN="cursor-agent"
fi

if [[ -z "$CURSOR_BIN" ]]; then
  echo "❌ Cursor CLI was not found in $LOCAL_BIN"
  exit 1
fi
"$CURSOR_BIN" --version

echo "✅ Cursor CLI setup complete."

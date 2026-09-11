#!/bin/bash

# Exit on error, undefined variables, and pipe failures.
set -euo pipefail

# Both standalone installers place their executables in ~/.local/bin. The
# installers must run before this is added to PATH so they can configure the
# user's shell profile when needed.
LOCAL_BIN="$HOME/.local/bin"

if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl is required to install the AI CLIs."
  exit 1
fi

echo "🤖 Installing Codex CLI..."
curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=true sh

echo "🤖 Installing Cursor CLI..."
curl https://cursor.com/install -fsS | bash

# Make the new binaries available for verification in this process.
export PATH="$LOCAL_BIN:$PATH"

echo "🔎 Verifying AI CLIs..."
if ! command -v codex >/dev/null 2>&1; then
  echo "❌ Codex CLI was not found at $LOCAL_BIN/codex"
  exit 1
fi
codex --version

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

echo "✅ AI CLI setup complete."

#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

echo "🚀 Starting setup"

# Resolve Homebrew binary, even if PATH is not initialized for this shell.
BREW_BIN="$(command -v brew || true)"
if [[ -z "$BREW_BIN" && -x /opt/homebrew/bin/brew ]]; then
  BREW_BIN=/opt/homebrew/bin/brew
fi

# Install Homebrew if not already installed.
if [[ -z "$BREW_BIN" ]]; then
  echo "🍺 Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW_BIN=/opt/homebrew/bin/brew
fi

# Ensure brew and brewed tools are available in this process.
eval "$("$BREW_BIN" shellenv)"
BREW_PREFIX="$("$BREW_BIN" --prefix)"

echo "🍺 Updating homebrew..."
brew update

PACKAGES=(
  bat
  cloc
  cmake
  cocoapods
  eza
  fastfetch
  fd
  ffmpeg
  fzf
  gh
  git-lfs
  hyperfine
  jq
  lazydocker
  lazygit
  mkcert
  mole
  node
  postgresql@18
  python
  shellcheck
  starship
  swiftlint
  swift-format
  tree
  uv
  watchman
  yazi
  zoxide
  wget
)
echo "🍺 Installing brew packages..."
brew install "${PACKAGES[@]}"

CASKS=(
  appcleaner
  bruno
  chatgpt
  codex
  codex-app
  docker
  font-fira-code-nerd-font
  ghostty@tip
  iina
  netnewswire
  pearcleaner
  proxyman
  rapidapi
  sketch
  tableplus
  tuist
  tower
  xcodes
)

echo "🍺 Installing cask apps..."
FAILED_CASKS=()

# Install casks individually so one broken download does not block the rest.
# `--adopt` lets Homebrew take ownership of apps already present in
# /Applications instead of failing with "there is already an App" conflicts.
for cask in "${CASKS[@]}"; do
  if ! brew install --cask --adopt "$cask"; then
    echo "⚠️ Failed to install cask: $cask"
    FAILED_CASKS+=("$cask")
  fi
done

# Homebrew can occasionally retain a cask receipt for Codex without restoring
# the expected CLI symlink under the brew prefix. Repair that case explicitly so
# `codex` is available from shells that only include Homebrew on PATH.
CODEX_BIN="$BREW_PREFIX/bin/codex"
if brew list --cask codex >/dev/null 2>&1 && [[ ! -x "$CODEX_BIN" ]]; then
  echo "⚠️ codex cask is installed but $CODEX_BIN is missing; reinstalling codex..."
  if ! brew reinstall --cask codex; then
    echo "⚠️ Failed to repair cask: codex"
    FAILED_CASKS+=("codex")
  fi
fi

echo "🧼 Cleaning up..."
brew cleanup -s

if (( ${#FAILED_CASKS[@]} > 0 )); then
  echo "❌ Some casks failed to install:"
  printf ' - %s\n' "${FAILED_CASKS[@]}"
  exit 1
fi

echo "🎉 Setup complete!"

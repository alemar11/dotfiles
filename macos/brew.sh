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

echo "🍺 Updating homebrew..."
brew update

PACKAGES=(
  cloc
  cmake
  cocoapods
  codex
  fastlane
  hyperfine
  lazydocker
  lazygit
  python
  shellcheck
  swiftlint
  swift-format
  tree
  yazi
  wget
)
echo "🍺 Installing brew packages..."
brew install "${PACKAGES[@]}"

CASKS=(
  appcleaner
  iina
  monodraw
  proxyman
  rapidapi
  sketch
  tower
  xcodes
)

echo "🍺 Installing cask apps..."
brew install --cask "${CASKS[@]}"

echo "🧼 Cleaning up..."
brew cleanup -s

echo "🎉 Setup complete!"

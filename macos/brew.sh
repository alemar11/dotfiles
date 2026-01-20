#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

echo "🚀 Starting setup"

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH=/opt/homebrew/bin:$PATH
fi

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
  rbenv
  shellcheck
  swiftlint
  swift-format
  tree
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

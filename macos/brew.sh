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
  bat
  cloc
  cmake
  cocoapods
  codex
  eza
  ffmpeg
  fzf
  gh
  git-lfs
  hyperfine
  lazydocker
  lazygit
  mkcert
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
brew install --cask "${CASKS[@]}"

echo "🧼 Cleaning up..."
brew cleanup -s

echo "🎉 Setup complete!"

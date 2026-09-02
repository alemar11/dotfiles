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

echo "🔗 Adding alemar11/tap..."
brew tap alemar11/tap

echo "🔐 Trusting alemar11/tap..."
brew trust alemar11/tap

PACKAGES=(
  bat
  btop
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
  modem-dev/tap/hunk
  hyperfine
  jq
  lazydocker
  lazygit
  mise
  mkcert
  mole
  pandoc
  pi-coding-agent
  postgresql@18
  shellcheck
  starship
  swift-format
  tree
  watchman
  yazi
  yt-dlp
  zoxide
  wget
)
echo "🍺 Installing brew packages..."
brew install "${PACKAGES[@]}"

CASKS=(
  appcleaner
  bruno
  chatgpt
  codexbar
  datagrip
  docker
  font-fira-code-nerd-font
  google-chrome
  ghostty@tip
  hopper-disassembler
  iina
  netnewswire
  pearcleaner
  proxyman
  sketch
  tableplus
  tuist
  tower
  xcodes
)

echo "🍺 Installing cask apps..."
FAILED_CASKS=()

# Install casks individually so one broken download does not block the rest.
for cask in "${CASKS[@]}"; do
  # `--adopt` lets Homebrew take ownership of apps already present in
  # /Applications instead of failing with "there is already an App" conflicts.
  if ! brew install --cask --adopt "$cask"; then
    echo "⚠️ Failed to install cask: $cask"
    FAILED_CASKS+=("$cask")
  fi
done

echo "🧼 Cleaning up..."
brew cleanup -s

if (( ${#FAILED_CASKS[@]} > 0 )); then
  echo "❌ Some casks failed to install:"
  printf ' - %s\n' "${FAILED_CASKS[@]}"
  exit 1
fi

echo "🎉 Setup complete!"

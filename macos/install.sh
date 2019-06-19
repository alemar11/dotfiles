#!/usr/bin/env bash

echo "🚀 Starting setup"

# Install Homebrew if not already installed
if test ! $(which brew); then
    echo "🍺 Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "🍺 Updating homebrew..."
brew update

PACKAGES=(
    carthage
    swiftlint
    cloc
    wget
    geoip
    youtube-dl
    rbenv
)

echo "🍺 Installing brew packages..."
brew install ${PACKAGES[@]}
echo "🍺 Upgrading installed brew packages..."
brew upgrade
echo "🧼 Cleaning up..."
brew cleanup -s

# If this user's login shell is not already "zsh", attempt to switch.
TEST_CURRENT_SHELL=$(basename "$SHELL")
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    # If this platform provides a "chsh" command (not Cygwin), do it, man!
    if hash chsh >/dev/null 2>&1; then
      echo "🐚 Time to change your default shell to zsh!"
      chsh -s $(grep /zsh$ /etc/shells | tail -1)
      # launches zsh
      env zsh -l
    else
      echo "🐚 I can't change your shell automatically because this system does not have chsh."
      echo "Please manually change your default shell to zsh!"
    fi
  fi

 echo "🎉 Setup complete!" 

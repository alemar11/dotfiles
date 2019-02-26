#!/usr/bin/env bash


# https://max-itup.github.io/mac/

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
)
echo "🍺 Installing brew packages..."
brew install ${PACKAGES[@]}

CASKS=(
    google-chrome
    whatsapp
    iina
    vlc
    visual-studio-code
    virtualbox
    docker
    monodraw
    coderunner
    beyond-compare
    battle-net
    onyx
    wwdc
)
echo "🍺 Installing cask apps..."
brew cask install ${CASKS[@]}

GEMS=(
    bundler
    cocoapods
    fastlane
    jazzy
    xcpretty
)
echo "💎 Installing Ruby gems..."
sudo gem install ${GEMS[@]} -N

echo "🧼 Cleaning up..."
brew cleanup -s

echo "🎉 Setup complete!"
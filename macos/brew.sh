echo "🚀 Starting setup"

# Install Homebrew if not already installed
if test ! $(which brew); then
    echo "🍺 Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "🍺 Updating homebrew..."
brew update

PACKAGES=(
    cloc
    hyperfine
    python
    rbenv
    swiftlint
    swift-format
    tree
    wget
)
echo "🍺 Installing brew packages..."
brew install ${PACKAGES[@]}

CASKS=(
    appcleaner
    battle-net
    iina
    monodraw
    onyx
    paw
    proxyman
    sketch
    sf-symbols
    tower
    visual-studio-code
    wwdc
    xcodes
)

echo "🍺 Installing cask apps..."
brew cask install ${CASKS[@]}

echo "🧼 Cleaning up..."
brew cleanup -s

GEMS=(
    bundler
    cocoapods
    fastlane
    jazzy
    xcpretty
)
echo "💎 Installing Ruby gems..."
sudo gem install ${GEMS[@]} -n /usr/local/bin

echo "🎉 Setup complete!"
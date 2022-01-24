echo "🚀 Starting setup"

# Install Homebrew if not already installed
if test ! $(which brew); then
    echo "🍺 Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH=/opt/homebrew/bin:$PATH
fi

echo "🍺 Updating homebrew..."
brew update

PACKAGES=(
    cloc
    cocoapods
    fastlane
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
    iina
    monodraw
    onyx
    paw
    proxyman
    sketch
    sf-symbols
    tower
    visual-studio-code
    xcodes
    wwdc
)

echo "🍺 Installing cask apps..."
brew install --cask ${CASKS[@]}

echo "🧼 Cleaning up..."
brew cleanup -s

GEMS=(
    jazzy
)
echo "💎 Installing Ruby gems..."
sudo gem install ${GEMS[@]} -n /usr/local/bin

echo "🎉 Setup complete!"

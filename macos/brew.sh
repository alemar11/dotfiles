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
    rbenv
)
echo "🍺 Installing brew packages..."
brew install ${PACKAGES[@]}

CASKS=(
    appcleaner
    battle-net
    beyond-compare
    fork
    iina
    monodraw
    onyx
    paw
    proxyman
    sketch
    visual-studio-code
    wwdc
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
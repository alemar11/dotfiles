brew update
brew upgrade

FORMULAS=(
    carthage
    rbenv
    wget
    
)
brew install ${FORMULAS[@]}

brew cleanup

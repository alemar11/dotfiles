brew update
brew upgrade

FORMULAS=(
    carthage
    rbenv
    wget
	n   
)
brew install ${FORMULAS[@]}

brew cleanup

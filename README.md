# dotfiles for macOS

Run 🚀

```
bundle install
bundle exec rake symlink
```

## Show hidden files

```
defaults write com.apple.finder AppleShowAllFiles YES
killall -KILL Finder
```

## ZSH

```
brew install zsh
chsh -s /bin/zsh
```

## Swift Package Manager Completion (Swift 4.2)

If you want to update the current auto completion run:
`swift package completion-tool generate-zsh-script > ~/.zsh/functions/_swift`

## Extra configuration

To install the custom terminal theme just double click on AM.terminal.


## Setup SSH

`touch ~/.ssh/config`

```
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
```

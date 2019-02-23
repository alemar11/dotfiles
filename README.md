# dotfiles for macOS

Run 🚀

```
./script.swift
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

If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.

`touch ~/.ssh/config`

```
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
```

# dotfiles for macOS

Run 🚀

```
./bootstrap.sh
```

## Update Swift Package Manager Completion

If you want to update the current auto completion run:
`swift package completion-tool generate-zsh-script > ~/.zsh/functions/_swift`

## Setup SSH

If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.

`touch ~/.ssh/config`

```
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
```

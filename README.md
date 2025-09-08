# Install dotfiles

```
./dotfiles.sh
```

---

# macOS

In the *macos* folder there are scripts to customize `macOS` defaults, `Terminal`, and `Xcode`.

Double click “AM.terminal” file.  
This is the specific Theme file for Terminal.app.   
Note: If you get a warning that this is from an unidentified developer, Right-click on the file and select “Open with” > Terminal option.

```
./macos/install.sh
```

# Xcode configuration

```
./macos/xcode/copy.sh
```

---

## Update Swift Package Manager Completion

If you want to update the current auto completion run:
`swift package completion-tool generate-zsh-script > ~/.zsh/completions/_swift`

## Setup SSH

You need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.

`touch ~/.ssh/config`

```
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
```

Add your SSH private key to the ssh-agent and store your passphrase in the keychain.

```
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

```

More info can be found here:

- [Connecting to Github with ssh](https://help.github.com/en/articles/connecting-to-github-with-ssh)
- [Generating a new ssh key and adding it to the ssh agent](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [Managing multiple github SSH keys on mac](https://samwize.com/2022/04/06/managing-multiple-github-ssh-keys-on-mac/)
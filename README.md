# dotfiles

```
./dotfiles.sh
```

---

# macOS
in */macos* there are some scripts to customize some `macOS` defaults, `Terminal`, `Xcode`, `VScode`.

Double click “AM.terminal” file.  
This is the specific Theme file for Terminal.app.   
Note: If you get a warning that this is from an unidentified developer, Right-click on the file and select “Open with” > Terminal option.

```
./macos/install.sh
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
  IdentityFile ~/.ssh/id_rsa
```

More info can be found here:

- [Connecting to Github with ssh](https://help.github.com/en/articles/connecting-to-github-with-ssh)
- [Generating a new ssh key and adding it to the ssh agent](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
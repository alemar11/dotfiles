# dotfiles for macOS

Run 🚀

```
rake symlink
```

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
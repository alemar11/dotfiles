# Install dotfiles

```
./dotfiles.sh
```

---

## Platform Support

These dotfiles are intended for Apple Silicon Macs only (M1/M2/M3 and newer). They are not supported on Intel-based Macs.

---

# macOS

In the *macos* folder there are scripts to install Homebrew packages and apply `macOS` defaults.

```
./macos/install.sh
```

# Interactive Steps and Permissions

- The macOS defaults script may request administrator privileges (e.g., to change visibility of `/Volumes`). Be ready to enter your password when prompted.
- If Xcode Command Line Tools are not installed, `brew.sh` may require them. You can install them with `xcode-select --install`.

# Xcode configuration

```
./macos/xcode/copy.sh
```

---

## Repository Location and DOTFILES Resolution

- Recommended clone path: `~/Developer/dotfiles`.
- During installation, `dotfiles.sh` creates a symlink from the repo’s `zshrc` to `~/.zshrc`. The shell configuration then derives the repository path via that symlink and exports it as `DOTFILES`.
  - In other words, `DOTFILES` resolves automatically as “the directory containing the file that `~/.zshrc` links to”, so the repository can live anywhere as long as `~/.zshrc` is linked by `./dotfiles.sh install`.
  - If you choose not to symlink `~/.zshrc`, set `DOTFILES` manually in your environment to the repo root so custom scripts on your `PATH` (e.g., `bin/*`) are available: `export DOTFILES=~/Developer/dotfiles && export PATH="$DOTFILES/bin:$PATH"`.
- Prompt configuration is managed through `starship.toml`, which `dotfiles.sh` links to `~/.config/starship.toml`.
- `zsh/prompt.zsh` only initializes Starship; prompt layout and custom segments live in `starship.toml`.

## Skill-managed maintenance

Defaults drift/audit and Swift completion refresh are handled through repository skills under `.agents/skills/`.
Use the orchestrator skill (`$dotfiles`) to route these tasks instead of running maintenance scripts directly.

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

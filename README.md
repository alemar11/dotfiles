# Install dotfiles

```
./dotfiles.sh
```

---

## Platform Support

These dotfiles are intended for Apple Silicon Macs only (M1/M2/M3 and newer). They are not supported on Intel-based Macs.

---

# macOS

In the *macos* folder there are scripts to install Homebrew packages, standalone AI CLIs, mise-managed development tools, and apply `macOS` defaults.

```
./macos/install.sh
```

To install only the tools configured in `mise/config.toml`:

```
./macos/mise.sh
```

To install the standalone Codex and Cursor CLIs:

```
./macos/ai-cli.sh
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
- Fastfetch configuration is managed through `fastfetch/config.jsonc`, which `dotfiles.sh` links to `~/.config/fastfetch/config.jsonc`.
- Ghostty configuration is managed through `ghostty/config.ghostty`, which `dotfiles.sh` links to `~/.config/ghostty/config.ghostty`.
- Prompt configuration is managed through `starship.toml`, which `dotfiles.sh` links to `~/.config/starship.toml`.
- `zsh/prompt.zsh` only initializes Starship; prompt layout and custom segments live in `starship.toml`.

## Vim

The [Vim setup](vim/README.md) uses classic Vim with two plugins: `vim-lsp` for
TypeScript, Python, and Swift language support, and `vim-which-key` for a shortcut
menu at the bottom. Buffers, splits, search, and the file browser are built into Vim.

Run `./vim/install.sh` once, then open `vim .` and press Space to see the menu.
The configuration lives in [`vimrc`](vimrc), linked with `./dotfiles.sh install vimrc`.
See the [setup guide](vim/README.md) for installation, updates, and core shortcuts.

## Yazi

The Yazi configuration shows Git status indicators beside files and directories
using the official [Git plugin](https://github.com/yazi-rs/plugins/tree/main/git.yazi).
After installing Yazi, link its configuration and restore the locked plugin version:

```sh
./dotfiles.sh install yazi
ya pkg install
```

Restart Yazi after setup. Plugin versions are tracked in `yazi/package.toml`;
downloaded plugins are ignored by Git. Run `ya pkg upgrade` to update them and
review the resulting manifest changes.

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

# AGENTS.md

Guidance for coding agents working in this repository.

## Quick rules
- Apple Silicon only (M1/M2/M3+). Do not assume Intel support.
- Default clone path is `~/Developer/dotfiles`. Keep paths relative or update all references together.
- Do not run host-modifying scripts (`macos/install.sh`, `macos/defaults.sh`, `macos/brew.sh`) unless explicitly requested—they change system settings and install software.
- Do not edit `macos/defaults.sh` without explicit user approval for each individual change and each new key/value proposal.
- Manage symlinks via `./dotfiles.sh` rather than ad hoc commands.
- Keep edits macOS/zsh-friendly and avoid introducing secrets or machine-specific values.

## Core components

### Main installation
- `dotfiles.sh` symlinks dotfiles to the home directory.
  - `./dotfiles.sh install` creates symlinks.
  - `./dotfiles.sh remove` removes symlinks.
  - `./dotfiles.sh clean` removes broken symlinks.

### macOS setup
- `macos/install.sh` runs `brew.sh` and `defaults.sh`.
- `macos/brew.sh` installs Homebrew packages and casks (includes `shellcheck`).
- `macos/defaults.sh` applies macOS preferences.
- Defaults drift/audit tooling lives in `.agents/skills/dotfiles-defaults-sync/scripts/`.
- Defaults cache lives in `.cache/dotfiles-defaults-sync/`.
- Swift completion updater lives in `.agents/skills/dotfiles-swift-completion-update/scripts/update-spm-completion.sh`.
- Swift completion cache lives in `.cache/dotfiles-swift-completion-update/`.

### Xcode configuration
- `macos/xcode/copy.sh` copies keybindings and breakpoints to Xcode `UserData`.
- Contains custom keybindings and breakpoints.

### Shell configuration
- `zshrc` sources all `zsh/*.zsh` files.
- `zsh/` contains modular configuration:
  - `aliases.zsh` - shell aliases
  - `completion.zsh` - completion settings
  - `prompt.zsh` - prompt configuration
  - `xcode.zsh` - Xcode functions
  - `vscode.zsh` - VS Code functions
  - `functions/` - autoloaded zsh functions

### Other configurations
- `gitconfig` - Git configuration
- `gitignore_global` - global gitignore patterns
- `vimrc` - Vim configuration
- `lldbinit`, `lldbinit-Xcode` - LLDB debugger configuration

## Common commands

### Initial setup
```bash
./dotfiles.sh install       # Install all dotfiles (symlinks)
./macos/install.sh          # macOS setup (from repo root; run only when asked)
./macos/xcode/copy.sh       # Copy Xcode configuration
```

### Managing dotfiles
```bash
./dotfiles.sh remove        # Remove all symlinks
./dotfiles.sh clean         # Clean broken symlinks
```

## Architecture notes
- Uses symlinks to map repo files to expected home directory locations.
- `dotfiles.sh` manages symlinks via the `DOTFILES` array.
- zsh configuration is modular; `zshrc` sources all `.zsh` files from `~/.zsh/`.
- Custom zsh functions are autoloaded from `~/.zsh/functions/`.
- `zshrc` derives `DOTFILES` from the `~/.zshrc` symlink target, with fallback to `~/Developer/dotfiles`.

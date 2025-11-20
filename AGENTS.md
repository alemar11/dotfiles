# AGENTS.md

Guidance for coding agents working in this repository.

## Quick rules
- Apple Silicon only (M1/M2/M3+). Do not assume Intel support.
- Scripts expect the repo to live at `~/Developer/dotfiles`. Keep paths relative or update all references together.
- Do not run host-modifying scripts (`macos/install.sh`, `macos/defaults.sh`, `macos/brew.sh`) unless explicitly requested—they change system settings and install software.
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
- `macos/AM.terminal` is the Terminal.app theme.

### Xcode configuration
- `macos/xcode/copy.sh` copies themes, keybindings, and breakpoints to Xcode `UserData`.
- Contains custom color themes and keybindings.

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
- `dotfiles.sh` manages symlinks via the `FILES` array.
- zsh configuration is modular; `zshrc` sources all `.zsh` files from `~/.zsh/`.
- Custom zsh functions are autoloaded from `~/.zsh/functions/`.
- Scripts assume the repository is cloned to `~/Developer/dotfiles`.

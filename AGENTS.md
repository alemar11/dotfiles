# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS configuration and development environment setup. It provides scripts and configuration files for terminal, shell (zsh), git, vim, Xcode, and various development tools.

## Core Components

### Main Installation Script
- `dotfiles.sh` - Symlinks dotfiles to home directory
  - Usage: `./dotfiles.sh install` to create symlinks
  - `./dotfiles.sh remove` to remove symlinks
  - `./dotfiles.sh clean` to remove broken symlinks

### macOS Setup
- `macos/install.sh` - Main macOS setup script that runs brew.sh and defaults.sh
- `macos/brew.sh` - Homebrew package installations
- `macos/defaults.sh` - macOS system preferences and defaults
- `macos/AM.terminal` - Terminal.app theme file

### Xcode Configuration
- `macos/xcode/copy.sh` - Copies Xcode themes, keybindings, and breakpoints to Xcode UserData
- Contains custom color themes and keybindings

### Shell Configuration
- `zshrc` - Main zsh configuration that sources all zsh/*.zsh files
- `zsh/` directory contains modular zsh configuration:
  - `aliases.zsh` - Shell aliases
  - `completion.zsh` - Completion settings
  - `prompt.zsh` - Prompt configuration
  - `xcode.zsh` - Xcode-related functions
  - `vscode.zsh` - VSCode-related functions
  - `functions/` - Custom zsh functions

### Other Configurations
- `gitconfig` - Git configuration
- `gitignore_global` - Global gitignore patterns
- `vimrc` - Vim configuration
- `lldbinit` and `lldbinit-Xcode` - LLDB debugger configuration

## Common Commands

### Initial Setup
```bash
# Install all dotfiles
./dotfiles.sh install

# macOS-specific setup (run from repository root)
./macos/install.sh

# Copy Xcode configuration
./macos/xcode/copy.sh
```

### Managing Dotfiles
```bash
# Remove all symlinks
./dotfiles.sh remove

# Clean broken symlinks
./dotfiles.sh clean
```

## Architecture Notes

- The repository uses symlinks to connect configuration files from the repo to their expected locations in the home directory
- The `dotfiles.sh` script manages these symlinks programmatically based on the FILES array
- zsh configuration is modular - the main `zshrc` sources all .zsh files from the `~/.zsh/` directory
- Custom zsh functions are autoloaded from `~/.zsh/functions/`
- The repository expects to be cloned to `~/Developer/dotfiles` based on the paths used in scripts
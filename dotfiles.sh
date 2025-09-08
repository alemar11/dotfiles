#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Configuration format: "source:target:type"
# Types:
#   - file: Link a single file to ~/.target
#   - folder: Link entire folder to ~/.target
#   - folder_contents: Link files inside folder to ~/.target/
DOTFILES=(
  "curlrc:.curlrc:file"
  "git_template:.git_template:folder"
  "gitconfig:.gitconfig:file"
  "gitignore_global:.gitignore_global:file"
  "hushlogin:.hushlogin:file"
  "lldb_helpers:.lldb_helpers:folder"
  "lldbinit:.lldbinit:file"
  "lldbinit-Xcode:.lldbinit-Xcode:file"
  "vimrc:.vimrc:file"
  "zsh:.zsh:folder"
  "zshenv:.zshenv:file"
  "zshrc:.zshrc:file"
  "claude:.claude:folder_contents"
)

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse dotfile entry into components
parse_entry() {
  local entry="$1"
  IFS=':' read -r source target type <<< "$entry"
  echo "$source" "$target" "$type"
}

# Link a single file
link_file() {
  local source="$1"
  local target="$2"
  
  if [[ ! -e "$source" ]]; then
    echo "Error: $source doesn't exist"
    return 1
  fi
  
  if [[ ! -e "$target" ]]; then
    echo "Linking $source to $target"
    ln -s "$source" "$target"
  else
    echo "Skip: $target already exists"
  fi
}

# Link an entire folder
link_folder() {
  local source="$1"
  local target="$2"
  
  if [[ ! -d "$source" ]]; then
    echo "Error: $source doesn't exist or is not a directory"
    return 1
  fi
  
  if [[ ! -e "$target" ]]; then
    echo "Linking folder $source to $target"
    ln -s "$source" "$target"
  else
    echo "Skip: $target already exists"
  fi
}

# Link contents of a folder
link_folder_contents() {
  local source_dir="$1"
  local target_dir="$2"
  
  if [[ ! -d "$source_dir" ]]; then
    echo "Error: $source_dir doesn't exist or is not a directory"
    return 1
  fi
  
  # Create target directory if it doesn't exist
  if [[ ! -d "$target_dir" ]]; then
    echo "Creating $target_dir"
    mkdir -p "$target_dir"
  fi
  
  # Link each file in the source directory
  for file in "$source_dir"/*; do
    if [[ -f "$file" ]]; then
      local filename=$(basename "$file")
      local target_file="$target_dir/$filename"
      
      if [[ ! -e "$target_file" ]]; then
        echo "Linking $file to $target_file"
        ln -s "$file" "$target_file"
      else
        echo "Skip: $target_file already exists"
      fi
    fi
  done
}

# Process a single dotfile entry for installation
install_entry() {
  local entry="$1"
  read -r source target type <<< "$(parse_entry "$entry")"
  
  local source_path="$SCRIPT_DIR/$source"
  local target_path="$HOME/$target"
  
  case "$type" in
    file)
      link_file "$source_path" "$target_path"
      ;;
    folder)
      link_folder "$source_path" "$target_path"
      ;;
    folder_contents)
      link_folder_contents "$source_path" "$target_path"
      ;;
    *)
      echo "Error: Unknown type '$type' for $source"
      return 1
      ;;
  esac
}

# Remove a single file or symlink
remove_file() {
  local target="$1"
  
  if [[ -L "$target" ]]; then
    echo "Removing symlink $target"
    rm "$target"
  elif [[ -e "$target" ]]; then
    echo "Warning: $target exists but is not a symlink, skipping"
  fi
}

# Remove folder contents (only symlinks)
remove_folder_contents() {
  local target_dir="$1"
  
  if [[ ! -d "$target_dir" ]]; then
    return
  fi
  
  # Remove symlinks in the target directory
  for file in "$target_dir"/*; do
    if [[ -L "$file" ]]; then
      echo "Removing symlink $file"
      rm "$file"
    fi
  done
  
  # Remove directory if empty
  if [[ -z "$(ls -A "$target_dir")" ]]; then
    echo "Removing empty directory $target_dir"
    rmdir "$target_dir"
  fi
}

# Process a single dotfile entry for removal
remove_entry() {
  local entry="$1"
  read -r source target type <<< "$(parse_entry "$entry")"
  
  local target_path="$HOME/$target"
  
  case "$type" in
    file|folder)
      remove_file "$target_path"
      ;;
    folder_contents)
      remove_folder_contents "$target_path"
      ;;
    *)
      echo "Error: Unknown type '$type' for $source"
      return 1
      ;;
  esac
}

# Install all dotfiles
install_all() {
  echo "Installing dotfiles..."
  for entry in "${DOTFILES[@]}"; do
    install_entry "$entry"
  done
  echo "Installation complete!"
}

# Remove all dotfiles
remove_all() {
  echo "Removing dotfiles..."
  for entry in "${DOTFILES[@]}"; do
    remove_entry "$entry"
  done
  echo "Removal complete!"
}

# Clean broken symlinks in home directory
clean_broken_links() {
  echo "Cleaning broken symlinks in $HOME..."
  find "$HOME" -L -maxdepth 1 -type l -exec rm -i {} \;
  echo "Cleaning complete!"
}

# Print usage and exit
usage() {
  echo "Usage: $0 {install|remove|clean}"
  echo ""
  echo "Commands:"
  echo "  install - Create symlinks for all dotfiles"
  echo "  remove  - Remove all dotfile symlinks"
  echo "  clean   - Remove broken symlinks from home directory"
  exit 1
}

# Main script logic
main() {
  if [[ $# -ne 1 ]]; then
    usage
  fi
  
  case "$1" in
    install)
      install_all
      ;;
    remove)
      remove_all
      ;;
    clean)
      clean_broken_links
      ;;
    *)
      usage
      ;;
  esac
}

# Run main function
main "$@"
#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

FILES=(
  curlrc
  git_template
  gitconfig
  gitignore_global
  hushlogin
  lldb_helpers
  lldbinit
  lldbinit-Xcode
  vimrc
  zsh
  zshenv
  zshrc
)

new_path() {
  echo "$HOME/.$1"
}

# Links the passed filename to its new location
link() {
  local filename="$1"

  if [[ ! -e "$filename" ]]; then
    echo "$filename doesn't exist"
    return
  fi

  target="$(new_path "$filename")"
  if [[ ! -e "$target" ]]; then
    echo "Linking $filename to $target"
    ln -s "$(cd "$(dirname "$0")" && pwd)/$filename" "$target"
  fi
}

# Delete the linked file
unlink() {
  target="$(new_path "$1")"

  if [[ -e "$target" ]]; then
    echo "Removing $target"
    rm "$target"
  fi
}

# Loops through and link all files without links
install_links() {
  for file in "${FILES[@]}"; do
    link "$file"
  done
}

# Function to remove all linked files
remove_links() {
  for file in "${FILES[@]}"; do
    unlink "$file"
  done
}

# Function to print the usage and exit when there's bad input
die() {
  echo "Usage ./dotfiles.sh {install|remove|clean}"
  exit 1
}

# Make sure there is 1 command line argument
if [[ $# -ne 1 ]]; then
  die
fi

# Check whether the user is installing or removing
if [[ $1 == "install" ]]; then
  install_links
elif [[ $1 == "remove" ]]; then
  remove_links
elif [[ $1 == "clean" ]]; then
  # remove broken symbolic link.
  find "$HOME" -L -maxdepth 1 -type l -exec rm -i {} \;
else
  die
fi

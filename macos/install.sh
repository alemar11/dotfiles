#!/bin/bash

set -e
set -o pipefail
set -u

if [ ! -d macos ]; then
  echo "Must be run from root of dotfiles"
  exit 1
fi

open "./macos/AM.terminal"

echo "Installing software"
sh "./macos/brew.sh"
echo "Done."

echo "Configuring macOS defaults."
sh "./macos/defaults.sh"
echo "Done. Note that some of these changes require a logout/restart to take effect."

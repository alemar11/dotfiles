#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

if [ ! -d macos ]; then
  echo "Must be run from root of dotfiles"
  exit 1
fi

echo "Installing software"
bash "./macos/brew.sh"
bash "./macos/mise.sh"
echo "Done."

echo "Configuring macOS defaults."
bash "./macos/defaults.sh"
echo "Done. Note that some of these changes require a logout/restart to take effect."

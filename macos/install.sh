#!/bin/bash

set -e
set -o pipefail
set -u

if [ ! -d macos ]; then
  echo "Must be run from root of dotfiles"
  exit 1
fi

### Zsh

# If this user's login shell is not already "zsh", attempt to switch.
TEST_CURRENT_SHELL=$(basename "$SHELL")
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
  # If this platform provides a "chsh" command (not Cygwin), do it, man!
  if hash chsh >/dev/null 2>&1; then
    echo "🐚 Time to change your default shell to zsh!"
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
    # launches zsh
    env zsh -l
  else
    echo "🐚 I can't change your shell automatically because this system does not have chsh."
    echo "Please manually change your default shell to zsh!"
  fi
fi

open "$DOTFILES/macos/AM.terminal"

echo "Configuring macOS defaults."
sh "$DOTFILES/macos/defaults.sh"
echo "Done. Note that some of these changes require a logout/restart to take effect."
#!/bin/bash
#
# If you change these files in the Xcode UI, it will remove the symlinks and
# duplicate them. In that case you should copy them back to this repo, and
# re-run this script.
#
# http://www.openradar.me/42206958
#

set -e
set -o pipefail
set -u

if [ ! -d macos ]; then
  echo "Must be run from root of dotfiles"
  exit 1
fi

open "$DOTFILES/macos/AM.terminal"
"$DOTFILES/macos/install.sh"
"$DOTFILES/macos/defaults.sh"

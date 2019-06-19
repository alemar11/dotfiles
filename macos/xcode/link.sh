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

# if [ ! -d xcode ]; then
#   echo "Must be run from root of dotfiles"
#   exit 1
# fi

user_data_directory="$HOME/Library/Developer/Xcode/UserData"

# bindings="$HOME/Library/Developer/Xcode/UserData/KeyBindings"
# rm -f "$bindings/custom.idekeybindings"
# mkdir -p "$bindings"
# ln -s "$DOTFILES/xcode/custom.idekeybindings" "$bindings"

colors="${user_data_directory}/FontAndColorThemes"
rm -f "$colors/AM.xccolortheme"
rm -f "$colors/Dusk AM.xccolortheme"
mkdir -p "$colors"
ln -f -s "$DOTFILES/xcode/AM.xccolortheme" "$colors"
ln -f -s "$DOTFILES/xcode/Dusk AM.xccolortheme" "$colors"

breakpoints="${user_data_directory}/xcdebugger"
rm -f "$breakpoints/Breakpoints_v2.xcbkptlist"
mkdir -p "$breakpoints"
ln -f -s "$DOTFILES/xcode/Breakpoints_v2.xcbkptlist" "$breakpoints/Breakpoints_v2.xcbkptlist"

snippets="${user_data_directory}/CodeSnippets"
rm -f "$snippets/swift-mark.codesnippet"
rm -f "$snippets/swift-todo.codesnippet"
rm -f "$snippets/swift-weak.codesnippet"
mkdir -p "$snippets"
ln -f -s "$DOTFILES/xcode/swift-mark.codesnippet" "$snippets"
ln -f -s "$DOTFILES/xcode/swift-todo.codesnippet" "$snippets"
ln -f -s "$DOTFILES/xcode/swift-weak.codesnippet" "$snippets"
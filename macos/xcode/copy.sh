#!/bin/bash
#
# If you change these files in the Xcode UI, update the versions in this folder manually

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

echo "Configuring Xcode."
user_data_directory="$HOME/Library/Developer/Xcode/UserData"
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
xcode_backup_directory="$SCRIPT_DIR"

bindings="${user_data_directory}/KeyBindings"
mkdir -p "$bindings"
cp -rf "${xcode_backup_directory}/AM.idekeybindings" "$bindings"

colors="${user_data_directory}/FontAndColorThemes"
mkdir -p "$colors"
cp -rf "${xcode_backup_directory}/AM.xccolortheme" "$colors"
cp -rf "${xcode_backup_directory}/AM Dusk.xccolortheme" "$colors"

breakpoints="${user_data_directory}/xcdebugger"
mkdir -p "$breakpoints"
cp -rf "${xcode_backup_directory}/Breakpoints_v2.xcbkptlist" "$breakpoints/Breakpoints_v2.xcbkptlist"

# snippets="${user_data_directory}/CodeSnippets"
# mkdir -p "$snippets"
# cp -rf "${xcode_backup_directory}/swift-mark.codesnippet" "$snippets"
# cp -rf "${xcode_backup_directory}/swift-todo.codesnippet" "$snippets"
# cp -rf "${xcode_backup_directory}/swift-weak.codesnippet" "$snippets"
echo "Done"
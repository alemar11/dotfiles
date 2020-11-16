 #!/bin/bash

set -e
set -o pipefail
set -u

echo "Configuring VSCode."
user_directory="$HOME/Library/Application Support/Code/User/"
mkdir -p "${user_directory}"

for file in settings.json keybindings.json; do
  cp -rf "$DOTFILES/macos/vscode/${file}" "${user_directory}"
done
echo "Done."

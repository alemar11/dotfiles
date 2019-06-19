 #!/bin/bash

set -e
set -o pipefail
set -u

# if [ ! -d vscode ]; then
#   echo "Must be run from root of dotfiles"
#   exit 1
# fi

user_directory="$HOME/Library/Application Support/Code/User/"
mkdir -p "${user_directory}"

for file in settings.json keybindings.json; do
  ln -f -s "$DOTFILES/vscode/${file}" "${user_directory}"
done
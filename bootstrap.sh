#!/bin/bash

dotfiles() {
  echo "Updating dotfiles"
  ./dotfiles.sh install
}

macos() {
  echo "Updating macOS"
  ./macos/link.sh
}

vscode() {
  echo "Updating Visual Studio Code"
  ./vscode/link.sh
}

xcode() {
  echo "Updating Xcode"
  ./xcode/link.sh
}

main() {
  dotfiles
  macos
  vscode
  xcode
}

main
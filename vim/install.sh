#!/bin/bash
# Install only this Vim setup. macOS supplies a suitable classic Vim.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

for tool in vim curl git; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    exit 1
  fi
done

"$REPO_DIR/dotfiles.sh" install vimrc
"$REPO_DIR/dotfiles.sh" install mise/config.toml
if [[ ! "$HOME/.vimrc" -ef "$REPO_DIR/vimrc" ||
      ! "$HOME/.config/mise/config.toml" -ef "$REPO_DIR/mise/config.toml" ]]; then
  echo "Existing Vim or mise configuration was preserved. Back it up and relink before installing." >&2
  exit 1
fi
"$REPO_DIR/macos/mise.sh" node npm:typescript npm:typescript-language-server npm:pyright

if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  mkdir -p "$HOME/.vim/autoload"
  PLUG_DOWNLOAD="$(mktemp "$HOME/.vim/autoload/plug.vim.XXXXXX")"
  trap 'rm -f "$PLUG_DOWNLOAD"' EXIT
  curl -fL --retry 2 https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    -o "$PLUG_DOWNLOAD"
  mv "$PLUG_DOWNLOAD" "$HOME/.vim/autoload/plug.vim"
fi

vim -Nu "$REPO_DIR/vimrc" -i NONE -n -es '+PlugInstall --sync' '+qa!'
for plugin_file in vim-lsp/plugin/lsp.vim vim-which-key/plugin/which_key.vim; do
  if [[ ! -f "$HOME/.vim/plugged/$plugin_file" ]]; then
    echo "Plugin installation failed: $plugin_file. Open Vim and run :PlugInstall." >&2
    exit 1
  fi
done

echo "Vim setup installed. Open a new shell, run vim ., and press Space."

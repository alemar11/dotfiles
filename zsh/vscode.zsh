#!/usr/bin/env zsh
# macOS-only VS Code helpers
# Usage:
#  - vs <file|dir>  -> open in VS Code
#  - vs             -> open current dir
#  - vsf            -> alias for 'vs .'
#  - svs            -> sudo vs

if [[ "$OSTYPE" = darwin* ]]; then
    _vscode_paths=(
        "/usr/local/bin/code"
        "/opt/homebrew/bin/code"
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    )
    for _vscode_path in $_vscode_paths; do
        if [[ -x $_vscode_path ]]; then
            vs_run () { "$_vscode_path" "$@" }
            vs_run_sudo () { sudo "$_vscode_path" "$@" }
            alias vs=vs_run
            alias vsf='vs .'
            alias svs=vs_run_sudo
            break
        fi
    done
fi

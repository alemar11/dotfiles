#!/usr/bin/env zsh
# macOS-only VS Code helpers
# Usage:
#  - vs <file|dir>  -> open in VS Code
#  - vs             -> open current dir (or a .code-workspace if present)
#  - vsf            -> alias for 'vs .'
#  - svs            -> sudo vs

if [[ "$OSTYPE" = darwin* ]]; then
    _vs_resolve_target () {
        local _target="$1"
        local _allow_workspace=0
        if [[ -z "$_target" ]]; then
            _target="."
            _allow_workspace=1
        fi
        if [[ "$_target" == "." && $_allow_workspace -eq 0 ]]; then
            echo "$_target"
            return
        fi
        if [[ -d "$_target" ]]; then
            local _ws=("${_target}"/*.code-workspace(N))
            if (( ${#_ws} > 0 )); then
                echo "${_ws[1]}"
                return
            fi
        fi
        echo "$_target"
    }
    vs_run () {
        if (( $# == 0 )); then
            code "$(_vs_resolve_target "")"
            return
        fi
        if (( $# == 1 )); then
            code "$(_vs_resolve_target "$1")"
        else
            code "$@"
        fi
    }
    vs_run_sudo () {
        if (( $# == 0 )); then
            sudo code "$(_vs_resolve_target "")"
            return
        fi
        if (( $# == 1 )); then
            sudo code "$(_vs_resolve_target "$1")"
        else
            sudo code "$@"
        fi
    }
    alias vs=vs_run
    alias vsf='vs .'
    alias svs=vs_run_sudo
fi

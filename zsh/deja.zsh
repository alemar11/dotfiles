# Predict commands from local history and the current directory.
if (( $+commands[deja] )); then
    # Keep Tab for completion and Ctrl-L for clearing the screen.
    # Right arrow accepts a suggestion; Ctrl-N opens the alternatives picker.
    export DEJA_CYCLE_KEY='^N'

    # Reuse the cached integration; Deja refreshes it after binary upgrades.
    if [[ -r "$HOME/.local/share/deja/init.zsh" ]]; then
        source "$HOME/.local/share/deja/init.zsh"
    else
        eval "$(deja init zsh)"
    fi
fi

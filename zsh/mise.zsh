# Activate mise so globally configured runtimes are available in every shell.
if (( $+commands[mise] )); then
    eval "$(mise activate zsh)"
fi

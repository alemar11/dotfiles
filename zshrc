# Path to dotfiles repo
zshrc_link="$HOME/.zshrc"
if [[ -L "$zshrc_link" ]]; then
    zshrc_target="$(readlink "$zshrc_link" 2>/dev/null || true)"
    if [[ -n "$zshrc_target" ]]; then
        if [[ "$zshrc_target" != /* ]]; then
            zshrc_target="$HOME/$zshrc_target"
        fi
        DOTFILES="${zshrc_target:h}"
    fi
fi
: "${DOTFILES:=$HOME/Developer/dotfiles}"
export DOTFILES

# Functions
fpath=(~/.zsh/functions $fpath)
autoload_targets=(~/.zsh/functions/*(N:t))
if (( ${#autoload_targets} )); then
    autoload -Uz "${autoload_targets[@]}"
fi

# Define the base directories for cd command
cdpath=($HOME/Developer $HOME/Documents)

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# Load all the .zsh files
for file in ~/.zsh/*.zsh(N); do
    source "$file"
done

# Adding path directory for custom scripts
export PATH=$DOTFILES/bin:$PATH

# Check for custom bin directory and add to path
if [[ -d ~/bin ]]; then
    export PATH=~/bin:$PATH
fi

# Add brew to path
export PATH=/opt/homebrew/bin:$PATH 

# Add pipx to path
export PATH=~/.local/bin:$PATH

# Adds the Android SDK platform-tools directory to the system PATH environment variable.
# This allows the user to run Android SDK tools from any terminal session without specifying the full path.
export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools

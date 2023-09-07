
# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

# Functions
fpath=(~/.zsh/functions $fpath)
autoload -Uz ~/.zsh/functions/*(:t)

# Define the base directories for cd command
cdpath=($HOME/Developer $HOME/Documents)

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# Load all the .zsh files
for file (~/.zsh/configurations/*.zsh) source $file

# Adding path directory for custom scripts
export PATH=$DOTFILES/bin:$PATH

# Check for custom bin directory and add to path
if [[ -d ~/bin ]]; then
    export PATH=~/bin:$PATH
fi

# Add rbenv to path to access command-line utility
export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

# Add brew to path
export PATH=/opt/homebrew/bin:$PATH 

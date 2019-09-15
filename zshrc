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
for file (~/.zsh/*.zsh) source $file

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

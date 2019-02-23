# Functions
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# Define the base directories for cd command
cdpath=($HOME/Developer $HOME/Documents)

# Editor
export EDITOR='vim'

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# Load all the .zsh files
for file (~/.zsh/*.zsh) source $file

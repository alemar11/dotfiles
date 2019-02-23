# Completion functions
#
# Completion functions for commands are stored in files with names beginning with an underscore _, 
# and these files should be placed in a directory listed in the $fpath variable. 
# https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org
fpath=(~/.zsh/completions ~/.zsh/functions $fpath)

# enable autocomplete function
autoload -U compinit
compinit

autoload -U ~/.zsh/functions/*(:t)

# Define the base directory for cd command
cdpath=($HOME/Developer $HOME/Documents)

# Editor
export EDITOR='vim'

# Paths
#export PATH=""

# Timer
REPORTTIME=10 # print elapsed time when more than 10 seconds

# Quote pasted URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Load all the .zsh files
for file (~/.zsh/*.zsh) source $file

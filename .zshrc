# Load functions and completion
fpath=(~/.zsh/functions $fpath)
autoload -U compinit
compinit
autoload -U ~/.zsh/functions/*(:t)

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

# Load files
for file (~/.zsh/*.zsh) source $file

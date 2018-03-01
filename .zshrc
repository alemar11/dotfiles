# Load functions and completion
fpath=(~/.zsh/functions $fpath)
autoload -U compinit
compinit
autoload -U ~/.zsh/functions/*(:t)

# Colors
# https://geoff.greer.fm/lscolors/
export CLICOLOR=1
autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"

cdpath=($HOME/Developer $HOME/Documents $HOME/Downloads)

# Editor
export EDITOR='vim'

# Paths
#export PATH=""

# Timer
REPORTTIME=10 # print elapsed time when more than 10 seconds

# Quote pasted URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Misc options
setopt AUTO_CD # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt PROMPT_SUBST # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt

# Load files
for file (~/.zsh/*.zsh) source $file

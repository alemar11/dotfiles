# Completion functions for commands are stored in files with names beginning with an underscore _, 
# and these files should be placed in a directory listed in the $fpath variable. 
# These functions whose name begins with an underscore are part of the programmable completion engine. 
# Bash follows zsh's convention here, where the function that generates completions for somecommand is called _somecommand, 
# and if that function requires auxiliary functions, they are called _somecommand_stuff.
fpath=($HOME/.zsh/completions $fpath)

# Homebrew's zsh completions
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Custom zsh completions
autoload -Uz compinit && compinit -i

zmodload zsh/complist

setopt complete_in_word
# setopt MENU_COMPLETE # immediatelly insert first match

zstyle ':completion:*' completer _complete _prefix
zstyle ':completion:*' add-space true

# Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# Smart case matching && match inside filenames
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*:*:*:*:*' menu select

# Rehash when completing commands
zstyle ":completion:*:commands" rehash 1

# Process completion shows all processes with colors
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' command 'ps -A -o pid,user,cmd'
zstyle ':completion:*:*:*:*:processes' list-colors "=(#b) #([0-9]#)*=0=${color[green]}"
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Display message when no matches are found
zstyle ':completion:*:warnings' format '%BNo matches.'

# Ignore internal zsh functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# Grouping for completion types (trial)
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:descriptions' format "%{${fg_bold[yellow]}%}∙︎ %d%{$reset_color%}"
# zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*' group-name ""

# Speedup path completion
zstyle ':completion:*' accept-exact '*(N)'

# Cache expensive completions
# Enable completion caching, use rehash to clear
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST


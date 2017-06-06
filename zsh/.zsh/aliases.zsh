# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."

# ls
alias ls='ls -F'
alias ll='ls -la'

# Git
alias g='git'
alias ga='git add .'
alias gb='git branch -a'
alias gbclean='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gc='git commit -a'
alias gcount='git shortlog -sn'
alias gd='git branch -d'
alias gD='git branch -D'
alias gf='git fetch'
alias gl='git log --graph --decorate --all'
alias glp="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias gp='git push'
alias gs='git status'
alias gsb='git status -sb'
alias gsu='git submodule update --init --recursive'
alias gt='git checkout -t'
alias gundo='git reset --soft HEAD~1'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# macOS
alias o='open .'
alias screensaver='/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'

# Commands starting with % for pasting from web
alias %=' '
alias $=' '

# Homebrew
alias brewup='brew update && brew doctor && brew outdated && brew upgrade && brew cleanup -s --prune=1'

# Ruby
alias b='bundle'
alias be='bundle exec'

# Ruby Gems
alias gemup='gem update --system && gem cleanup && gem update'

## SSH
alias ssha='find ~/.ssh/ -type f -exec grep -l "PRIVATE" {} \; | xargs ssh-add &> /dev/null'

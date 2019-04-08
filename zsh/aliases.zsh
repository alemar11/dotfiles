# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# cd
alias ..='cd ..'

# ls
alias ls='ls -F'
alias ll='ls -la'
alias cpwd='pwd | pbcopy' #copy working directory
alias cpdir=cpwd

#Processes
alias tu='top -o cpu' # processes sorted by CPU
alias tm='top -o vsize' # processes sorted by Memory

# Git
alias g='git'
alias ga='git add .'
alias gb='git branch -a'
alias gbclean='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gc='git commit -a'
alias gcount='git shortlog -sn'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gd='git branch -d'
alias gD='git branch -D'
alias gexport='git archive --format zip --output'
alias gf='git fetch'
alias gfp='git fetch --prune'
alias gl='git log --graph --decorate --all'
alias glp="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias gm="git mergetool"
alias gp='git push'
alias gs='git status'
alias gsb='git status -sb'
alias gsub='git submodule update --init --recursive'
alias gt='git checkout -t'
alias gundo='git reset --soft HEAD~1'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'

# Commit pending changes and quote all args as message
function gg() {
  git commit -v -a -m "$*"
}

# Swift Package Manager
alias spi='swift package init'
alias spf='swift package fetch'
alias spu='swift package update'
alias spx='swift package generate-xcodeproj'
alias sps='swift package show-dependencies'
alias spd='swift package dump-package'

# Simulators

## Directory
alias sim='cd ~/Library/Developer/CoreSimulator'

## List
alias sim-list='xcrun simctl list --json'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# macOS
alias o='open .'
alias screensaver='/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'

# Ruby
alias b='bundle'
alias be='bundle exec'

## SSH
alias ssha='find ~/.ssh/ -type f -exec grep -l "PRIVATE" {} \; | xargs ssh-add &> /dev/null'

# Update commands
alias brewup="brew update && brew doctor && brew outdated && brew upgrade && brew cleanup"
alias gemup='gem update --system && gem update && gem cleanup'
#alias npmup='npm -g cache clean && npm -g update && npm-check-updates -u && npm install'
alias sysup='sudo softwareupdate -i -a'
alias upall='sysup && brewup && gemup'
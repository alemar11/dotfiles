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
alias gc='git commit -v'
alias gca="git commit -v -a"
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
alias glr="git log --pretty=oneline --abbrev-commit --first-parent"
alias gm="git mergetool"
alias gp='git push'
alias gs='git status'
alias gsb='git status -sb'
alias gsub='git submodule update --init --recursive'
alias gt='git checkout -t'
alias gundo='git reset --soft HEAD~1'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'

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
alias lip="ifconfig en0 | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1' && ifconfig en1 | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# macOS
alias o='open .'
alias speedtest='networkquality'

# Python (`type python3` to find the path)
alias python='/opt/homebrew/bin/python3'
alias py='python'
alias pip='/opt/homebrew/bin/pip3'

## SSH
alias ssha='find ~/.ssh/ -type f -exec grep -l "PRIVATE" {} \; | xargs ssh-add &> /dev/null'

# Update commands
alias sysup='sudo softwareupdate -i -a'

# Caffeinate
alias caffe='caffeinate'

# JSON::PP
alias jsonpp='json_pp -json_opt pretty,utf8'

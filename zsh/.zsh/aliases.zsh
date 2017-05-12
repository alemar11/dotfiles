# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls
alias ls='ls -F'
alias ll='ls -l'

# Git
alias g='git'
alias ga='git add .'
alias gb='git branch -a'
alias gc='git commit -a'
alias gf='git fetch'
alias gl='git log --graph --decorate --all'
alias glp="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
compdef _git gs=git-status
alias gp='git push'
alias gs='git status'
alias gsu='git submodule update --init --recursive'
alias gu='git up'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'
alias gbclean='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

# macOS
alias o='open .'
alias screensaver='/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'

# Commands starting with % for pasting from web
alias %=' '
alias $=' '

# Homebrew
alias brewup='brew update && brew doctor && brew outdated && brew upgrade && brew cleanup -s --prune=1'

# Ruby
alias b='bundle exec'

# Ruby Gems
alias gemup='gem update --system && gem cleanup && gem update'

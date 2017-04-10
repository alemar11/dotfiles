# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls
alias ls='ls -F'
alias ll='ls -l'

# Git
alias gsu='git submodule update --init --recursive'
alias gs='git status'
alias gp='git push'
alias gu='git up'
alias gc='git commit -a'
alias ga='git add .'
compdef _git gs=git-status
alias cleanup_branches='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

# Ruby
alias b='bundle exec'

# macOS
alias o='open .'
alias screensaver='/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'

# Commands starting with % for pasting from web
alias %=' '
alias $=' '

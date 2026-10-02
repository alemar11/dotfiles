# Reload zsh and rebuild completion metadata
alias reload='rm -f "${ZDOTDIR:-$HOME}/.zcompdump" && exec zsh -l'

# cd
alias ..='cd ..'

# Listing: leave `ls` as the real binary so flags like `-t` keep working.
# Fancy eza listings use short aliases instead.
alias l='eza --icons --grid --group-directories-first --almost-all'
alias ll='l -la'
alias lt='l -s modified'
alias cat='bat'
alias vim='nvim'
alias cpwd='pwd | pbcopy' #copy working directory
alias cpdir=cpwd

#Processes
alias tu='top -o cpu' # processes sorted by CPU
alias tm='top -o vsize' # processes sorted by Memory

# Git
alias g='git'
alias ga='git add .'
alias gb='git branch -a'
alias gc='git commit -v'
alias gca="git commit -v -a"
alias gcb='git checkout -b'
alias gd='git branch -d'
alias gD='git branch -D'
alias gf='git fetch'
alias gl='git log --graph --decorate --all'
alias gm="git mergetool"
alias gp='git push'
alias gs='git status'
alias gwip='git add -A && git commit --no-verify -m "--wip-- [skip ci]"'

# Lazygit and Lazydocker
alias ld='lazydocker'

# Codex / Cursor Agent
alias cx='codex --yolo'
alias cua='agent --yolo'
alias ff='fastfetch'

# Simulators

## Directory
alias sim='cd ~/Library/Developer/CoreSimulator'

## List
alias sim-list='xcrun simctl list --json'

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# macOS
alias o='open .'
alias speedtest='networkquality'

# Python is managed globally by mise.
alias py='python'

## SSH
alias ssha='find ~/.ssh/ -type f -exec grep -l "PRIVATE" {} \; | xargs ssh-add &> /dev/null'

# Update commands
alias sysup='sudo softwareupdate -i -a'

# Homebrew
bu() {
  echo "⬆️ Updating Homebrew and upgrading packages..."
  brew update &&
    brew upgrade --yes &&
    brew cleanup
}

# mise
mu() {
  echo "⬆️ Updating mise-managed tools..."
  mise install &&
    mise upgrade --yes
}

# Update Homebrew first, then mise-managed tools.
alias u='bu && mu'

# npm
alias nu='echo "⬆️ Updating global packages (including npm)..." && npm update -g && npm install -g npm'

# Caffeinate
alias caffe='caffeinate'

# JSON::PP
alias jsonpp='json_pp -json_opt pretty,utf8'

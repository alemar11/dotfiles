function vibe() {
  git worktree add "../$(basename "$PWD")-$1" -b "$1" &&
  cd "../$(basename "$PWD")-$1"
}
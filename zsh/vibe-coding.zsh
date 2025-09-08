function vibe-coding-new-worktree() {
  git worktree add "../$(basename "$PWD")-$1" -b "$1" &&
  cd "../$(basename "$PWD")-$1"
}

function vibe-coding-cross-memory() {
  local link="CLAUDE.md"
  local target="AGENTS.md"

  # 0) Remove existing CLAUDE.md symlink (even if broken)
  if [[ -L "$link" || ( ! -e "$link" && -h "$link" ) ]]; then
    rm -f -- "$link"
    echo "🧹 Removed existing symlink $link"
  fi

  # 1) If CLAUDE.md is a regular file (not a symlink), rename it to AGENTS.md
  if [[ -f "$link" && ! -L "$link" ]]; then
    if [[ -e "$target" ]]; then
      # Avoid data loss: keep existing AGENTS.md, back up CLAUDE.md instead
      local backup="$target.old-$(date +%Y%m%d-%H%M%S)"
      mv -- "$link" "$backup"
      echo "⚠️ $target already exists; moved $link to $backup"
    else
      mv -- "$link" "$target"
      echo "✅ Renamed $link → $target"
    fi
  fi

  # 2) If AGENTS.md exists, (re)create CLAUDE.md symlink to it
  if [[ -e "$target" ]]; then
    ln -sf -- "$target" "$link"
    echo "🔗 Created symlink $link → $target"
  else
    echo "❌ Neither $link (as a file) nor $target found; nothing to link"
  fi
}
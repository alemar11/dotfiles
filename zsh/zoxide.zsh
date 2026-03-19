if command -v zoxide >/dev/null 2>&1; then
  export _ZO_FZF_OPTS=$'--height=~50% --min-height=12+ --layout=reverse --preview \'dir=$(printf %s {} | cut -f2-); if command -v eza >/dev/null 2>&1; then eza --icons --group-directories-first --color=always -- "$dir"; else ls -la -- "$dir"; fi\' --preview-window=bottom,8,border-top'
  eval "$(zoxide init zsh)"
fi

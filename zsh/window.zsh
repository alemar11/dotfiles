set-tab-title() {
  echo -en "\033]1;$*\007"
}

reset-tab-title() {
  echo -en "\033]1;\007"
}

# --- Window title ---
set-window-title() {
  echo -en "\033]2;$*\007"
}

reset-window-title() {
  echo -en "\033]2;\007"
}
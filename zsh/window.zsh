set-title() {
  print -n "\e]0;$*\a"
}

reset-title() {
  print -n "\e]0;\a"
}

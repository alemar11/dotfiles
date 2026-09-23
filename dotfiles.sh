#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Configuration format: "source:target:type"
# Types:
#   - file: Link a single file to ~/.target
#   - folder: Link entire folder to ~/.target
DOTFILES=(
  "bat:.config/bat:folder"
  "btop/btop.conf:.config/btop/btop.conf:file"
  "btop/themes/dotfiles-dark.theme:.config/btop/themes/dotfiles-dark.theme:file"
  "btop/themes/dotfiles-light.theme:.config/btop/themes/dotfiles-light.theme:file"
  "curlrc:.curlrc:file"
  "fastfetch:.config/fastfetch:folder"
  "git_template:.git_template:folder"
  "gitconfig:.gitconfig:file"
  "gitignore_global:.gitignore_global:file"
  "ghostty/config.ghostty:.config/ghostty/config.ghostty:file"
  "ghostty/themes/dotfiles-dark:.config/ghostty/themes/dotfiles-dark:file"
  "ghostty/themes/dotfiles-light:.config/ghostty/themes/dotfiles-light:file"
  "herdr/config.toml:.config/herdr/config.toml:file"
  "hushlogin:.hushlogin:file"
  "lldb_helpers:.lldb_helpers:folder"
  "lldbinit:.lldbinit:file"
  "lldbinit-Xcode:.lldbinit-Xcode:file"
  "mise/config.toml:.config/mise/config.toml:file"
  "nvim:.config/nvim:folder"
  "starship.toml:.config/starship.toml:file"
  "vimrc:.vimrc:file"
  "yazi:.config/yazi:folder"
  "zsh:.zsh:folder"
  "zshenv:.zshenv:file"
  "zshrc:.zshrc:file"
)

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Override only when installing into a staging directory (for example, in tests).
DOTFILES_TARGET_DIR="${DOTFILES_TARGET_DIR:-$HOME}"
SELECTED_DOTFILES=("${DOTFILES[@]}")

select_source() {
  local requested="$1"
  local entry
  for entry in "${DOTFILES[@]}"; do
    if [[ "${entry%%:*}" == "$requested" ]]; then
      SELECTED_DOTFILES=("$entry")
      return 0
    fi
  done
  log_error "Unknown dotfile source '$requested'; no changes made."
  return 1
}

# Runtime state
COUNT_LINKED=0
COUNT_REMOVED=0
COUNT_SKIPPED=0
COUNT_WARNINGS=0
COUNT_ERRORS=0
FORCE_YES=0
declare -a FAILURES=()

COLOR_INFO=""
COLOR_OK=""
COLOR_WARN=""
COLOR_ERR=""
COLOR_RESET=""
COLOR_TITLE=""

is_interactive_tty() {
  [[ -t 0 && -t 1 ]]
}

supports_color() {
  [[ -t 1 && "${TERM:-}" != "dumb" && -z "${NO_COLOR:-}" ]]
}

init_colors() {
  if supports_color; then
    COLOR_INFO=$'\033[36m'
    COLOR_OK=$'\033[32m'
    COLOR_WARN=$'\033[33m'
    COLOR_ERR=$'\033[31m'
    COLOR_TITLE=$'\033[35m'
    COLOR_RESET=$'\033[0m'
  fi
}

log_with_level() {
  local level="$1"
  local color="$2"
  shift 2
  printf "%b[%s]%b %s\n" "$color" "$level" "$COLOR_RESET" "$*"
}

log_info() {
  log_with_level "INFO" "$COLOR_INFO" "$@"
}

log_ok() {
  log_with_level "OK" "$COLOR_OK" "$@"
}

log_skip() {
  COUNT_SKIPPED=$((COUNT_SKIPPED + 1))
  log_with_level "SKIP" "$COLOR_INFO" "$@"
}

log_warn() {
  COUNT_WARNINGS=$((COUNT_WARNINGS + 1))
  FAILURES+=("WARNING: $*")
  log_with_level "WARN" "$COLOR_WARN" "$@"
}

log_error() {
  COUNT_ERRORS=$((COUNT_ERRORS + 1))
  FAILURES+=("ERROR: $*")
  log_with_level "ERROR" "$COLOR_ERR" "$@" >&2
}

reset_run_state() {
  COUNT_LINKED=0
  COUNT_REMOVED=0
  COUNT_SKIPPED=0
  COUNT_WARNINGS=0
  COUNT_ERRORS=0
  FAILURES=()
}

print_summary() {
  local action="$1"
  printf "\n%bSummary (%s)%b\n" "$COLOR_TITLE" "$action" "$COLOR_RESET"
  printf "  linked:   %d\n" "$COUNT_LINKED"
  printf "  removed:  %d\n" "$COUNT_REMOVED"
  printf "  skipped:  %d\n" "$COUNT_SKIPPED"
  printf "  warnings: %d\n" "$COUNT_WARNINGS"
  printf "  errors:   %d\n" "$COUNT_ERRORS"

  if [[ ${#FAILURES[@]} -gt 0 ]]; then
    echo "  failures:"
    local failure
    for failure in "${FAILURES[@]}"; do
      printf "    - %s\n" "$failure"
    done
  fi

  echo ""
}

# Parse dotfile entry into components
parse_entry() {
  local entry="$1"
  IFS=':' read -r source target type <<< "$entry"
  echo "$source" "$target" "$type"
}

# Check whether a symlink points to an expected source path
symlink_points_to() {
  local link_path="$1"
  local expected_source="$2"
  local link_target

  [[ -L "$link_path" ]] || return 1
  link_target="$(readlink "$link_path" 2>/dev/null || true)"
  [[ "$link_target" == "$expected_source" ]]
}

# Ensure the target parent directory exists before linking
ensure_target_parent_dir() {
  local target="$1"
  local target_dir

  target_dir="$(dirname "$target")"
  if [[ ! -d "$target_dir" ]]; then
    if mkdir -p "$target_dir"; then
      log_ok "Created $target_dir"
    else
      log_error "Failed to create directory $target_dir"
      return 1
    fi
  fi
}

# Remove a dangling symlink so install can recreate the managed link
clear_dangling_symlink() {
  local target="$1"

  if [[ -L "$target" && ! -e "$target" ]]; then
    if rm "$target"; then
      log_ok "Removed dangling symlink $target"
    else
      log_error "Failed to remove dangling symlink $target"
      return 1
    fi
  fi
}

# Link a single file
link_file() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    log_error "$source doesn't exist"
    return 1
  fi

  if ! ensure_target_parent_dir "$target"; then
    return 1
  fi

  if ! clear_dangling_symlink "$target"; then
    return 1
  fi

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    if ln -s "$source" "$target"; then
      COUNT_LINKED=$((COUNT_LINKED + 1))
      log_ok "Linked $source -> $target"
    else
      log_error "Failed to link $source -> $target"
      return 1
    fi
  else
    log_skip "$target already exists"
  fi
}

# Link an entire folder
link_folder() {
  local source="$1"
  local target="$2"

  if [[ ! -d "$source" ]]; then
    log_error "$source doesn't exist or is not a directory"
    return 1
  fi

  if ! ensure_target_parent_dir "$target"; then
    return 1
  fi

  if ! clear_dangling_symlink "$target"; then
    return 1
  fi

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    if ln -s "$source" "$target"; then
      COUNT_LINKED=$((COUNT_LINKED + 1))
      log_ok "Linked folder $source -> $target"
    else
      log_error "Failed to link folder $source -> $target"
      return 1
    fi
  else
    log_skip "$target already exists"
  fi
}

# Process a single dotfile entry for installation
install_entry() {
  local entry="$1"
  read -r source target type <<< "$(parse_entry "$entry")"

  local source_path="$SCRIPT_DIR/$source"
  local target_path="$DOTFILES_TARGET_DIR/$target"

  case "$type" in
    file)
      link_file "$source_path" "$target_path"
      ;;
    folder)
      link_folder "$source_path" "$target_path"
      ;;
    *)
      log_error "Unknown type '$type' for $source"
      return 1
      ;;
  esac
}

# Remove a single file or symlink
remove_file() {
  local target="$1"
  local expected_source="$2"

  if [[ -L "$target" ]]; then
    if symlink_points_to "$target" "$expected_source"; then
      if rm "$target"; then
        COUNT_REMOVED=$((COUNT_REMOVED + 1))
        log_ok "Removed symlink $target"
      else
        log_error "Failed to remove symlink $target"
        return 1
      fi
    else
      log_warn "$target is a symlink not managed by this repo, skipping"
    fi
  elif [[ -e "$target" ]]; then
    log_warn "$target exists but is not a symlink, skipping"
  fi
}

# Process a single dotfile entry for removal
remove_entry() {
  local entry="$1"
  read -r source target type <<< "$(parse_entry "$entry")"

  local source_path="$SCRIPT_DIR/$source"
  local target_path="$DOTFILES_TARGET_DIR/$target"

  case "$type" in
    file|folder)
      remove_file "$target_path" "$source_path"
      ;;
    *)
      log_error "Unknown type '$type' for $source"
      return 1
      ;;
  esac
}

# Install all dotfiles
install_all() {
  log_info "Installing dotfiles..."
  local entry
  for entry in "${SELECTED_DOTFILES[@]}"; do
    if ! install_entry "$entry"; then
      return 1
    fi
  done
  log_ok "Installation complete."
}

# Remove all dotfiles
remove_all() {
  log_info "Removing dotfiles..."
  local entry
  for entry in "${SELECTED_DOTFILES[@]}"; do
    if ! remove_entry "$entry"; then
      return 1
    fi
  done
  log_ok "Removal complete."
}

# Clean broken symlinks in home directory
clean_broken_links() {
  log_info "Cleaning broken symlinks managed by dotfiles..."
  local entry
  for entry in "${SELECTED_DOTFILES[@]}"; do
    read -r source target type <<< "$(parse_entry "$entry")"
    local source_path="$SCRIPT_DIR/$source"
    local target_path="$DOTFILES_TARGET_DIR/$target"

    case "$type" in
      file|folder)
        if [[ -L "$target_path" && ! -e "$target_path" ]] && symlink_points_to "$target_path" "$source_path"; then
          if rm "$target_path"; then
            COUNT_REMOVED=$((COUNT_REMOVED + 1))
            log_ok "Removed broken symlink $target_path"
          else
            log_error "Failed to remove broken symlink $target_path"
            return 1
          fi
        fi
        ;;
      *)
        log_error "Unknown type '$type' for $source"
        return 1
        ;;
    esac
  done
  log_ok "Cleaning complete."
}

confirm_action() {
  local action="$1"
  local answer

  read -r -p "Run '$action'? [y/N] " answer || return 1
  case "$answer" in
    y|Y|yes|YES|Yes)
      return 0
      ;;
    *)
      log_info "Cancelled."
      return 1
      ;;
  esac
}

# remove/clean require --yes or an interactive confirmation
require_destructive_confirmation() {
  local action="$1"

  if [[ $FORCE_YES -eq 1 ]]; then
    return 0
  fi

  if is_interactive_tty; then
    confirm_action "$action"
    return $?
  fi

  log_error "Refusing to run '$action' without confirmation. Re-run with --yes."
  return 1
}

run_action() {
  local action="$1"
  local rc=0

  if [[ "$action" == "remove" || "$action" == "clean" ]]; then
    if ! require_destructive_confirmation "$action"; then
      return 1
    fi
  fi

  reset_run_state

  case "$action" in
    install)
      if install_all; then
        :
      else
        rc=$?
      fi
      ;;
    remove)
      if remove_all; then
        :
      else
        rc=$?
      fi
      ;;
    clean)
      if clean_broken_links; then
        :
      else
        rc=$?
      fi
      ;;
    *)
      log_error "Unknown action '$action'"
      rc=1
      ;;
  esac

  if [[ $rc -ne 0 && $COUNT_ERRORS -eq 0 ]]; then
    log_error "Action '$action' failed."
  fi

  print_summary "$action"
  return "$rc"
}

show_menu() {
  local choice
  local action
  local action_rc=0

  while true; do
    printf "\n%bDotfiles Manager%b\n" "$COLOR_TITLE" "$COLOR_RESET"
    echo "  1) Install dotfiles"
    echo "  2) Remove dotfiles"
    echo "  3) Clean broken symlinks"
    echo "  4) Exit"
    read -r -p "Select an option [1-4]: " choice || return 1

    case "$choice" in
      1) action="install" ;;
      2) action="remove" ;;
      3) action="clean" ;;
      4)
        log_info "Exiting."
        return "$action_rc"
        ;;
      *)
        log_warn "Invalid option '$choice'."
        continue
        ;;
    esac

    if run_action "$action"; then
      action_rc=0
    else
      action_rc=$?
    fi
  done
}

# Print usage
usage() {
  echo "Usage:"
  echo "  $0                              # Interactive menu (TTY only)"
  echo "  $0 install [source]"
  echo "  $0 {remove|clean} [--yes] [source]"
  echo "  $0 install vimrc                # Only link the Vim configuration"
  echo ""
  echo "Commands:"
  echo "  install - Create symlinks for all dotfiles"
  echo "  remove  - Remove managed dotfile symlinks"
  echo "  clean   - Remove managed broken symlinks from home directory"
  echo "  source  - Optional exact source from DOTFILES (default: all)"
  echo "  --yes   - Skip confirmation for remove/clean (required when not a TTY)"
  echo "  DOTFILES_TARGET_DIR overrides the target home directory for staging."
}

# Main script logic
main() {
  init_colors

  if [[ $# -eq 0 ]]; then
    if is_interactive_tty; then
      show_menu
      return $?
    fi

    usage
    return 1
  fi

  local action="$1"
  shift

  FORCE_YES=0
  local source=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --yes|-y)
        FORCE_YES=1
        ;;
      -*)
        log_error "Unknown option '$1'"
        usage
        return 1
        ;;
      *)
        if [[ -n "$source" ]]; then
          usage
          return 1
        fi
        source="$1"
        ;;
    esac
    shift
  done

  case "$action" in
    install|remove|clean)
      if [[ -n "$source" ]]; then
        select_source "$source" || return 1
      fi
      run_action "$action"
      ;;
    *)
      usage
      return 1
      ;;
  esac
}

# Run main function
main "$@"

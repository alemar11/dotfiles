" Neovim. Linked with: ./dotfiles.sh install nvim
" Bare style match for classic Vim:
" - Ghostty/macOS appearance + Starship colorscheme before the first redraw
" - line numbers; no plugins

" Ghostty follows macOS appearance. Pick the same palette before the first
" redraw; its background-color reply arrives only after Neovim has drawn a frame.
if has('macunix') && $TERM_PROGRAM ==# 'ghostty'
  let &background = trim(system('/usr/bin/defaults read -g AppleInterfaceStyle 2>/dev/null')) ==# 'Dark' ? 'dark' : 'light'
endif

" Reuse Vim's colorscheme from the sibling tree, without a second copy.
execute 'set runtimepath^=' . fnameescape(fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . '/vim')

set termguicolors
colorscheme dotfiles

set number norelativenumber

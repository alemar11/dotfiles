" Classic Vim. Linked with: ./dotfiles.sh install vimrc
" Current setup:
" - no plugins, no extra mappings
" - Ghostty/macOS appearance + Starship colorscheme before the first redraw
" - syntax, filetype indent, line numbers, highlighted search
" - 2-space tabs, mouse
" - undo/swap/backup/netrw files under ~/.vim
" - :find across the tree; :grep uses ripgrep when installed
set nocompatible

" Ghostty follows macOS appearance. Pick the same palette before the first
" redraw; its background-color reply arrives only after Vim has drawn a frame.
if has('macunix') && $TERM_PROGRAM ==# 'ghostty'
  let &background = trim(system('/usr/bin/defaults read -g AppleInterfaceStyle 2>/dev/null')) ==# 'Dark' ? 'dark' : 'light'
endif

" Load our colorscheme through the vimrc symlink, without another installation.
execute 'set runtimepath^=' . fnameescape(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/vim')

" Apple's Vim defaults to the old regexp engine, which hangs on TSX/TS
" syntax highlighting with "'redrawtime' exceeded". Use automatic selection.
if &regexpengine == 1
  set regexpengine=0
endif
set redrawtime=10000

filetype plugin indent on
syntax on

if has('termguicolors')
  set termguicolors
endif
colorscheme dotfiles

set history=1000 autoread hidden belloff=all
set number norelativenumber ruler showcmd nowrap
set hlsearch incsearch ignorecase smartcase
set shortmess-=S
set scrolloff=3 splitbelow splitright
nnoremap n nzzzv
nnoremap N Nzzzv
set wildmenu wildmode=longest:full,full
set expandtab shiftwidth=2 softtabstop=2 tabstop=2
set mouse=a
set conceallevel=0

" Cursor shapes in terminal Vim: block in Normal, blinking | in Insert, underline in Replace.
if exists('&t_SI')
  let &t_SI = "\e[5 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif

" Keep generated files outside project directories.
for s:directory in ['backup', 'swap', 'undo']
  call mkdir(expand('~/.vim/' . s:directory), 'p', 0700)
endfor
set undofile
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
let g:netrw_home = expand('~/.vim')

set path=.,**
set wildignore+=*/.git/*,*/node_modules/*,*/.build/*,*/.venv/*,*/__pycache__/*
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --
  set grepformat=%f:%l:%c:%m
endif

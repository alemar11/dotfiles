" Classic Vim. Linked with: ./dotfiles.sh install vimrc
" Current setup:
" - no plugins, no custom colorscheme, no extra mappings
" - syntax, filetype indent, line numbers, highlighted search
" - 2-space tabs, mouse, default terminal colors
" - undo/swap/backup/netrw files under ~/.vim
" - :find across the tree; :grep uses ripgrep when installed
set nocompatible
filetype plugin indent on
syntax on

set history=1000 autoread hidden belloff=all
set number norelativenumber ruler showcmd nowrap
set hlsearch incsearch ignorecase smartcase
set scrolloff=3 splitbelow splitright
set wildmenu wildmode=longest:full,full
set expandtab shiftwidth=2 softtabstop=2 tabstop=2
set mouse=a
set conceallevel=0

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

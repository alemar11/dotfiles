" Runtime Paths

set runtimepath+=~/.vim/bundle/swift.vim
set runtimepath+=~/.vim/bundle/markdown.vim

" General

set nocompatible                    "this must be first, because it changes other options as a side effect.
filetype plugin on
filetype indent on

" Configuration

set backspace=indent,eol,start      "allow backspacing over everything in insert mode
set history=1000                    "store lots of :cmdline history
set showcmd                         "show incomplete cmds down the bottom
set showmode                        "show current mode down the bottom
set visualbell                      "no sounds
set autoread                        "reload files changed outside vim
set laststatus=2                    "always display the status bar
set ignorecase                      "case-insensitive search
set incsearch
set nowrap
set ruler

" Theme

syntax on                           "syntax highlighting
set nu                              "show line numbers
set ru                              "show ruler at cursor pos
"set cursorline                      "highlight current line
set hlsearch                        "highlight search results
set showmatch                       "matching parentheses
set gcr=n:blinkon0                  "turn off blinking cursor in normal mode

" Indentation

set autoindent
set smartindent
set smarttab                        "uses shiftwidth instead of tabstop at
set shiftwidth=2                    "the amount to block indent when using <
set softtabstop=2                   "causes backspace to delete 2 spaces =
set tabstop=2
set expandtab                       "uses spaces instead of tabs

" Extra

"enable or disable the key column
nnoremap K :set nonumber!<CR>:set foldcolumn=0<CR> 

"show usefull info on the status bar
set statusline=%F%m%r%h%w\ %y\ [row=%l/%L]\ [col=%02v]\ [%02p%%]\ 
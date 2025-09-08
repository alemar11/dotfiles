" ---------- General ----------
set nocompatible
filetype plugin indent on
syntax on

" ---------- Behavior ----------
set history=1000
set autoread
set hidden                      " switch buffers without saving
set belloff=all
set updatetime=300

" ---------- UI ----------
set number                      " absolute line numbers
set norelativenumber             
set ruler                       
set showcmd
set nowrap
set hlsearch
set incsearch
set ignorecase
set smartcase                   " case-sensitive if pattern has uppercase
set showmatch
set matchtime=2
set signcolumn=auto
set scrolloff=3
set splitbelow
set splitright
set wildmenu
set wildmode=longest:full,full
if has('termguicolors')
  set termguicolors
endif

" One statusline (Neovim/Vim recent). Fallback to 2 if you prefer.
if has('nvim') || v:version >= 802
  set laststatus=3
else
  set laststatus=2
endif

" ---------- Indentation ----------
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
" Optional smarter indent for C-like languages:
" set cindent

" ---------- Files ----------
set undofile                    " persistent undo
set backupdir^=~/.vim/backup//
set directory^=~/.vim/swap//
set undodir^=~/.vim/undo//

" ---------- Clipboard / Mouse (optional) ----------
" set clipboard=unnamedplus
set mouse=a

" ---------- Statusline ----------
set statusline=%F%m%r%h%w\ %y\ [row=%l/%L]\ [col=%02v]\ [%02p%%]

" ---------- Safer cursor shapes ----------
if exists('+guicursor')
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
endif
" If you insist on termcap sequences, guard them:
if exists('&t_SI')
  let &t_SI = "\e[6 q"   " insert: vertical bar
  let &t_SR = "\e[4 q"   " replace: underline
  let &t_EI = "\e[2 q"   " normal: block
endif

" ---------- Mappings ----------
" Toggle line numbers + fold/sign columns (don’t clobber K)
nnoremap <leader>n :set invnumber invrelativenumber<CR>

" Toggle search highlight
nnoremap <leader>h :nohlsearch<CR>

" Optional: quick toggle for foldcolumn
nnoremap <leader>f :if &foldcolumn == 0 \| set foldcolumn=1 \| else \| set foldcolumn=0 \| endif<CR>
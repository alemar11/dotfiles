" Classic Vim. Installation and shortcuts: vim/README.md in this repository.
set nocompatible
let mapleader = ' '

" Ghostty follows macOS appearance. Pick the same palette before the first
" redraw; its background-color reply arrives only after Vim has drawn a frame.
if has('macunix') && $TERM_PROGRAM ==# 'ghostty'
  let &background = trim(system('/usr/bin/defaults read -g AppleInterfaceStyle 2>/dev/null')) ==# 'Dark' ? 'dark' : 'light'
endif

" Load our colorscheme through the vimrc symlink, without another installation.
execute 'set runtimepath^=' . fnameescape(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/vim')

" Install explicitly with vim/install.sh; opening Vim never downloads software.
if filereadable(expand('~/.vim/autoload/plug.vim'))
  call plug#begin('~/.vim/plugged')
  Plug 'prabirshrestha/vim-lsp'
  Plug 'liuchengxu/vim-which-key'
  call plug#end()
endif
filetype plugin indent on
syntax on

" ---------- Editing ----------
set history=1000 autoread hidden belloff=all updatetime=300
set number norelativenumber ruler showcmd nowrap
set hlsearch incsearch ignorecase smartcase showmatch matchtime=2
set signcolumn=yes numberwidth=3 scrolloff=3 splitbelow splitright
set cursorline cursorlineopt=number,screenline
set wildmenu wildmode=longest:full,full
set expandtab shiftwidth=2 softtabstop=2 tabstop=2
set mouse=a
set laststatus=2 noshowmode
function! DotfilesVimMode() abort
  return get({'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE',
        \ 'v': 'VISUAL', 'V': 'V-LINE', "\<C-V>": 'V-BLOCK',
        \ 's': 'SELECT', 'S': 'S-LINE', "\<C-S>": 'S-BLOCK',
        \ 'c': 'COMMAND', 't': 'TERMINAL'}, mode(), 'NORMAL')
endfunction
let &statusline = ' %{DotfilesVimMode()} │ %t%m%r%h%w%=%{&filetype}  %l:%c  %p%% '
set completeopt=menuone,noinsert,noselect
set timeout timeoutlen=500 ttimeout ttimeoutlen=100
if has('termguicolors')
  set termguicolors
endif
colorscheme dotfiles

" Keep source characters visible, including Markdown and JSON syntax.
set conceallevel=0
function! s:buffer_display() abort
  setlocal conceallevel=0
  if &filetype ==# 'markdown'
    setlocal wrap linebreak breakindent
  else
    setlocal nowrap nolinebreak nobreakindent
  endif
endfunction
augroup dotfiles_display
  autocmd!
  autocmd FileType,BufWinEnter * call s:buffer_display()
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
  autocmd ModeChanged * redrawstatus
augroup END

" Keep generated files outside project directories.
for s:directory in ['backup', 'swap', 'undo']
  call mkdir(expand('~/.vim/' . s:directory), 'p', 0700)
endfor
set undofile
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
let g:netrw_home = expand('~/.vim')

" Cursor shapes in terminal Vim: block in Normal, bar in Insert.
if exists('&t_SI')
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif

" ---------- Native file navigation and search ----------
set path=.,**
set wildignore+=*/.git/*,*/node_modules/*,*/.build/*,*/.venv/*,*/__pycache__/*
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --
  set grepformat=%f:%l:%c:%m
endif
augroup dotfiles_search
  autocmd!
  autocmd QuickFixCmdPost grep,vimgrep cwindow
augroup END

nnoremap <leader><Space> :find<Space>
nnoremap <silent> <leader>e :Explore<CR>
nnoremap <leader>/ :grep<Space>
nnoremap <silent> <leader>h :nohlsearch<CR>
nnoremap <silent> <leader>bn :bnext<CR>
nnoremap <silent> <leader>bp :bprevious<CR>
nnoremap <leader>bb :ls<CR>:buffer<Space>
nnoremap <silent> <leader>bd :bdelete<CR>
nnoremap <silent> <leader>wv :vsplit<CR>
nnoremap <silent> <leader>ws :split<CR>
nnoremap <silent> <leader>wh <C-W>h
nnoremap <silent> <leader>wj <C-W>j
nnoremap <silent> <leader>wk <C-W>k
nnoremap <silent> <leader>wl <C-W>l
nnoremap <silent> <leader>w= <C-W>=
nnoremap <silent> <leader>wc <C-W>c

" ---------- Language servers ----------
" TS/Python executables are managed by mise; Swift uses mise or active Xcode.
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_signs_error = {'text': 'E'}
let g:lsp_diagnostics_signs_warning = {'text': 'W'}
let g:lsp_diagnostics_signs_information = {'text': 'i'}
let g:lsp_diagnostics_signs_hint = {'text': '?'}

function! s:project_root(markers, server_info) abort
  let directory = expand('%:p:h')
  while !empty(directory)
    for marker in a:markers
      if filereadable(directory . '/' . marker) || isdirectory(directory . '/' . marker)
        return lsp#utils#path_to_uri(directory)
      endif
    endfor
    let parent = fnamemodify(directory, ':h')
    if parent ==# directory
      break
    endif
    let directory = parent
  endwhile
  return lsp#utils#path_to_uri(getcwd())
endfunction

function! s:typescript_fallback() abort
  let compiler = exepath('tsc')
  " Resolve mise's launcher to the actual tool before inspecting its package.
  if executable('mise')
    let installed = trim(system('mise which tsc 2>/dev/null'))
    if v:shell_error == 0 && filereadable(installed)
      let compiler = installed
    endif
  endif
  if empty(compiler)
    return ''
  endif
  " Support npm symlinks and mise's node_modules/.bin wrappers.
  let root = fnamemodify(resolve(compiler), ':h:h')
  for candidate in [root . '/lib/tsserver.js', root . '/typescript/lib/tsserver.js']
    if filereadable(candidate)
      return candidate
    endif
  endfor
  return ''
endfunction

function! s:python_config(server_info) abort
  let root = lsp#utils#uri_to_path(lsp#get_server_root_uri(a:server_info.name))
  " Honor an explicitly activated environment, then try the project's .venv.
  for environment in [$VIRTUAL_ENV, root . '/.venv']
    if !empty(environment) && executable(environment . '/bin/python')
      " Keep the venv path: resolving its symlink would select base Python.
      return {'python': {'pythonPath': environment . '/bin/python'}}
    endif
  endfor
  return {}
endfunction

function! s:swift_command(server_info) abort
  if executable('mise')
    " The file's project may differ from Vim's current directory.
    let root = lsp#utils#uri_to_path(a:server_info.root_uri(a:server_info))
    let server = trim(system('mise --cd ' . shellescape(root) . ' which sourcekit-lsp 2>/dev/null'))
    if v:shell_error == 0 && executable(server)
      return [server]
    endif
  endif
  return ['xcrun', 'sourcekit-lsp']
endfunction

function! s:register_servers() abort
  if executable('typescript-language-server')
    let tsserver = s:typescript_fallback()
    let options = {}
    if !empty(tsserver)
      let options.tsserver = {'fallbackPath': tsserver}
    endif
    call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': {info -> ['typescript-language-server', '--stdio']},
          \ 'root_uri': function('s:project_root', [['tsconfig.json', 'jsconfig.json', 'package.json', '.git']]),
          \ 'allowlist': ['typescript', 'typescriptreact', 'javascript', 'javascriptreact'],
          \ 'initialization_options': options,
          \ })
  endif
  if executable('pyright-langserver')
    call lsp#register_server({
          \ 'name': 'pyright',
          \ 'cmd': {info -> ['pyright-langserver', '--stdio']},
          \ 'root_uri': function('s:project_root', [['pyrightconfig.json', 'pyproject.toml', 'setup.py', 'setup.cfg', '.git']]),
          \ 'workspace_config': function('s:python_config'),
          \ 'allowlist': ['python'],
          \ })
  endif
  if executable('xcrun') || executable('mise')
    call lsp#register_server({
          \ 'name': 'sourcekit-lsp',
          \ 'cmd': function('s:swift_command'),
          \ 'root_uri': function('s:project_root', [['Package.swift', 'buildServer.json', '.git']]),
          \ 'allowlist': ['swift'],
          \ })
  endif
endfunction

function! s:lsp_supports(servers, feature) abort
  for server in a:servers
    if call('lsp#capabilities#has_' . a:feature . '_provider', [server])
      return 1
    endif
  endfor
  return 0
endfunction

function! s:lsp_map(key, command) abort
  execute 'nnoremap <silent> <buffer> ' . a:key . ' :' . a:command . '<CR>'
  call add(b:dotfiles_lsp_keys, a:key)
endfunction

function! s:lsp_buffer_setup() abort
  " Remove only our previous buffer mappings when its language/server changes.
  for key in get(b:, 'dotfiles_lsp_keys', [])
    execute 'silent! nunmap <buffer> ' . key
  endfor
  let b:dotfiles_lsp_keys = []
  let b:dotfiles_lsp_menu = {}
  if &l:omnifunc ==# 'lsp#complete'
    setlocal omnifunc<
  endif
  if exists('+tagfunc') && &l:tagfunc ==# 'lsp#tagfunc'
    setlocal tagfunc<
  endif
  if !exists('g:lsp_loaded')
    return
  endif
  let servers = filter(lsp#get_allowed_servers(), {_, server -> lsp#get_server_status(server) ==# 'running'})
  if empty(servers)
    return
  endif
  if s:lsp_supports(servers, 'completion')
    setlocal omnifunc=lsp#complete
  endif
  if s:lsp_supports(servers, 'definition')
    call s:lsp_map('gd', 'LspDefinition')
  endif
  if s:lsp_supports(servers, 'hover')
    call s:lsp_map('K', 'LspHover')
  endif
  if exists('+tagfunc') && s:lsp_supports(servers, 'definition')
    setlocal tagfunc=lsp#tagfunc
  endif

  let b:dotfiles_lsp_menu = {'name': '+language'}
  for [key, command, label, feature] in [
        \ ['a', 'LspCodeAction', 'code action', 'code_action'],
        \ ['f', 'LspDocumentFormat', 'format', 'document_formatting'],
        \ ['i', 'LspImplementation', 'implementation', 'implementation'],
        \ ['r', 'LspReferences', 'references', 'references'],
        \ ['R', 'LspRename', 'rename', 'rename'],
        \ ['d', 'LspDocumentDiagnostics', 'diagnostics', ''],
        \ ['n', 'LspNextDiagnostic', 'next diagnostic', ''],
        \ ['p', 'LspPreviousDiagnostic', 'previous diagnostic', ''],
        \ ['s', 'LspStatus', 'server status', ''],
        \ ]
    if empty(feature) || s:lsp_supports(servers, feature)
      call s:lsp_map('<leader>l' . key, command)
      let b:dotfiles_lsp_menu[key] = label
    endif
  endfor
endfunction

augroup dotfiles_lsp
  autocmd!
  autocmd User lsp_setup call s:register_servers()
  autocmd User lsp_buffer_enabled call s:lsp_buffer_setup()
  autocmd User lsp_server_exit call s:lsp_buffer_setup()
  autocmd BufEnter,FileType * call s:lsp_buffer_setup()
augroup END

" ---------- Shortcut menu at the bottom ----------
let g:which_key_use_floating_win = 0
let g:which_key_position = 'botright'
let g:which_key_vertical = 0
let g:which_key_map = {
      \ ' ': 'find file (Tab completes)',
      \ 'e': 'file browser',
      \ '/': 'project search',
      \ 'h': 'clear search highlight',
      \ 'b': {'name': '+buffers', 'n': 'next', 'p': 'previous', 'b': 'list', 'd': 'delete'},
      \ 'w': {'name': '+windows', 'v': 'split right', 's': 'split below',
      \       'h': 'left', 'j': 'down', 'k': 'up', 'l': 'right', '=': 'equal size', 'c': 'close'},
      \ }

function! DotfilesWhichKeyMenu() abort
  let menu = deepcopy(g:which_key_map)
  if !empty(get(b:, 'dotfiles_lsp_menu', {}))
    let menu.l = copy(b:dotfiles_lsp_menu)
  endif
  return menu
endfunction

if !empty(globpath(&runtimepath, 'autoload/which_key.vim'))
  call which_key#register('<Space>', 'DotfilesWhichKeyMenu()')
  nnoremap <silent> <leader> :<C-U>WhichKey '<Space>'<CR>
endif

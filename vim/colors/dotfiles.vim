" Starship palette, with neutral surfaces and a matching light variant.
highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'dotfiles'

if &background ==# 'light'
  let s:p = {
        \ 'bg': '#fafaff', 'fg': '#2c323c', 'surface': '#edf0f6',
        \ 'muted': '#697381', 'dim': '#b5bdc9', 'selection': '#dce4ef',
        \ 'blue': '#3478c6', 'cyan': '#2f8f99', 'green': '#2f9d61',
        \ 'yellow': '#b8851c', 'purple': '#995eb8', 'red': '#c45562',
        \ }
else
  let s:p = {
        \ 'bg': '#2c323c', 'fg': '#abb2bf', 'surface': '#343c48',
        \ 'muted': '#828997', 'dim': '#536070', 'selection': '#414d5e',
        \ 'blue': '#61afef', 'cyan': '#56b6c2', 'green': '#63d297',
        \ 'yellow': '#e5c07b', 'purple': '#c678dd', 'red': '#e06c75',
        \ }
endif

function! s:hi(group, foreground, background, style) abort
  execute 'highlight ' . a:group
        \ . ' guifg=' . get(s:p, a:foreground, a:foreground)
        \ . ' guibg=' . get(s:p, a:background, a:background)
        \ . ' gui=' . a:style . ' cterm=' . a:style
endfunction

" Editor surfaces: keep the gutter and inactive windows quiet.
call s:hi('Normal', 'fg', 'bg', 'NONE')
call s:hi('LineNr', 'muted', 'NONE', 'NONE')
call s:hi('CursorLine', 'NONE', 'surface', 'NONE')
call s:hi('CursorLineNr', 'blue', 'NONE', 'bold')
call s:hi('SignColumn', 'muted', 'NONE', 'NONE')
call s:hi('NonText', 'dim', 'NONE', 'NONE')
call s:hi('EndOfBuffer', 'dim', 'NONE', 'NONE')
call s:hi('SpecialKey', 'dim', 'NONE', 'NONE')
call s:hi('VertSplit', 'dim', 'bg', 'NONE')
call s:hi('StatusLine', 'fg', 'surface', 'NONE')
call s:hi('StatusLineNC', 'muted', 'bg', 'NONE')
call s:hi('TabLine', 'muted', 'bg', 'NONE')
call s:hi('TabLineFill', 'muted', 'bg', 'NONE')
call s:hi('TabLineSel', 'blue', 'surface', 'bold')
call s:hi('Visual', 'NONE', 'selection', 'NONE')
call s:hi('Search', 'yellow', 'selection', 'NONE')
call s:hi('CurSearch', 'bg', 'yellow', 'bold')
call s:hi('IncSearch', 'bg', 'yellow', 'NONE')
call s:hi('MatchParen', 'blue', 'selection', 'bold')
call s:hi('Folded', 'muted', 'surface', 'NONE')
call s:hi('FoldColumn', 'dim', 'NONE', 'NONE')
call s:hi('ColorColumn', 'NONE', 'surface', 'NONE')
call s:hi('Pmenu', 'fg', 'surface', 'NONE')
call s:hi('PmenuSel', 'bg', 'blue', 'NONE')
call s:hi('PmenuSbar', 'NONE', 'surface', 'NONE')
call s:hi('PmenuThumb', 'NONE', 'dim', 'NONE')
call s:hi('WildMenu', 'bg', 'blue', 'NONE')

" WhichKey popup follows the same surfaces and accent colors as the editor.
call s:hi('WhichKeyNormal', 'fg', 'surface', 'NONE')
call s:hi('WhichKeyBorder', 'dim', 'surface', 'NONE')
call s:hi('WhichKeyTitle', 'blue', 'surface', 'bold')
call s:hi('WhichKey', 'blue', 'NONE', 'bold')
call s:hi('WhichKeySeparator', 'dim', 'NONE', 'NONE')
call s:hi('WhichKeyDesc', 'fg', 'NONE', 'NONE')
call s:hi('WhichKeyGroup', 'purple', 'NONE', 'bold')
call s:hi('WhichKeyValue', 'muted', 'NONE', 'NONE')
call s:hi('WhichKeyIcon', 'cyan', 'NONE', 'NONE')
call s:hi('WhichKeyIconAzure', 'cyan', 'NONE', 'NONE')
call s:hi('WhichKeyIconBlue', 'blue', 'NONE', 'NONE')
call s:hi('WhichKeyIconCyan', 'cyan', 'NONE', 'NONE')
call s:hi('WhichKeyIconGreen', 'green', 'NONE', 'NONE')
call s:hi('WhichKeyIconGrey', 'muted', 'NONE', 'NONE')
call s:hi('WhichKeyIconOrange', 'yellow', 'NONE', 'NONE')
call s:hi('WhichKeyIconPurple', 'purple', 'NONE', 'NONE')
call s:hi('WhichKeyIconRed', 'red', 'NONE', 'NONE')
call s:hi('WhichKeyIconYellow', 'yellow', 'NONE', 'NONE')
call s:hi('QuickFixLine', 'blue', 'surface', 'NONE')
call s:hi('Title', 'blue', 'NONE', 'bold')
call s:hi('Directory', 'blue', 'NONE', 'NONE')
call s:hi('Question', 'cyan', 'NONE', 'NONE')
call s:hi('MoreMsg', 'green', 'NONE', 'NONE')
call s:hi('ModeMsg', 'muted', 'NONE', 'NONE')
call s:hi('WarningMsg', 'yellow', 'NONE', 'NONE')
call s:hi('ErrorMsg', 'red', 'NONE', 'bold')

" Syntax uses the same accents as the shell prompt and terminal palette.
call s:hi('Comment', 'muted', 'NONE', 'italic')
call s:hi('Constant', 'yellow', 'NONE', 'NONE')
call s:hi('String', 'green', 'NONE', 'NONE')
call s:hi('Identifier', 'fg', 'NONE', 'NONE')
call s:hi('Function', 'blue', 'NONE', 'NONE')
call s:hi('Statement', 'purple', 'NONE', 'NONE')
call s:hi('PreProc', 'purple', 'NONE', 'NONE')
call s:hi('Type', 'cyan', 'NONE', 'NONE')
call s:hi('Special', 'cyan', 'NONE', 'NONE')
call s:hi('Delimiter', 'muted', 'NONE', 'NONE')
call s:hi('Underlined', 'blue', 'NONE', 'underline')
call s:hi('Ignore', 'muted', 'NONE', 'NONE')
call s:hi('Error', 'red', 'NONE', 'underline')
call s:hi('Todo', 'yellow', 'NONE', 'bold')
call s:hi('DiffAdd', 'green', 'surface', 'NONE')
call s:hi('DiffChange', 'blue', 'surface', 'NONE')
call s:hi('DiffDelete', 'red', 'surface', 'NONE')
call s:hi('DiffText', 'yellow', 'selection', 'NONE')
for s:heading in range(1, 6)
  execute 'highlight! link markdownH' . s:heading . ' Title'
endfor
highlight! link markdownHeadingDelimiter Delimiter
highlight! link markdownCode String
highlight! link markdownCodeDelimiter Delimiter
highlight! link markdownUrl Underlined
highlight! link markdownLinkText Underlined

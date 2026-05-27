# Colors
# https://geoff.greer.fm/lscolors/
export CLICOLOR=1
autoload colors; colors;
export LSCOLORS="Exfxcxdxbxegedabagacad"
export LS_COLORS="di=1;94:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# Keep eza's semantic file categories aligned with the terminal ANSI palette.
export EZA_COLORS="sc=93:co=91:do=32:im=95:vi=94:mu=36:lo=96:cr=92:bu=33:cm=90:tm=2"

# Use same colors for autocompletion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

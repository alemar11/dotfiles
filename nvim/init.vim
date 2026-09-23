" Neovim. Linked with: ./dotfiles.sh install nvim
" Bare style match for classic Vim, with lazy.nvim for WhichKey:
" - Ghostty/macOS appearance + Starship colorscheme before the first redraw
" - line numbers; WhichKey is the only plugin

" Neovim detects the terminal background and reloads this colorscheme when
" Ghostty reports a macOS light/dark theme change.

" Reuse Vim's colorscheme from the sibling tree, without a second copy.
execute 'set runtimepath^=' . fnameescape(fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . '/vim')

set termguicolors

" Ghostty updates its window appearance immediately, but existing terminal
" surfaces do not always send a background-color update to Neovim. Follow
" macOS appearance directly so the colorscheme changes in the open session.
if has('macunix')
  lua << EOF
  local function macos_background()
    local style = vim.fn.system('/usr/bin/defaults read -g AppleInterfaceStyle 2>/dev/null')
    return vim.trim(style) == 'Dark' and 'dark' or 'light'
  end

  local function apply_macos_background()
    local background = macos_background()
    if vim.o.background ~= background then
      vim.o.background = background
      local vimrc = vim.fn.resolve(vim.fn.expand('$MYVIMRC'))
      local colorscheme = vim.fn.fnamemodify(vimrc, ':h:h') .. '/vim/colors/dotfiles.vim'
      vim.cmd.source(colorscheme)
    end
  end

  apply_macos_background()

  if vim.fn.has('ttyin') == 1 then
    local timer = (vim.uv or vim.loop).new_timer()
    timer:start(500, 500, vim.schedule_wrap(apply_macos_background))
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        timer:stop()
        timer:close()
      end,
    })
  end
EOF
endif

colorscheme dotfiles

set number norelativenumber

" Bootstrap lazy.nvim and install only WhichKey. Plugin state lives under
" stdpath("data"); the generated lockfile is tracked alongside this config.
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. output)
  end
end
vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        preset = "modern",
        spec = {
          { "<leader>b", group = "Buffer" },
        },
        win = {
          width = 0.9,
          col = 0.5,
          row = -1,
          no_overlap = true,
          border = "rounded",
        },
      },
      keys = {
        { "<leader><leader>", "<C-^>", desc = "Alternate buffer" },
        { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
        { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" },
        { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous buffer" },
        { "<leader>e", "<cmd>Explore<cr>", desc = "File explorer" },
        { "<leader>h", "<cmd>nohlsearch<cr>", desc = "Clear search highlighting" },
        { "<leader>q", "<cmd>quit<cr>", desc = "Quit window" },
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer local keymaps (which-key)",
        },
        { "<leader>w", "<cmd>write<cr>", desc = "Save file" },
      },
    },
  },
  install = { colorscheme = { "dotfiles" } },
})
EOF

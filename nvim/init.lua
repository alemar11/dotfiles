-- ui2 is an internal API; skip it if a Neovim update moves or removes it.
pcall(function() require("vim._core.ui2").enable() end)
require("options")
vim.g.mapleader = " "
require("keymaps")
require("plugins")

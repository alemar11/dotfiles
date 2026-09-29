vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("plugins.mini")
require("plugins.mason")
require("plugins.treesitter")
require("plugins.lsp")

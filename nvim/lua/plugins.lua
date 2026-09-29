vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Set up Mason before enabling any language servers so its binaries are on PATH.
require("mason").setup()

-- Install servers with :Mason, then enable their nvim-lspconfig names here.
-- Example after installing lua-language-server: vim.lsp.enable("lua_ls")

-- Parser installation is available through :TSInstall <language>.
-- After updating this plugin, run :TSUpdate to update installed parsers.
require("nvim-treesitter").setup()

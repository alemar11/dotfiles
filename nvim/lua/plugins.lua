vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Set up Mason before enabling any language servers so its binaries are on PATH.
require("mason").setup()

-- Parser installation is available through :TSInstall <language>.
-- After updating this plugin, run :TSUpdate to update installed parsers.
require("nvim-treesitter").setup()

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
    },
  },
})

-- Install with :MasonInstall lua-language-server typescript-language-server pyright
vim.lsp.enable({ "lua_ls", "ts_ls", "pyright" })

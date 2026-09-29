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

-- SourceKit-LSP ships with Xcode; xcrun follows the selected developer toolchain.
vim.lsp.config("sourcekit", {
  cmd = { "xcrun", "sourcekit-lsp" },
  filetypes = { "swift" },
})

-- Install with :MasonInstall lua-language-server typescript-language-server pyright
vim.lsp.enable({ "lua_ls", "ts_ls", "pyright", "sourcekit" })

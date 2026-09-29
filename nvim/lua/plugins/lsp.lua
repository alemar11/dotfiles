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

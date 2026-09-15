return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- Per-client interpreter selection avoids leaking one project's venv into another.
          before_init = function(_, config)
            if not config.root_dir then
              return
            end
            for _, name in ipairs({ ".venv", "venv" }) do
              local python = config.root_dir .. "/" .. name .. "/bin/python"
              if vim.fn.executable(python) == 1 then
                config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                  python = { pythonPath = python },
                })
                break
              end
            end
          end,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
      },
    },
  },
}

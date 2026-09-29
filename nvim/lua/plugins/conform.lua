local conform = require("conform")

-- Install external formatters with :MasonInstall stylua prettier ruff.
-- swift-format is available through the selected Xcode toolchain.
conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    markdown = { "prettier" },
    python = { "ruff_format" },
    swift = { "swift_format" },
  },
  formatters = {
    swift_format = { command = "xcrun", prepend_args = { "swift-format" } },
  },
})

vim.keymap.set({ "n", "x" }, "<leader>f", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file or selection" })

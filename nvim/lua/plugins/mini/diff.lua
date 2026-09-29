-- Compare against the Git index; use gh to stage a hunk and gH to reset it.
local diff = require("mini.diff")
diff.setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniDiffUpdated",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.b[bufnr].minidiff_overlay_initialized then
      return
    end

    vim.b[bufnr].minidiff_overlay_initialized = true
    diff.toggle_overlay(bufnr)
  end,
})

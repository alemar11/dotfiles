-- Included with Neovim 0.12; no external package is needed.
vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
  require("undotree").open()
end, { desc = "Toggle undo tree" })

local files = require("mini.files")
files.setup({
  mappings = {
    go_in = "<CR>",
    go_in_plus = "L",
    go_out = "<Esc>",
    go_out_plus = "H",
  },
})

vim.keymap.set("n", "-", function()
  files.open(nil, false)
end, { desc = "Open file explorer" })

vim.keymap.set("n", "<leader>-", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or not vim.uv.fs_stat(path) then
    path = nil
  end
  files.open(path, false)
  files.reveal_cwd()
end, { desc = "Reveal current file" })

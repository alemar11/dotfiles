require("mini.icons").setup()

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

local pick = require("mini.pick")
pick.setup()
vim.keymap.set("n", "<leader>pf", pick.builtin.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>ps", function()
  pick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>pg", pick.builtin.grep_live, { desc = "Search project text" })
vim.keymap.set("n", "<leader>vh", pick.builtin.help, { desc = "Search help" })

local extra = require("mini.extra")
extra.setup()
vim.keymap.set("n", "<leader>xx", extra.pickers.diagnostic, { desc = "Search diagnostics" })
vim.keymap.set("n", "<leader>pk", extra.pickers.keymaps, { desc = "Search keymaps" })

-- Move selected lines, reindent them, and keep the selection active.
vim.keymap.set("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Center the cursor after scrolling or jumping between search matches.
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "n", "nzz", { desc = "Next search match and center cursor" })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search match and center cursor" })

-- Show line numbers.
vim.opt.number = true

-- Keep context visible above and below the cursor.
vim.opt.scrolloff = 8

-- Ignore case in searches unless you type an uppercase letter.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Open new splits below and to the right.
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Preserve undo history after closing and reopening files.
vim.opt.undofile = true

-- Preview substitutions in a separate window.
vim.opt.inccommand = "split"

-- Show distances from the current line; useful for motions like 5j.
vim.opt.relativenumber = true

-- Reserve space for diagnostic and Git signs, preventing sideways shifts.
vim.opt.signcolumn = "yes"

-- Use the system clipboard for ordinary yank, delete, and paste operations.
vim.opt.clipboard = "unnamedplus"

-- Show one status line shared by all windows.
vim.opt.laststatus = 3

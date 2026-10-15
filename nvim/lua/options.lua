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

-- Copy yanks (not deletes or changes) to the macOS clipboard.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("DotfilesYankClipboard", { clear = true }),
  callback = function()
    local event = vim.v.event
    if event.operator == "y" and event.regname == "" then
      vim.fn.setreg("+", event.regcontents, event.regtype)
    end
  end,
})

-- Show one status line shared by all windows.
vim.opt.laststatus = 3

-- Show diagnostic messages at the end of the line, not only as gutter signs.
vim.diagnostic.config({ virtual_text = true })

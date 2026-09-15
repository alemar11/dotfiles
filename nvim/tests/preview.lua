-- Run from the repository root: nvim --headless -u NONE -i NONE -l nvim/tests/preview.lua
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/nvim")
local preview = require("vscode_preview")
preview.setup()
preview.clear_empty_buffers()
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  assert(not vim.bo[buf].buflisted, "startup cleanup must not recreate a listed empty buffer")
end
local dir = vim.fn.tempname()
vim.fn.mkdir(dir, "p")
local function file(name)
  local path = dir .. "/" .. name
  vim.fn.writefile({ "first", "second" }, path)
  return path
end
local a, b, c, d = file("a.ts"), file("b.ts"), file("c.ts"), file("d.ts")
local function check(condition, message)
  assert(condition, message)
end

local tree = vim.api.nvim_get_current_win()
vim.bo.buftype = "nofile"
vim.bo.filetype = "neo-tree"
vim.cmd("vsplit")
local editor = vim.api.nvim_get_current_win()
vim.api.nvim_win_set_buf(editor, vim.api.nvim_create_buf(true, false))
vim.api.nvim_set_current_win(tree)

preview.open(a, false, false)
local a_buf = vim.fn.bufnr(a)
check(vim.api.nvim_get_current_win() == tree, "preview must keep tree focus")
check(vim.api.nvim_win_get_buf(editor) == a_buf, "preview must use editor window")
preview.open(b, false, false)
check(not vim.api.nvim_buf_is_valid(a_buf), "new preview should dispose the old unmodified preview")
preview.open(b, true, true)
local b_buf = vim.fn.bufnr(b)
check(vim.api.nvim_get_current_win() == editor, "Enter must focus the editor")
vim.api.nvim_set_current_win(tree)
preview.open(c, false, false)
check(vim.api.nvim_buf_is_valid(b_buf), "pinned buffer must survive replacement")

local c_buf = vim.fn.bufnr(c)
vim.api.nvim_buf_set_lines(c_buf, 0, 1, false, { "edited" })
preview.open(a, false, false)
check(vim.api.nvim_buf_is_valid(c_buf) and vim.bo[c_buf].modified, "modified buffer must survive")
check(vim.api.nvim_buf_get_lines(c_buf, 0, 1, false)[1] == "edited", "modified contents must survive")

local d_buf = vim.fn.bufadd(d)
vim.fn.bufload(d_buf)
vim.bo[d_buf].buflisted = true
preview.open(d, false, false)
preview.open(a, false, false)
check(vim.api.nvim_buf_is_valid(d_buf) and not vim.b[d_buf].dotfiles_preview, "already-open files must be retained")

vim.api.nvim_set_current_win(editor)
vim.api.nvim_exec_autocmds("InsertEnter", { buffer = vim.api.nvim_get_current_buf() })
check(not vim.b[vim.fn.bufnr(a)].dotfiles_preview, "entering Insert mode must pin the preview")
vim.api.nvim_set_current_win(tree)
preview.open(b, false, false)
check(vim.api.nvim_buf_is_valid(vim.fn.bufnr(a)), "edit-pinned file must remain open")

-- A floating normal buffer and a terminal-like window must not become the editor.
local float = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
  relative = "editor",
  row = 1,
  col = 1,
  width = 10,
  height = 3,
})
vim.t.dotfiles_editor_win = float
check(preview.editor_win(tree) == editor, "floating windows must be excluded")
vim.api.nvim_win_close(float, true)

-- Previewing a file already displayed in another split retains that buffer.
preview.open(c, false, false)
vim.api.nvim_set_current_win(editor)
vim.cmd("vsplit")
local second = vim.api.nvim_get_current_win()
vim.api.nvim_win_set_buf(second, vim.api.nvim_create_buf(true, false))
vim.t.dotfiles_editor_win = second
vim.api.nvim_set_current_win(tree)
preview.open(c, false, false)
check(not vim.b[c_buf].dotfiles_preview, "a buffer shared by splits must be retained")

vim.fn.delete(dir, "rf")
print("Preview tests passed: replacement, pinning, edits, existing buffers, focus, floating windows, splits")
vim.cmd("qa!")

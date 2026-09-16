local group = vim.api.nvim_create_augroup("DotfilesViewer", { clear = true })
local preview = require("vscode_preview")
preview.setup()

-- These config files may load after UIEnter. VeryLazy runs on both empty and file starts.
local opened = false
local function open_explorer()
  if opened then
    return
  end
  local arg = vim.fn.argv(0)
  if arg ~= "" and vim.fn.isdirectory(arg) == 0 then
    return
  end
  if #vim.api.nvim_list_uis() == 0 then
    return
  end
  opened = true
  vim.schedule(function()
    require("neo-tree.command").execute({ action = "focus", dir = arg ~= "" and arg or vim.uv.cwd() })
  end)
end
vim.api.nvim_create_autocmd("UIEnter", { group = group, callback = open_explorer })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  once = true,
  callback = open_explorer,
})
-- With no argv LazyVim loads this module from inside VeryLazy's callback.
if vim.v.vim_did_enter == 1 then
  open_explorer()
end

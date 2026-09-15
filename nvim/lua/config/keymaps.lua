vim.keymap.set("n", "<C-p>", function()
  LazyVim.pick("files")()
end, { desc = "Find Files" })

local function search_project()
  LazyVim.pick("live_grep")()
end
vim.keymap.set("n", "<C-S-f>", search_project, { desc = "Search Project" })
vim.keymap.set({ "n", "x" }, "/", search_project, { desc = "Search Project" })
vim.keymap.set("n", "g/", "/", { remap = false, desc = "Search in File" })

-- Preserve LazyVim's root terminal action and Snacks' terminal-local hide action.
vim.keymap.set({ "n", "t" }, "<C-7>", "<C-/>", { remap = true, desc = "Toggle Terminal" })

-- Space e uses LazyVim's standard explorer toggle. Ghostty retains its Cmd keys.
local function definition_at_mouse()
  local mouse = vim.fn.getmousepos()
  if mouse.winid == 0 or mouse.line == 0 or mouse.column == 0 then
    return
  end
  local buf = vim.api.nvim_win_get_buf(mouse.winid)
  if vim.bo[buf].buftype ~= "" then
    return
  end
  vim.api.nvim_set_current_win(mouse.winid)
  vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, mouse.column - 1 })
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if client:supports_method("textDocument/definition", buf) then
      vim.lsp.buf.definition()
      return
    end
  end
end
vim.keymap.set("n", "<C-LeftMouse>", definition_at_mouse, { desc = "Goto Definition" })
vim.keymap.set("n", "<D-LeftMouse>", definition_at_mouse, { desc = "Goto Definition" })
vim.keymap.set("n", "<C-RightMouse>", "<C-o>", { desc = "Go Back" })

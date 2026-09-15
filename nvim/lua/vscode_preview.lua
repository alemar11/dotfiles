-- One disposable preview per editor window. Listed files opened by other commands
-- are retained; a preview is only deleted when unmodified and no longer displayed.
local M = {}
local marker = "dotfiles_preview"

local function is_editor(win)
  if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.bo[buf].buftype == "" and vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf)) == 0
    or vim.b[buf].dotfiles_empty == true
end

function M.editor_win(tree_win)
  local tab = vim.api.nvim_get_current_tabpage()
  local last = vim.t[tab].dotfiles_editor_win
  if last and last ~= tree_win and is_editor(last) and vim.api.nvim_win_get_tabpage(last) == tab then
    return last
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if win ~= tree_win and is_editor(win) then
      return win
    end
  end
end

function M.pin_buf(buf)
  vim.b[buf][marker] = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.w[win][marker] == buf then
      vim.w[win][marker] = nil
    end
  end
end

local function scratch()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.b[buf].dotfiles_empty = true
  vim.bo[buf].bufhidden = "wipe"
  return buf
end

function M.clear_empty_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and not vim.bo[buf].modified and vim.bo[buf].buftype == "" then
      local name = vim.api.nvim_buf_get_name(buf)
      local empty = name == ""
        and vim.api.nvim_buf_line_count(buf) == 1
        and (vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") == ""
      if empty or vim.fn.isdirectory(name) == 1 then
        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
          vim.api.nvim_win_set_buf(win, scratch())
        end
        -- Deleting the last listed buffer makes Neovim create a new [No Name]
        -- buffer. Hide the startup buffer instead, leaving no tab to recreate.
        vim.bo[buf].buflisted = false
      end
    end
  end
end

function M.open(path, pin, focus)
  if vim.fn.filereadable(path) == 0 then
    vim.notify("File is no longer available: " .. path, vim.log.levels.WARN)
    return
  end
  local tree_win = vim.api.nvim_get_current_win()
  local win = M.editor_win(tree_win)
  if not win then
    vim.cmd("botright vsplit")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, scratch())
    vim.api.nvim_set_current_win(tree_win)
  end

  local buf = vim.fn.bufadd(path)
  local retained = vim.bo[buf].buflisted and not vim.b[buf][marker]
  for _, other_win in ipairs(vim.fn.win_findbuf(buf)) do
    retained = retained or other_win ~= win
  end
  vim.fn.bufload(buf)
  local old = vim.w[win][marker]
  vim.bo[buf].buflisted = true
  if pin or retained or vim.bo[buf].modified then
    M.pin_buf(buf)
    vim.w[win][marker] = nil
  else
    vim.b[buf][marker] = true
    vim.w[win][marker] = buf
  end
  vim.api.nvim_win_set_buf(win, buf)
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].breakindent = true
  if old and old ~= buf and vim.api.nvim_buf_is_valid(old) and vim.b[old][marker] then
    if not vim.bo[old].modified and #vim.fn.win_findbuf(old) == 0 then
      pcall(vim.api.nvim_buf_delete, old, { force = false })
    else
      M.pin_buf(old)
    end
  end
  M.clear_empty_buffers()
  vim.api.nvim_set_current_win(focus and win or tree_win)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("DotfilesPreview", { clear = true })
  vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
    group = group,
    callback = function(event)
      if vim.b[event.buf][marker] then
        M.pin_buf(event.buf)
      end
    end,
  })
  vim.api.nvim_create_autocmd("WinEnter", {
    group = group,
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if is_editor(win) then
        vim.t.dotfiles_editor_win = win
      end
    end,
  })
end

return M

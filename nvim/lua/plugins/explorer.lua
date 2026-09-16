local preview = require("vscode_preview")
local cleaned_startup = false

local function open_node(state, pin, focus)
  local node = state.tree:get_node()
  if not node or node:get_depth() == 1 then
    return
  end
  if node.type == "directory" then
    require("neo-tree.sources.filesystem.commands").toggle_node(state)
  elseif node.type == "file" then
    preview.open(node.path, pin, focus)
  end
end

local sequence = 0
local function move_and_preview(state, key)
  vim.cmd.normal({ key, bang = true })
  sequence = sequence + 1
  local current = sequence
  local tree_win = vim.api.nvim_get_current_win()
  vim.defer_fn(function()
    if current ~= sequence or vim.api.nvim_get_current_win() ~= tree_win then
      return
    end
    local node = state.tree:get_node()
    if node and node.type == "file" then
      preview.open(node.path, false, false)
    end
  end, 40)
end

return {
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      event_handlers = {
        {
          event = "after_render",
          handler = function()
            if cleaned_startup then
              return
            end
            cleaned_startup = true
            local arg = vim.fn.argv(0)
            if arg == "" or vim.fn.isdirectory(arg) == 1 then
              vim.schedule(preview.clear_empty_buffers)
            end
          end,
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".git", ".DS_Store" },
        },
      },
      window = {
        width = 34,
        mappings = {
          ["<LeftRelease>"] = function(state)
            open_node(state, false, false)
          end,
          ["<2-LeftMouse>"] = function(state)
            open_node(state, true, false)
          end,
          ["<cr>"] = function(state)
            open_node(state, true, true)
          end,
          ["l"] = function(state)
            open_node(state, true, true)
          end,
          ["j"] = function(state)
            move_and_preview(state, "j")
          end,
          ["k"] = function(state)
            move_and_preview(state, "k")
          end,
          ["/"] = "none",
        },
      },
    },
  },
}

-- Compare against the Git index; use gh to stage a hunk and gH to reset it.
local diff = require("mini.diff")
diff.setup()

vim.api.nvim_create_user_command("Gd", function()
  diff.toggle_overlay()
end, { desc = "Toggle inline Git diff" })

local statusline = require("mini.statusline")

statusline.setup({
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local diff = vim.trim(statusline.section_diff({ trunc_width = 75, icon = "" }))
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75, icon = "" })
      local lsp = statusline.section_lsp({ trunc_width = 75, icon = "" })
      local filename = statusline.section_filename({ trunc_width = 140 })
      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local location = statusline.section_location({ trunc_width = 75 })
      local search = statusline.section_searchcount({ trunc_width = 75 })
      local summary = vim.b.minigit_summary
      local branch = summary and summary.head_name or ""
      local git = branch ~= "" and (" " .. branch) or ""

      return statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineDevinfo", strings = { lsp, git, diff } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      })
    end,
  },
})

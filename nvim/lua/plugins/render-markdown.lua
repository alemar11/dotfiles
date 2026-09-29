local heading_groups = {}
local heading_colors = { "Title", "Statement", "@type.builtin", "Number", "Type", "Function" }

local function heading_highlight()
  for level, source in ipairs(heading_colors) do
    local name = "DotfilesMarkdownH" .. level
    local color = vim.api.nvim_get_hl(0, { name = source, link = false })
    vim.api.nvim_set_hl(0, name, { fg = color.fg, bold = true })
    heading_groups[level] = name
  end
end

heading_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("DotfilesMarkdown", { clear = true }),
  callback = heading_highlight,
})

require("render-markdown").setup({
  heading = {
    icons = { "" },
    position = "inline",
    sign = false,
    backgrounds = heading_groups,
    foregrounds = heading_groups,
  },
})

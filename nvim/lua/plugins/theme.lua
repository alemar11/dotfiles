-- Starship's palettes.main is authoritative. Light values match the existing
-- higher-contrast derivation in ghostty/themes/dotfiles-light.
local palettes = {
  dark = {
    bg0 = "#2c323c",
    bg_d = "#252b34",
    bg1 = "#353d49",
    bg2 = "#404958",
    bg3 = "#4b5565",
    fg = "#dbe2ea",
    grey = "#828997",
    red = "#e06c75",
    green = "#63d297",
    yellow = "#e5c07b",
    blue = "#61afef",
    purple = "#c678dd",
    cyan = "#56b6c2",
    orange = "#be5046",
  },
  light = {
    bg0 = "#fafaff",
    bg_d = "#f0f0f7",
    bg1 = "#eeeef6",
    bg2 = "#e0e1ed",
    bg3 = "#d1d4e3",
    fg = "#2c323c",
    grey = "#56606d",
    red = "#c45562",
    green = "#2f9d61",
    yellow = "#b8851c",
    blue = "#3478c6",
    purple = "#995eb8",
    cyan = "#2f8f99",
    orange = "#be5046",
  },
}

local active_style
local function apply()
  local style = vim.o.background == "light" and "light" or "dark"
  if active_style == style then
    return
  end
  active_style = style
  require("onedark").setup({
    style = style,
    term_colors = false,
    ending_tildes = false,
    colors = palettes[style],
    highlights = {
      Normal = { fg = "$fg", bg = "$bg0" },
      NormalNC = { fg = "$fg", bg = "$bg0" },
      NeoTreeNormal = { fg = "$fg", bg = "$bg0" },
      NeoTreeNormalNC = { fg = "$fg", bg = "$bg0" },
      NeoTreeDirectoryIcon = { fg = "$blue" },
      NeoTreeDirectoryName = { fg = "$blue" },
      NeoTreeWinSeparator = { fg = "$bg1", bg = "$bg0" },
      WinSeparator = { fg = "$bg1", bg = "$bg0" },
    },
  })
  require("onedark").load()
end

return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      apply()
      vim.api.nvim_create_autocmd("OptionSet", {
        group = vim.api.nvim_create_augroup("DotfilesTheme", { clear = true }),
        pattern = "background",
        callback = apply,
      })
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "onedark" } },
}

require("colorizer").setup({
  filetypes = { "*" },
  options = {
    parsers = {
      hex = { rgb = true, rgba = true, rrggbb = true, rrggbbaa = true },
      css_fn = true,
    },
    display = { mode = "background" },
  },
})

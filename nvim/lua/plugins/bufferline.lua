return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        name_formatter = function(buf)
          return vim.b[buf.bufnr].dotfiles_preview and (buf.name .. " (preview)") or buf.name
        end,
      },
    },
  },
}

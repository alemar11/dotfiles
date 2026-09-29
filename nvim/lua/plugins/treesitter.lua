local treesitter = require("nvim-treesitter")
treesitter.setup()

local parsers = {
  "lua",
  "javascript",
  "typescript",
  "tsx",
  "python",
  "swift",
  "json",
  "yaml",
  "html",
  "css",
  "bash",
  "markdown",
  "markdown_inline",
}

local function highlight(buf)
  if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= "" then
    return
  end
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if lang then
    -- Keep regular syntax highlighting when a parser is unavailable.
    pcall(vim.treesitter.start, buf, lang)
  end
end

local function refresh_highlighting(err)
  if err then
    vim.notify("Treesitter: " .. tostring(err), vim.log.levels.ERROR)
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    highlight(buf)
  end
end

local group = vim.api.nvim_create_augroup("DotfilesTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    highlight(args.buf)
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = group,
  callback = function(args)
    if args.data.spec.name == "nvim-treesitter" and args.data.kind == "update" then
      treesitter.update():await(vim.schedule_wrap(refresh_highlighting))
    end
  end,
})

-- Installation is asynchronous; also highlight buffers opened before it finishes.
treesitter.install(parsers):await(vim.schedule_wrap(refresh_highlighting))

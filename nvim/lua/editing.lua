require("mini.notify").setup({
  content = {
    format = function(notification)
      return notification.msg
    end,
  },
})

require("mini.cmdline").setup({ autocorrect = { enable = false } })
require("mini.surround").setup()

local completion = require("mini.completion")
completion.setup({ lsp_completion = { auto_setup = true } })
vim.lsp.config("*", { capabilities = completion.get_lsp_capabilities() })

local snippets = require("mini.snippets")
snippets.setup({
  snippets = { snippets.gen_loader.from_lang() },
})
snippets.start_lsp_server({ match = false })

-- Compare against the Git index; use gh to stage a hunk and gH to reset it.
require("mini.diff").setup()

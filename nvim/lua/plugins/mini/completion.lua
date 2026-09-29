local completion = require("mini.completion")
completion.setup({ lsp_completion = { auto_setup = true } })
vim.lsp.config("*", { capabilities = completion.get_lsp_capabilities() })

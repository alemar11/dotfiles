local clue = require("mini.clue")

clue.setup({
  triggers = {
    { mode = { "n", "x" }, keys = "<Leader>" },
    { mode = { "n", "x" }, keys = "g" },
    { mode = { "n", "x" }, keys = "z" },
    { mode = "n", keys = "<C-w>" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
  },
  clues = {
    clue.gen_clues.g(),
    clue.gen_clues.z(),
    clue.gen_clues.windows(),
    clue.gen_clues.square_brackets(),
    { mode = "n", keys = "<Leader>p", desc = "+Find" },
    { mode = "n", keys = "<Leader>v", desc = "+Help" },
    { mode = "n", keys = "<Leader>x", desc = "+Diagnostics" },
  },
  window = { delay = 300 },
})

require("mini.notify").setup({
  content = {
    format = function(notification)
      return notification.msg
    end,
  },
})

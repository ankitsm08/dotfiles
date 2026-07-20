return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 1500,
      stages = "static",
      render = "compact",
      max_width = 60,
      background_colour = "#1e1e2e",
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
}

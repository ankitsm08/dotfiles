return {
  {
    "monaqa/dial.nvim",
    keys = {
      { "_", mode = { "n", "v" }, desc = "Decrement" },
      { "+", mode = { "n", "v" }, desc = "Increment" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })

      vim.keymap.set("n", "+", function()
        require("dial.map").manipulate("increment", "normal")
      end)
      vim.keymap.set("n", "_", function()
        require("dial.map").manipulate("decrement", "normal")
      end)
      vim.keymap.set("v", "+", function()
        require("dial.map").manipulate("increment", "visual")
      end)
      vim.keymap.set("v", "_", function()
        require("dial.map").manipulate("decrement", "visual")
      end)
    end,
  },
}

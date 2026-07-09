return {
  {
    "uga-rosa/ccc.nvim",
    config = function()
      -- Enable true color
      vim.opt.termguicolors = true

      local ccc = require("ccc")
      local mapping = ccc.mapping

      ccc.setup({
        default_color = "#aaaaff",
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
    keys = {
      {
        "<leader>cc",
        function()
          vim.cmd("CccPick")
        end,
        desc = "Pick Color",
      },
    },
  },
}

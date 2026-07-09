return {
  {
    "al1-ce/just.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- async jobs
      "j-hui/fidget.nvim", -- task progress (optional)
    },
    config = true,
    keys = {
      {
        "<leader>J",
        mode = { "n" },
        function()
          require("just").run_task_select()
        end,
        desc = "Just Menu",
      },
    },
  },
}

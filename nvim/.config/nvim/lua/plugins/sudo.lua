return {
  {
    "denialofsandwich/sudo.nvim",
    cmd = { "SudoRead", "SudoWrite", "SudoEdit" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- optional configuration
      -- commands = true,
    },
    config = function(_, opts)
      require("sudo").setup(opts)

      vim.api.nvim_create_user_command("W", function()
        vim.cmd("SudoWrite")
      end, {})
    end,
  },
}

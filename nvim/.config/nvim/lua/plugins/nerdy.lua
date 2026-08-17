return {
  {
    "2kabhishek/nerdy.nvim",
    cmd = "Nerdy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      max_recents = 30,
      copy_to_clipboard = true, -- Copy glyph to clipboard instead of inserting
      copy_register = "+", -- Register to use for copying (if `copy_to_clipboard` is true)
    },
    keys = {
      {
        "<leader>in",
        function()
          require("telescope").extensions.nerdy.nerdy()
        end,
        desc = "Browse nerd icons",
      },
      {
        "<leader>iN",
        function()
          require("telescope").extensions.nerdy.nerdy_recents()
        end,
        desc = "Browse recent nerd icons",
      },
    },
  },
}

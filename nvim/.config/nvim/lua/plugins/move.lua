return {
  -- Move word
  {
    "fedepujol/move.nvim",
    keys = {
      -- Normal Mode
      -- { "<A-j>", ":MoveLine(1)<CR>", desc = "Move Line Up" },
      -- { "<A-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down" },
      -- { "<A-h>", ":MoveHChar(-1)<CR>", desc = "Move Character Left" },
      -- { "<A-l>", ":MoveHChar(1)<CR>", desc = "Move Character Right" },
      { "<leader>wf", ":MoveWord(-1)<CR>", mode = { "n" }, desc = "Move Word Left" },
      { "<leader>wb", ":MoveWord(1)<CR>", mode = { "n" }, desc = "Move Word Right" },
      -- Visual Mode
      -- { "<A-j>", ":MoveBlock(1)<CR>", mode = { "v" }, desc = "Move Block Up" },
      -- { "<A-k>", ":MoveBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Down" },
      -- { "<A-h>", ":MoveHBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Left" },
      -- { "<A-l>", ":MoveHBlock(1)<CR>", mode = { "v" }, desc = "Move Block Right" },
    },
    opts = {
      -- Config here
      line = {
        enable = true, -- Enables line movement
        indent = true, -- Toggles indentation
      },
      block = {
        enable = true, -- Enables block movement
        indent = true, -- Toggles indentation
      },
      word = {
        enable = true, -- Enables word movement
      },
      char = {
        enable = false, -- Enables char movement
      },
    },
  },
  {
    "nvim-mini/mini.move",
    version = "*",
    keys = {
      { "<M-h>", mode = { "n", "v" }, desc = "Move left" },
      { "<M-l>", mode = { "n", "v" }, desc = "Move right" },
      { "<M-j>", mode = { "n", "v" }, desc = "Move down" },
      { "<M-k>", mode = { "n", "v" }, desc = "Move up" },
    },
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one
      mappings = {
        -- Move visual selection in Visual mode
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",

        -- Move current line in Normal mode
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    },
  },
}

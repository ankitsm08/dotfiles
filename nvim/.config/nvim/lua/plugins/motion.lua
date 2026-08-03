return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        -- f/F/t/T are owned by flash (multi-line, dimmed). `;`/`,` stay with
        -- textobjects' hybrid dispatcher (see lua/plugins/textobjects.lua).
        char = {
          keys = { "f", "F", "t", "T" },
        },
      },
    },
    keys = {
      {
        "sj",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "st",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "TheBlob42/houdini.nvim",
    event = "InsertEnter",
    config = function()
      require("houdini").setup({
        mappings = { "jk", "kj" },
        timeout = 120,
      })
    end,
  },
}

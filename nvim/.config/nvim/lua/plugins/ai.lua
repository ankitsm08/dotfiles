return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    config = function()
      ---@type opencode.Opts
      vim.o.autoread = true
      vim.g.opencode_opts = {
        -- custom config
      }
    end,

    keys = {
      {
        "<leader>ai",
        mode = { "n", "x" },
        function()
          require("opencode").ask("@this: ")
        end,
        desc = "Ask AI",
      },
      {
        "<leader>aI",
        mode = { "n", "x" },
        function()
          require("opencode").select()
        end,
        desc = "Select AI",
      },
      {
        "<leader>go",
        mode = { "n", "x" },
        function()
          return require("opencode").operator("@this ")
        end,
        desc = "Append range to OpenCode",
        expr = true,
      },
      {
        "<leader>goo",
        mode = "n",
        function()
          return require("opencode").operator("@this ") .. "_"
        end,
        desc = "Append line to OpenCode",
        expr = true,
      },
    },
  },
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "gemma4:31b-cloud",
      display_mode = "float",
      show_prompt = true,
      show_model = true,
      no_auto_close = false,
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
    },
    config = function(_, opts)
      local gen = require("gen")
      gen.setup(opts)
    end,
    keys = {
      -- Keymap for visual selection menu
      { "<leader>ag", ":Gen<CR>", mode = { "v", "n" }, desc = "AI [G]en Menu" },
    },
  },
}

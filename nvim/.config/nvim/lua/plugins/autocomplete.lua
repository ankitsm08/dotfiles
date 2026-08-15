return {
  -- Autocompletion
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        config = function()
          local ls = require("luasnip")
          -- Expands snippet triggers as you type (e.g. `ff` -> `\frac{}{}`)
          ls.config.setup({ enable_autosnippets = true })
          -- Expose the `tex` + `latex` snippet sets inside markdown and tex
          -- buffers (friendly-snippets ships its LaTeX set under `latex`)
          ls.filetype_extend("markdown", { "tex", "latex" })
          ls.filetype_extend("tex", { "latex" })
          -- Obsidian-style math autosnippets, gated on treesitter math detection
          require("snippets.latex").setup()
        end,
      },
      "folke/lazydev.nvim",
      -- Must load before blink so ecolog's blink_cmp integration
      -- has populated its providers before blink instantiates them
      "ph1losof/ecolog.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- Read `:help ins-completion`
        -- default preset: <c-y> to accept ([y]es) the completion
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = "default",
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        menu = {
          auto_show_delay_ms = 25,
          border = "rounded",
          min_width = 16,
          max_height = 8,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
          update_delay_ms = 300,
          window = {
            border = "rounded",
          },
        },
      },

      sources = {
        default = { "lsp", "buffer", "path", "snippets", "lazydev", "ecolog" },
        providers = {
          lazydev = { name = "lazydev", module = "lazydev.integrations.blink", score_offset = 100 },
          ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
          -- Keep lightbag providers capped and keyword-gated so typing stays crisp
          buffer = { max_items = 20, min_keyword_length = 2 },
          path = { max_items = 10 },
          snippets = { max_items = 30 },
          lsp = { max_items = 50 },
        },
      },

      snippets = { preset = "luasnip" },

      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },

      -- Shows a signature help window while you type arguments for a function
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
    },
  },
}

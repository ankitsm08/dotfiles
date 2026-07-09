return {
  { "NMAC427/guess-indent.nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = false },
      ensure_installed = {
        -- Languages
        "c",
        "cpp",
        "rust",
        "zig",
        "python",
        "java",

        -- Scripting
        "lua",
        "bash",
        "zsh",
        "powershell",

        -- Build Tools
        "just",
        "make",
        "cmake",

        -- Web
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "jsx",
        "tsx",

        -- Data
        "json",
        "yaml",
        "toml",
        "ini",
        "csv",
        "xml",

        -- Docs
        "markdown",
        "markdown_inline",
        "vimdoc",

        -- VCS
        "gitcommit",
        "gitignore",
        "git_config",

        -- Containers
        "dockerfile",

        -- Editor
        "vim",
        "diff",
        "regex",
        "printf",

        -- OS / Config
        "desktop",
        "ssh_config",
        "hyprlang",
        "editorconfig",
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup(opts)

      local parsers = TS.get_installed()

      vim.filetype.add({
        pattern = {
          [".*/hypr/.*%.conf"] = "hyprlang",
          [".*/kitty/.*%.conf"] = "kitty",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })

      -- vim.defer_fn(function()
      --   require("nvim-treesitter").install(parsers)
      -- end, 0)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    deps = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            ["aa"] = {
              query = "@parameter.outer",
              desc = "Select outer part of a parameter/argument",
            },
            ["ia"] = {
              query = "@parameter.inner",
              desc = "Select inner part of a parameter/argument",
            },

            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

            ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
            ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

            ["am"] = {
              query = "@function.outer",
              desc = "Select outer part of a method/function definition",
            },
            ["im"] = {
              query = "@function.inner",
              desc = "Select inner part of a method/function definition",
            },

            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
            ["<leader>n:"] = "@property.outer", -- swap object property with next
            ["<leader>nm"] = "@function.outer", -- swap function with next
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
            ["<leader>p:"] = "@property.outer", -- swap object property with prev
            ["<leader>pm"] = "@function.outer", -- swap function with previous
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = { query = "@call.outer", desc = "Next function call start" },
            ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]F"] = { query = "@call.outer", desc = "Next function call end" },
            ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
            ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
            ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
            ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
            ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
            ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
            ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
          },
        },
      },
      config = function(_, opts)
        require("nvim-treesitter-textobjects").setup(opts)

        -- Repeatable Treesitter motions
        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

        -- Make f/F/t/T also repeatable
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
      end,
    },
  },
  {
    "kiyoon/repeatable-move.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  },
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({
        mappings = {
          -- Main textobject prefixes
          around = "a",
          inside = "i",

          -- Next/last variants
          -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
          -- Map LSP selection manually to use it (see `:h MiniAi.config`)
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = "g[",
          goto_right = "g]",
        },
        custom_surroundings = {
          ["B"] = { output = { left = "[", right = "]" } },
          ["c"] = { output = { left = "{", right = "}" } },
          ["Q"] = { output = { left = "'", right = "'" } },
          ["D"] = { output = { left = '"""\n', right = '\n"""' } },
          ["i"] = { output = { left = "_", right = "_" } },
          ["l"] = { output = { left = "<u>", right = "</u>" } },
          ["d"] = { output = { left = "**", right = "**" } },
          ["C"] = { output = { left = "```\n", right = "\n```" } },
          ["m"] = { output = { left = "$", right = "$" } },
          ["M"] = { output = { left = "$$", right = "$$" } },
        },
        n_lines = 200,
      })

      require("mini.surround").setup({
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        mappings = {
          add = "sa", -- Add surrounding in Normal and Visual modes
          delete = "sd", -- Delete surrounding
          find = "sf", -- Find surrounding (to the right)
          find_left = "sF", -- Find surrounding (to the left)
          highlight = "sh", -- Highlight surrounding
          replace = "sr", -- Replace surrounding

          suffix_last = "l", -- Suffix to search with "prev" method
          suffix_next = "n", -- Suffix to search with "next" method
        },
        custom_surroundings = {
          ["s"] = { output = { left = "[", right = "]" } },
          ["B"] = { output = { left = "[", right = "]" } },
          ["c"] = { output = { left = "{", right = "}" } },
          ["Q"] = { output = { left = "'", right = "'" } },
          ["a"] = { output = { left = "'", right = "'" } },
          ["i"] = { output = { left = "_", right = "_" } },
          ["u"] = { output = { left = "_", right = "_" } },
          ["p"] = { output = { left = "%", right = "%" } },
          ["l"] = { output = { left = "<u>", right = "</u>" } },
          ["d"] = { output = { left = "**", right = "**" } },
          ["D"] = { output = { left = '"""\n', right = '\n"""' } },
          ["k"] = { output = { left = "`", right = "`" } },
          ["K"] = { output = { left = "```\n", right = "\n```" } },
        },
        respect_selection_type = false,
        n_lines = 200,
      })

      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = true },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    keys = {
      {
        "<leader>tc",
        mode = { "n" },
        function()
          require("treesitter-context").toggle()
        end,
        desc = "[T]oggle [T]reesitter [C]ontext",
        opts = { silent = true },
      },
    },
    opts = {
      enable = true,
      multiwindow = false, -- Enable multiwindow support.
      max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
  },
}

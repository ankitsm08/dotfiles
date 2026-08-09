local custom_surroundings = {
  ["s"] = { input = { "%[().-()%]" }, output = { left = "[", right = "]" } }, -- [s]quare bracket
  ["B"] = { input = { "%[().-()%]" }, output = { left = "[", right = "]" } }, -- [b]ig bracket
  ["c"] = { input = { "{().-()}" }, output = { left = "{", right = "}" } }, -- [c]urly braces
  ["C"] = { input = { "{{().-()}}" }, output = { left = "{{", right = "}}" } }, -- double [c|C]urly braces
  ["Q"] = { input = { "'().-()'" }, output = { left = "'", right = "'" } }, -- [q]uote
  ["a"] = { input = { "'().-()'" }, output = { left = "'", right = "'" } }, -- [a]postrophe
  ["i"] = { input = { "%_().-()%_" }, output = { left = "_", right = "_" } }, -- [i]talic
  ["u"] = { input = { "%_().-()%_" }, output = { left = "_", right = "_" } }, -- [u]nderscore
  ["p"] = { input = { "%%().-()%%" }, output = { left = "%", right = "%" } }, -- [p]ercent
  ["l"] = { input = { "<u>().-()</u>" }, output = { left = "<u>", right = "</u>" } }, -- under[l]ine
  ["d"] = { input = { "%*%*().-()%*%*" }, output = { left = "**", right = "**" } }, -- bol[d]
  ["D"] = { input = { '"""().-\n()"""' }, output = { left = '"""\n', right = '\n"""' } }, -- docstring
  ["k"] = { input = { "`().-()`" }, output = { left = "`", right = "`" } }, -- [c|k]ode
  ["K"] = { input = { "```\n().-\n()```" }, output = { left = "```\n", right = "\n```" } }, -- [c|K]ode block
  ["m"] = { input = { "%$().-()%$" }, output = { left = "$", right = "$" } }, -- [m]ath
  ["M"] = { input = { "%$%$().-()%$%$" }, output = { left = "$$", right = "$$" } }, -- [m|M]ath block
  ["F"] = {
    input = function()
      local cmd = MiniSurround.user_input("LaTeX command")
      if cmd == nil or cmd == "" then
        return nil
      end
      return { "\\" .. vim.pesc(cmd) .. "{().-()}" }
    end,
    output = function()
      local cmd = MiniSurround.user_input("LaTeX command")
      if cmd == nil or cmd == "" then
        return nil
      end
      return { left = "\\" .. cmd .. "{", right = "}" }
    end,
  }, -- latex command wrapper
}

return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      local gen_spec = require("mini.ai").gen_spec

      require("mini.ai").setup({
        mappings = {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "aL",
          inside_last = "iL",
          goto_left = "g[",
          goto_right = "g]",
        },
        custom_textobjects = {
          a = gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
          m = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          i = gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
          l = gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }),
        },
        n_lines = 200,
      })

      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
          suffix_last = "l",
          suffix_next = "n",
        },
        custom_surroundings = custom_surroundings,
        respect_selection_type = false,
        n_lines = 200,
      })

      require("mini.pairs").setup({
        modes = { insert = true },
        skip_ts = { "string" },
        skip_unbalanced = true,
        markdown = true,
      })
    end,
  },
}

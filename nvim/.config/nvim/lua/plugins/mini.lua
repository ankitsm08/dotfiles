local custom_surroundings = {
  ["s"] = { output = { left = "[", right = "]" } }, -- [s]quare bracket
  ["B"] = { output = { left = "[", right = "]" } }, -- [b]ig bracket
  ["c"] = { output = { left = "{", right = "}" } }, -- [c]urly braces
  ["C"] = { output = { left = "{{", right = "}}" } }, -- double [c|C]urly braces
  ["Q"] = { output = { left = "'", right = "'" } }, -- [q]uote
  ["a"] = { output = { left = "'", right = "'" } }, -- [a]postrophe
  ["i"] = { output = { left = "_", right = "_" } }, -- [i]talic
  ["u"] = { output = { left = "_", right = "_" } }, -- [u]nderscore
  ["p"] = { output = { left = "%", right = "%" } }, -- [p]ercent
  ["l"] = { output = { left = "<u>", right = "</u>" } }, -- under[l]ine
  ["d"] = { output = { left = "**", right = "**" } }, -- bol[d]
  ["D"] = { output = { left = '"""\n', right = '\n"""' } }, -- docstring
  ["k"] = { output = { left = "`", right = "`" } }, -- [c|k]ode
  ["K"] = { output = { left = "```\n", right = "\n```" } }, -- [c|K]ode block
  ["m"] = { output = { left = "$", right = "$" } }, -- [m]ath
  ["M"] = { output = { left = "$$", right = "$$" } }, -- [m|M]ath block
}

return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({
        mappings = {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",
          goto_left = "g[",
          goto_right = "g]",
        },
        custom_surroundings = custom_surroundings,
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

local M = {}

local ls = require("luasnip")
local s = ls.s
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

-- True when the cursor sits inside LaTeX math (`$...$`, `$$...$$`, `\[...\]`)
-- Works in markdown too because the latex tree-sitter parser is injected into
-- those spans, so the same detection works for both .tex and .md math
local function in_math()
  local node = vim.treesitter.get_node({ ignore_injections = false, lang = nil })
  if not node then
    return false
  end
  while node do
    local t = node:type()
    if t == "inline_formula" or t == "displayed_equation" then
      return true
    end
    if t == "text_mode" then
      return false
    end
    node = node:parent()
  end
  return false
end

local function nodes_for(fmt_str)
  local nodes = {}
  local count = select(2, fmt_str:gsub("<>", ""))
  for idx = 1, count do
    nodes[idx] = i(idx, "")
  end
  return nodes
end

-- Math-mode autosnippets: only expand inside math regions
local math_auto = {
  { "frac", "\\frac{<>}{<>}" },
  { "ff", "\\frac{<>}{<>}" },
  { "dfrac", "\\dfrac{<>}{<>}" },
  { "df", "\\dfrac{<>}{<>}" },
  { "tfrac", "\\tfrac{<>}{<>}" },
  { "tf", "\\tfrac{<>}{<>}" },
  { "displaystyle", "\\displaystyle <>" },
  { "ds", "\\displaystyle <>" },
  { "root", "\\sqrt[<>]{<>}" },
  { "sqrt", "\\sqrt{<>}" },
  { "cbrt", "\\sqrt[3]{<>}" },
  { "^", "^{<>}", false },
  { "_", "{<>}", false },
  { "sr", "^{<>}", false },
  { "sb", "_{<>}", false },
  { "int", "\\int_{<>}^{<>} <>" },
  { "iint", "\\iint_{<>}^{<>} <>" },
  { "iiint", "\\iiint_{<>}^{<>} <>" },
  { "oint", "\\oint_{<>}^{<>} <>" },
  { "dv", "\\frac{d<>}{d<>}" },
  { "pdv", "\\frac{\\partial <>}{\\partial <>}" },
  { "dint", "\\int_{<>}^{<>} \\frac{<>}{<>}" },
  { "sum", "\\sum_{<>}^{<>} <>" },
  { "prod", "\\prod_{<>}^{<>} <>" },
  { "lim", "\\lim_{<> \\to <>} <>" },
  { "limsup", "\\limsup_{<>} <>" },
  { "liminf", "\\liminf_{<>} <>" },
  { "max", "\\max_{<>}" },
  { "min", "\\min_{<>}" },
  { "binom", "\\binom{<>}{<>}" },
  { "al", "\\alpha" },
  { "bet", "\\beta" },
  { "ga", "\\gamma" },
  { "Ga", "\\Gamma" },
  { "de", "\\delta" },
  { "De", "\\Delta" },
  { "tz", "\\zeta" },
  { "th", "\\theta" },
  { "Th", "\\Theta" },
  { "ka", "\\kappa" },
  { "la", "\\lambda" },
  { "La", "\\Lambda" },
  { "mu", "\\mu" },
  { "nu", "\\nu" },
  { "xi", "\\xi" },
  { "Xi", "\\Xi" },
  { "pi", "\\pi" },
  { "Pi", "\\Pi" },
  { "rh", "\\rho" },
  { "si", "\\sigma" },
  { "Si", "\\Sigma" },
  { "tau", "\\tau" },
  { "phi", "\\phi" },
  { "Phi", "\\Phi" },
  { "ch", "\\chi" },
  { "ps", "\\psi" },
  { "Ps", "\\Psi" },
  { "om", "\\omega" },
  { "Om", "\\Omega" },
  { "eps", "\\epsilon" },
  { "veps", "\\varepsilon" },
  { "le", "\\le" },
  { "ge", "\\ge" },
  { "neq", "\\neq" },
  { "equiv", "\\equiv" },
  { "approx", "\\approx" },
  { "sim", "\\sim" },
  { "propto", "\\propto" },
  { "subset", "\\subset" },
  { "supset", "\\supset" },
  { "subseteq", "\\subseteq" },
  { "supseteq", "\\supseteq" },
  { "in", "\\in", false },
  { "notin", "\\notin" },
  { "forall", "\\forall" },
  { "exists", "\\exists" },
  { "neg", "\\neg" },
  { "land", "\\land" },
  { "lor", "\\lor" },
  { "implies", "\\implies" },
  { "impliedby", "\\impliedby" },
  { "iff", "\\iff" },
  { "emptyset", "\\emptyset" },
  { "varnothing", "\\varnothing" },
  { "cup", "\\cup" },
  { "cap", "\\cap" },
  { "setminus", "\\setminus" },
  { "bigcup", "\\bigcup_{<>} <>" },
  { "bigcap", "\\bigcap_{<>} <>" },
  { "to", "\\to", false },
  { "mapsto", "\\mapsto", false },
  { "rightarrow", "\\rightarrow" },
  { "leftarrow", "\\leftarrow" },
  { "leftrightarrow", "\\leftrightarrow" },
  { "Rightarrow", "\\Rightarrow" },
  { "times", "\\times" },
  { "div", "\\div" },
  { "cdot", "\\cdot" },
  { "pm", "\\pm" },
  { "mp", "\\mp" },
  { "ast", "\\ast" },
  { "star", "\\star" },
  { "circ", "\\circ" },
  { "bullet", "\\bullet" },
  { "oplus", "\\oplus" },
  { "otimes", "\\otimes" },
  { "pmod", "\\pmod{<>}" },
  { "inf", "\\infty" },
  { "abs", "\\left| <> \\right|" },
  { "norm", "\\left\\| <> \\right\\|" },
  { "ceil", "\\lceil <> \\rceil" },
  { "floor", "\\lfloor <> \\rfloor" },
  { "langle", "\\langle <> \\rangle" },
  { "hat", "\\hat{<>}" },
  { "bar", "\\bar{<>}" },
  { "over", "\\overline{<>}" },
  { "vec", "\\vec{<>}" },
  { "dot", "\\dot{<>}" },
  { "ddot", "\\ddot{<>}" },
  { "tilde", "\\tilde{<>}" },
  { "text", "\\text{<>}" },
  { "bb", "\\mathbb{<>}" },
}

-- Plain snippets: available in completion menu, no auto-expansion
local env_snips = {
  { "be", "\\begin{<>}\n<>\n\\end{<>}" },
  { "al", "\\begin{align}\n<>\n\\end{align}" },
  { "als", "\\begin{align*}\n<>\n\\end{align*}" },
  { "eq", "\\begin{equation}\n<>\n\\end{equation}" },
  { "ca", "\\begin{cases}\n<>\n\\end{cases}" },
  { "matb", "\\begin{bmatrix}\n<>\n\\end{bmatrix}" },
  { "matp", "\\begin{pmatrix}\n<>\n\\end{pmatrix}" },
  { "matv", "\\begin{vmatrix}\n<>\n\\end{vmatrix}" },
  { "item", "\\item <>" },
  { "sec", "\\section{<>}" },
  { "fig", "\\begin{figure}[<>]\n  \\centering\n  \\includegraphics[{<>}]{<>}\n  \\caption{<>}\n\\end{figure}" },
}

local function make_snips(defs, autosnip, math_gated)
  local out = {}
  for _, d in ipairs(defs) do
    local opts = {
      trig = d[1],
      snippetType = autosnip and "autosnippet" or "snippet",
      wordTrig = d[3] == nil and true or d[3],
      priority = autosnip and 1500 or 100,
    }
    if math_gated then
      out[#out + 1] = s(opts, fmta(d[2], nodes_for(d[2])), { condition = in_math })
    else
      out[#out + 1] = s(opts, fmta(d[2], nodes_for(d[2])))
    end
  end
  return out
end

M.setup = function()
  ls.add_snippets("tex", make_snips(math_auto, true, true), { key = "obsidian_math" })
  ls.add_snippets("tex", make_snips(env_snips, false, false), { key = "latex_env" })
end

return M

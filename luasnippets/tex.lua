local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local tex_utils = {}
tex_utils.in_mathzone = function() -- math context detection
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end
tex_utils.in_text = function()
	return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function() -- comment detection
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end
tex_utils.in_env = function(name) -- generic environment detection
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function() -- equation environment detection
	return tex_utils.in_env("equation")
end
tex_utils.in_itemize = function() -- itemize environment detection
	return tex_utils.in_env("itemize")
end
tex_utils.in_tikz = function() -- TikZ picture environment detection
	return tex_utils.in_env("tikzpicture")
end

return {
	s(
		{ trig = "template", dscr = "create a template" },
		fmta(
			[[
		\documentclass[a4paper]{article}

		\usepackage[utf8]{inputenc}
		\usepackage{textcomp}
		\usepackage{amsmath, amssymb}
		\usepackage{graphicx}

		\title{<>}
		\author{Mamunur Rashid}

		\begin{document}
		\maketitle

			<>
		\end{document}
		]],
			{ i(1), i(0) }
		)
	),
	s(
		{ trig = "section", dscr = "section" },
		fmta(
			[[
		\section{<>}
		<>
		]],
			{ i(1), i(0) }
		),
		{ condition = tex_utils.in_env("document") }
	),
	s(
		{ trig = "sctn", snippetType = "autosnippet", dscr = "section" },
		fmta(
			[[
		\section{<>}
		<>
		]],
			{ i(1), i(0) }
		),
		{ condition = tex_utils.in_env("document") }
	),
	s(
		{ trig = "mk", snippetType = "autosnippet", dscr = "expand mk into inline math" },
		fmta([[$<>$ <>]], { i(1), i(0) }),
		{ condition = tex_utils.in_text }
	),
	s(
		{ trig = "bgn", snippetType = "autosnippet", dscr = "bgn to begin" },
		fmta(
			[[
		\begin{<>}
		   <>
		\end{<>}
		]],
			{ i(1), i(0), rep(1) }
		),
		{ condition = tex_utils.in_text }
	),

	s(
		{ trig = "eqn", snippetType = "autosnippet", dscr = "eqn to equation env" },
		fmta(
			[[
		\begin{equation*}
		   <>
		\end{equation*}
		]],
			{ i(1) }
		),
		{ condition = tex_utils.in_text }
	),
	s(
		{ trig = "itm", snippetType = "autosnippet", dscr = "itm to item in itemize" },
		fmta(
			[[
	\item <>
	]],
			{ i(0) }
		),
		{ condition = tex_utils.in_itemize }
	),
	s(
		{ trig = "tbf", snippetType = "autosnippet", dscr = "tbf to textbf" },
		fmta([[ \textbf{<>} <>]], { i(1), i(0) }),
		{ condition = tex_utils.in_text }
	),
	s(
		{ trig = "([%s])bb", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta(" \\mathbb{<>}", { i(1) }),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%w])bb", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\mathbb{<>}]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%s])cal", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta(" \\mathcal{<>}", { i(1) }),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%w])cal", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\mathcal{<>}]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%s])ket", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\ket{<>}]], { i(1) }),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%w])ket", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\ket{<>}]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%s])bra", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\bra{<>}]], { i(1) }),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%w])bra", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\bra{<>}]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%s])hat", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\hat{<>}]], { i(1) }),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "([%w])hat", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\hat{<>}]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = "([%a])bar", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\bar{<>}]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = "//", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[ \frac{<>}{<>} ]],
			{ i(1), i(2) }
		),
		{ condition = tex_utils.in_mathzone }
	),
	s(
		{ trig = ";a", snippetType = "autosnippet" },
		{ t("\\alpha ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";b", snippetType = "autosnippet" },
		{ t("\\beta ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";g", snippetType = "autosnippet" },
		{ t("\\gamma ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";s", snippetType = "autosnippet" },
		{ t("\\sigma ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";m", snippetType = "autosnippet" },
		{ t("\\mu ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";n", snippetType = "autosnippet" },
		{ t("\\nu ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";pi", snippetType = "autosnippet" },
		{ t("\\pi ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";ph", snippetType = "autosnippet" },
		{ t("\\phi ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";ps", snippetType = "autosnippet" },
		{ t("\\psi ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = ";w", snippetType = "autosnippet" },
		{ t("\\omega ") },
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = "^", snippetType = "autosnippet" },
		fmta(
			[[^{<>}]],
			{ i(1) }
		),
		{ condition = tex_utils.in_mathzone }
	),

	s(
		{ trig = "_", snippetType = "autosnippet" },
		fmta(
			[[_{<>}]],
			{ i(1) }
		),
		{ condition = tex_utils.in_mathzone }
	),

}

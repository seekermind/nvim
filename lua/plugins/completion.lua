return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"MunifTanjim/eslint.nvim",
		config = function()
			local eslint = require("eslint")
			eslint.setup({
				bin = "eslint", -- or `eslint_d`
				code_actions = {
					enable = true,
					apply_on_save = {
						enable = true,
						types = { "directive", "problem", "suggestion", "layout" },
					},
					disable_rule_comment = {
						enable = true,
						location = "separate_line", -- or `same_line`
					},
				},
				diagnostics = {
					enable = true,
					report_unused_disable_directives = false,
					run_on = "type", -- or `save`
				},
			})
		end,
	},
	{
		"micangl/cmp-vimtex",
		config = function()
			require("cmp_vimtex").setup({
				-- additional_information = {
				-- 	info_in_menu = true,
				-- 	info_in_window = true,
				-- 	info_max_length = 60,
				-- 	match_against_info = true,
				-- 	symbols_in_menu = true,
				-- },
			})
			vim.keymap.set("n", "<Leader>L", '<Cmd>lua require("luasnip.loaders.from_lua").load()<CR>')
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		dependencies = { "saadparwaiz1/cmp_luasnip" },
		config = function()
			-- hot reload snippets
			vim.keymap.set(
				"n",
				"<Leader>L",
				'<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/luasnippets/"})<CR>'
			)
			require("luasnip").setup({
				update_events = "TextChanged,TextChangedI",
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local kind_icons = {
				Text = "",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰇽",
				Variable = "󰂡",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "󰅲",
			}

			-- require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			-- local has_words_before = function()
			-- 	local cursor = vim.api.nvim_win_get_cursor(0)
			-- 	return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or "")
			-- 		:sub(cursor[2], cursor[2])
			-- 		:match("%s")
			-- end

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				formatting = {
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
						-- Source
						vim_item.menu = ({
							vimtex = vim_item.menu,
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[LaTeX]",
						})[entry.source.name]
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

					-- super tab mapping
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- that way you will only jump inside the snippet region
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
							-- elseif has_words_before() then
							-- 	cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "vimtex" },
					{ name = "nvim_lsp" },
					-- { name = 'vsnip' }, -- For vsnip users.
					{ name = "luasnip" }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}

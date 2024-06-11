return {
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				---LHS of toggle mappings in NORMAL mode
				toggler = {
					---Line-comment toggle keymap
					line = "<leader>cc",
					---Block-comment toggle keymap
					block = "<leader>bc",
				},
				---LHS of operator-pending mappings in NORMAL and VISUAL mode
				opleader = {
					---Line-comment keymap
					line = "<leader>cc",
					---Block-comment keymap
					block = "<leader>bc",
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup()
		end,
	},
	{
		{
			"NvChad/nvterm",
			config = function()
				require("nvterm").setup()

				local terminal = require("nvterm.terminal")

				local ft_cmds = {}
				local toggle_modes = { "n", "t" }
				local mappings = {
					{ "n", "<C-l>", function() terminal.send(ft_cmds[vim.bo.filetype]) end, },
					{ toggle_modes, "<A-h>", function() terminal.toggle("horizontal") end, },
					{ toggle_modes, "<A-v>", function() terminal.toggle("vertical") end, },
					{ toggle_modes, "<A-i>", function() terminal.toggle("float") end, },
				}
				local opts = { noremap = true, silent = true }
				for _, mapping in ipairs(mappings) do
					vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
				end
			end,
		},
	},
}

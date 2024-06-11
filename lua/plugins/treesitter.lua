return {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
	config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "lua", "python" },
		  ignore_install = {"latex"},
          auto_install = true,
          highlight = { enable = true, disable = { "latex" }, },
        })
    end
}

-- general text editing utilities

return {
	-- easily toggle comments
	{
		"numToStr/Comment.nvim",
		lazy = true,
		event = { "BufRead" },
		config = function()
			require("Comment").setup()
		end,
	},
	-- autoinsert matching ", ( etc.
	{
		"windwp/nvim-autopairs",
		lazy = true,
		event = "BufEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
				ts_config = {
					lua = { "string" }, -- it will not add a pair on that treesitter node
					javascript = { "template_string" },
					java = false, -- don't check treesitter on java
				},
			})
		end,
	},
	-- autoclose html tags
	{
		"windwp/nvim-ts-autotag",
		lazy = true,
		event = "BufEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	-- surround text with characters, html tags
	{
		"kylechui/nvim-surround",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
}

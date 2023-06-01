-- ui enchancments

return {
	-- show vertical indentation lines
	{
		"lukas-reineke/indent-blankline.nvim",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("indent_blankline").setup({})
		end,
	},
	-- notifications
	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				timeout = 3000,
			})
		end,
	},
	-- command line moved
	{
		"folke/noice.nvim",
		lazy = true,
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("noice").setup({
				presets = {
					command_palette = true,
				},
			})
		end,
	},
	-- better select ui, more notifications
	{
		"stevearc/dressing.nvim",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("dressing").setup({})
		end,
	},
	-- highlight css colors
	{
		"norcalli/nvim-colorizer.lua",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("colorizer").setup({
				["*"] = {
					RGB = true, -- #RGB hex codes
					RRGGBB = true, -- #RRGGBB hex codes
					names = true, -- "Name" codes like Blue
					RRGGBBAA = true, -- #RRGGBBAA hex codes
					rgb_fn = true, -- CSS rgb() and rgba() functions
					hsl_fn = true, -- CSS hsl() and hsla() functions
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
					-- Available modes: foreground, background
					mode = "background", -- Set the display mode.
				},
			})
		end,
	},
	-- code actions menu, rename menu, doc menu, code outline
	{
		"glepnir/lspsaga.nvim",
		lazy = true,
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				definition = {
					edit = "<cr>", -- make enter move into definition buffer
				},
				outline = {
					keys = {
						expand_or_jump = "<cr>", -- make enter go to object
					},
				},
				code_action = {
					show_server_name = true,
				},
				hover_doc = {
					open_browser = "!firefox",
				},
				lightbulb = {
					enable = false,
				},
			})
		end,
	},
}

-- better status line

return {
	"nvim-lualine/lualine.nvim",
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "filename" },
				lualine_c = { "branch", "diff", "diagnostics" },
				lualine_x = { "filetype" },
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			options = {
				theme = "poimandres",
				section_separators = { left = "", right = "" },
				component_separators = { left = "/", right = "/" },
				disabled_filetypes = { "NvimTree", "lspsagaoutline" },
			},
		})
	end,
}

-- git related plugins

return {
	-- changed status on the left, hunk navigation, blame
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	lazy = true,
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
		})
	end,
}

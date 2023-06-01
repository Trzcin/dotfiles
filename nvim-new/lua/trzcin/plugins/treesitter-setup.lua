-- abstract syntax tree generation, parsers, better syntax highlighting

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = true,
	event = "BufEnter",
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			autotag = { enable = true },
			-- auto install above language parsers
			auto_install = true,
		})
	end,
}

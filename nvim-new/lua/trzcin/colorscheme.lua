require("poimandres").setup({
	bold_vert_split = false, -- use bold vertical separators
	dim_nc_background = false, -- dim 'non-current' window backgrounds
	disable_background = false, -- disable background
	disable_float_background = false, -- disable background for floats
	disable_italics = false, -- disable italics
	highlight_groups = {
		TelescopeSelection = { fg = "#E4F0FB", bg = "#4f588c" },
		TelescopeSelectionCaret = { fg = "#5DE4C7", bg = "#4f588c" },
		LspSignatureActiveParameter = { bg = "#4f588c" },
	},
})

vim.cmd("colorscheme poimandres")
-- hide '~' characters at the end of file
vim.opt.fillchars:append("eob: ")

local lspsaga_status, lspsaga = pcall(require, "lspsaga")
if not lspsaga_status then
	print("lspsaga not found")
	return
end

lspsaga.setup({
	definition = {
		edit = "<CR>",
	},
	lightbulb = {
		enable = false,
	},
	diagnostic = {
		on_insert = false,
	},
	symbol_in_winbar = {
		enable = false,
	},
	outline = {
		keys = {
			jump = "<CR>",
		},
	},
})

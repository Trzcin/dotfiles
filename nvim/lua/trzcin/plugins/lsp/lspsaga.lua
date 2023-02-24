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
})

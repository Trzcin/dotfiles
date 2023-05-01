local status, lualine = pcall(require, "lualine")
if not status then
	print("lualine not found")
	return
end

lualine.setup({
	sections = {
		lualine_a = { "buffers" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {},
		lualine_x = { "filetype" },
		lualine_y = {},
		lualine_z = { "location" },
	},
})

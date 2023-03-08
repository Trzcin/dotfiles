local status, colorizer = pcall(require, "colorizer")
if not status then
	print("colorizer not found")
	return
end

colorizer.setup({
	"*",
	css = {
		css = true,
	},
})

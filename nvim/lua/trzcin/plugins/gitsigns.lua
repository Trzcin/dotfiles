local status, gitsigns = pcall(require, "gitsigns")
if not status then
	print("gitsigns not found")
	return
end

gitsigns.setup()

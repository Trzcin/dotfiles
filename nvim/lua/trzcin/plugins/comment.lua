local status, comment = pcall(require, "Comment")
if not status then
	print("comment not found")
	return
end

comment.setup()

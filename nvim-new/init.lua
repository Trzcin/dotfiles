if vim.g.vscode then
	-- VSCode extension
else
	-- basic neovim options
	require("trzcin.options")
	-- basic keybindings
	require("trzcin.keymaps")

	-- install lazy.nvim if necessary
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	-- add plugins
	require("lazy").setup("trzcin.plugins")

	-- set colorscheme
	require("trzcin.colorscheme")
end

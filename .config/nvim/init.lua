if vim.g.vscode then
	require('init-vscode')
	return
end

-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 0 -- Uses uses tabstop as the value
vim.o.signcolumn = 'yes'
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.undofile = true
vim.o.fillchars = 'eob: '

-- General keymaps
vim.g.mapleader = ' '
local map = vim.keymap.set
map({ 'n', 'x' }, '<leader>y', '"+y')
map({ 'n', 'x' }, '<leader>p', '"+p')
map('n', 'U', '<C-r>')

-- Setup mini.deps plugin manager
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.deps`" | redraw')
	local clone_cmd = {
		'git', 'clone', '--filter=blob:none',
		'https://github.com/nvim-mini/mini.deps', mini_path
	}
	vim.fn.system(clone_cmd)
	vim.cmd('packadd mini.deps | helptags ALL')
	vim.cmd('echo "Installed `mini.deps`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add = MiniDeps.add

-- Colorscheme
add('miikanissi/modus-themes.nvim')

require('modus-themes').setup({
	styles = {
		keywords = { italic = false },
	},
})

vim.cmd.colorscheme('modus')

-- Treesitter parsers and highlighting
add({
	source = 'nvim-treesitter/nvim-treesitter',
	checkout = 'main',
	hooks = { post_checkout = function() vim.cmd.TSUpdate() end },
})

local treesitter_langs = {
	'bash',
	'fish',

    'html',
	'css',
	'scss',
    'javascript',
    'jsdoc',
    'typescript',
	'jsx',
    'tsx',
	'vue',
	'svelte',

    'json',
    'jsonc',
    'yaml',
    'toml',
    'xml',

    'lua',
    'luadoc',
    'luap',

    'vim',
    'vimdoc',

    'c',
    'printf',

    'markdown',
    'markdown_inline',

    'python',

	'query',
	'regex',
	'diff',
}

require('nvim-treesitter').install(treesitter_langs)

-- Enable treesitter for listed languages
local config_group = vim.api.nvim_create_augroup('config', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = config_group,
	pattern = langs,
	callback = function(args)
		pcall(function() vim.treesitter.start(args.buf) end)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Icons
add('nvim-mini/mini.icons')
require('mini.icons').setup()

-- Directory explorer
add('stevearc/oil.nvim')

require('oil').setup({
	skip_confirm_for_simple_edits = true,
	watch_for_changes = true,
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name)
			return name == '..'
		end,
	},
})

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

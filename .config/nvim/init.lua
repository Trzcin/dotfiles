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
vim.o.cursorline = true
vim.o.winborder = 'rounded'

-- General keymaps
vim.g.mapleader = ' '
local map = vim.keymap.set
map({ 'n', 'x' }, '<leader>y', '"+y')
map({ 'n', 'x' }, '<leader>p', '"+p')
map({ 'n', 'x' }, '<leader>Y', '"+Y', { remap = true })
map('n', 'U', '<C-r>')
map('n', '<leader>w', '<C-w>', { remap = true })
map('n', '<leader>L', '<CMD>e #<CR>')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

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
	on_highlights = function (highlights, c)
		highlights.NormalFloat = { fg = c.fg_main, bg = c.bg_main }
		highlights.Pmenu = { fg = c.fg_main, bg = c.bg_main }
		highlights.PmenuSel = { fg = c.bg_main, bg = c.fg_main }
	end,
	on_colors = function () end
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
	pattern = treesitter_langs,
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

map('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Fuzzy finder (mini.pick)
add('nvim-mini/mini.pick')
add('nvim-mini/mini.extra')

local function setup_picker_registry()
	-- List hidden files and directories in file picker
	MiniPick.registry.files = function()
		return MiniPick.builtin.cli({ command = { 'rg', '--files', '--color=never', '--hidden' } }, {
			source = {
				name = 'Files (rg)',
				show = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query, { show_icons = true }) end,
			},
		})
	end
end

local function ensure_mini_pick()
	if MiniPick ~= nil then
		return
	end

	require('mini.pick').setup()
	require('mini.extra').setup()
	setup_picker_registry()
end

map('n', '<leader>sf', function()
	ensure_mini_pick()
	MiniPick.registry.files()
end)

map('n', '<leader>sb', function()
	ensure_mini_pick()
	MiniPick.builtin.buffers()
end)

map('n', '<leader>ss', function()
	ensure_mini_pick()
	MiniPick.builtin.grep_live()
end)

map('n', '<leader>sh', function()
	ensure_mini_pick()
	MiniPick.builtin.help({ default_split = 'vertical' })
end)

map('n', '<leader>sl', function()
	ensure_mini_pick()
	MiniExtra.pickers.lsp({ scope = 'document_symbol' })
end)

map('n', '<leader>sr', function()
	ensure_mini_pick()
	MiniPick.builtin.resume()
end)

-- Statusline
vim.api.nvim_set_hl(0, 'StatusLineSecondary', { fg = '#adadad' }) -- WCAG AA

function StatusLineRelativeFilepath()
	-- For some reason %f is sometimes absolute, sometimes relative
	return vim.fn.expand('%:~:.')
end

function StatusLineFileIcon()
	local bufid = vim.api.nvim_win_get_buf(0)
	local icon, hl = MiniIcons.get('file', vim.api.nvim_buf_get_name(bufid))

	return '%#' .. hl .. '#' .. icon .. '%*'
end

function StatusLineDiagnostics()
	local diagnostics = vim.diagnostic.count(0)
	local text = ''

	local errorCount = diagnostics[vim.diagnostic.severity.ERROR]
	if errorCount ~= nil then
		text = text .. '%#DiagnosticSignError# ' .. errorCount .. ' %*'
	end

	local warnCount = diagnostics[vim.diagnostic.severity.WARN]
	if warnCount ~= nil then
		text = text .. '%#DiagnosticSignWarn# ' .. warnCount .. ' %*'
	end

	local infoCount = diagnostics[vim.diagnostic.severity.INFO]
	if infoCount ~= nil then
		text = text .. '%#DiagnosticSignInfo# ' .. infoCount .. ' %*'
	end

	local hintCount = diagnostics[vim.diagnostic.severity.HINT]
	if hintCount ~= nil then
		text = text .. '%#DiagnosticSignHint#󰋗 ' .. hintCount .. ' %*'
	end

	return text
end

vim.api.nvim_create_autocmd('DiagnosticChanged', {
	group = config_group,
	callback = function()
		vim.cmd('redrawstatus')
	end
})

local statusline_components = {
	'%{%v:lua.StatusLineFileIcon()%}', -- file icon
	' %{%v:lua.StatusLineRelativeFilepath()%}', -- relative file path
	' %h%w%m%r', -- buffer flags
	'%=', -- spacer
	'%{%v:lua.StatusLineDiagnostics()%}', -- diagnostics
	'%#StatusLineSecondary#l: %*%l%#StatusLineSecondary#/%L', -- line
	' c: %c', -- column
}

vim.o.statusline = table.concat(statusline_components, '')

-- LSP keymaps
map('n', 'gd', function() vim.lsp.buf.definition() end)
map('n', '<C-w>gd', function()
	vim.cmd.vsplit()
	vim.lsp.buf.definition()
end)
map('n', 'gt', function() vim.lsp.buf.type_definition() end)
map('n', '<leader>lr', function() vim.lsp.buf.rename() end)
map('n', '<leader>lR', function() MiniExtra.pickers.lsp({ scope = 'references' }) end)
map('n', '<leader>la', function() vim.lsp.buf.code_action() end)
map('n', '<leader>lf', function() vim.lsp.buf.format() end)
map('n', '<leader>lf', function() vim.lsp.buf.format() end)
map('n', '<leader>ld', function() vim.diagnostic.open_float() end)

-- Autocomplete
add({
	source = 'saghen/blink.cmp',
	checkout = 'v1.8.0',
})
local blink = require('blink.cmp')
blink.setup({
	keymap = { preset = 'super-tab' },
	appearence = { nerd_font_variant = 'normal' },
	completion = {
		accept = {
			auto_brackets = { enabled = false }
		},
	},
	signature = { enabled = true }
})

-- LSP
add('mason-org/mason.nvim')
require('mason').setup()
add('neovim/nvim-lspconfig')
add('mason-org/mason-lspconfig.nvim')

local language_servers = {
	'lua_ls',
}

require('mason-lspconfig').setup({ ensure_installed = language_servers })

vim.lsp.config("*", {
	capabilities = blink.get_lsp_capabilities()
})

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰋗 ",
		},
	},
})

vim.api.nvim_create_autocmd("InsertEnter", {
	group = config_group,
	pattern = "*",
	callback = function() vim.diagnostic.enable(false) end
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = config_group,
	pattern = "*",
	callback = function() vim.diagnostic.enable(true) end
})

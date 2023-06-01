local M = {}

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	print("cmp_nvim_lsp not found")
	return
end

local keymap = vim.keymap

function M.on_attach(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>co", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
	keymap.set("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
	keymap.set("n", "<leader>dd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "<leader>dw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", opts) -- show diagnostics for project
	keymap.set("n", "<leader>df", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts) -- show diagnostics for file
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>io", ":TypescriptOrganizeImports<CR>") -- organize imports
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables
	end
end

-- used to enable autocompletion (assign to every lsp server config)
M.capabilities = cmp_nvim_lsp.default_capabilities()
M.capabilities.offsetEncoding = { "utf-16" }

return M

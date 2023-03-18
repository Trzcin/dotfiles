local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	print("lspconfig not found")
	return
end

local typescript_status, typescript = pcall(require, "typescript")
if not typescript_status then
	print("typescript not found")
	return
end

local rust_tools_status, rust_tools = pcall(require, "rust-tools")
if not rust_tools_status then
	print("rust_tools not found")
	return
end

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local on_attach = require("trzcin.plugins.lsp.settings").on_attach
local capabilities = require("trzcin.plugins.lsp.settings").capabilities

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- c++
lspconfig["clangd"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

rust_tools.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- lspconfig["jdtls"].setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- })

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

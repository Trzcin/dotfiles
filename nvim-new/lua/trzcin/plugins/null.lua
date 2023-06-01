-- formatting, linting, custom suggestions, custom code actions and more 🔥

return {
	"jose-elias-alvarez/null-ls.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-null-ls").setup()
		local null_ls = require("null-ls")

		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics
		local actions = null_ls.builtins.code_actions
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				formatting.prettier, -- frontend formatting
				formatting.stylua, -- lua formatting
				formatting.clang_format, -- formatting for c, c++, java and many others
				diagnostics.eslint_d.with({ -- javascript linting, code style
					condition = function(utils) -- only run if an eslint config is present
						return (
							utils.root_has_file(".eslintrc.json")
							or utils.root_has_file(".eslintrc.js")
							or utils.root_has_file(".eslintrc.yml")
							or utils.root_has_file(".eslintrc.mjs")
						)
					end,
				}),
				diagnostics.clang_check, -- c, c++ static analyzer
				actions.eslint_d, -- eslint code actions
			},
			-- auto formatting
			on_attach = function(current_client, bufnr)
				if current_client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								filter = function(client)
									--  only use null-ls for formatting instead of lsp server
									return client.name == "null-ls"
								end,
								bufnr = bufnr,
							})
						end,
					})
				end
			end,
		})
	end,
}

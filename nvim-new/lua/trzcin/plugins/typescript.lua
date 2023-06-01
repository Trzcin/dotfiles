return {
	"jose-elias-alvarez/typescript.nvim",
	lazy = true,
	ft = { "typescript", "svelte" },
	config = function()
		local capabilities = require("trzcin.plugins.lsp.settings").capabilities
		local on_attach = require("trzcin.plugins.lsp.settings").on_attach

		require("typescript").setup({
			server = {
				capabilities = capabilities,
				on_attach = on_attach,
			},
		})

		require("null-ls").register(require("typescript.extensions.null-ls.code-actions"))
	end,
}

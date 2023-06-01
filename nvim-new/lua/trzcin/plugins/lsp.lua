-- configuration for language servers, autocomplete etc.

-- set icons for lsp diagnostics
local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- set look and feel of diagnostics display
vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
		prefix = "● ",
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})

-- plugins
return {
	-- autocomplete
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-buffer", -- suggest text from buffer
			"hrsh7th/cmp-path", -- sugest file path
			"L3MON4D3/LuaSnip", -- sinppet engine
			"saadparwaiz1/cmp_luasnip", -- show snippets in autocomplete
			"rafamadriz/friendly-snippets", -- collection of premade snippets
			"hrsh7th/cmp-nvim-lsp", -- add lsp suggestions
			"onsails/lspkind.nvim", -- suggestion items icons
			"windwp/nvim-autopairs", -- insert function parenthesis ()
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()
			vim.opt.completeopt = "menu,menuone,noselect"
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<tab>"] = cmp.mapping.confirm({ select = false }),
				}),
				-- sources for autocompletion
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- lsp
					{ name = "luasnip" }, -- snippets
					{ name = "buffer" }, -- text within current buffer
					{ name = "path" }, -- file system paths
				}),
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				-- configure lspkind for vs-code like icons
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})

			-- make autopairs and completion work together
			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
		end,
	},
	-- configure regular language servers
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Mason",
		dependencies = {
			"williamboman/mason.nvim", -- utilitiy for installing language servers and other binaries
			"williamboman/mason-lspconfig.nvim", -- used for looping through all installed language servers
			"hrsh7th/cmp-nvim-lsp", -- default capabilities
		},
		config = function()
			local lspconfig = require("lspconfig")
			require("mason").setup()
			require("mason-lspconfig").setup()

			-- these will be passed to all language servers
			local on_attach = require("trzcin.plugins.lsp.settings").on_attach
			local capabilities = require("trzcin.plugins.lsp.settings").capabilities

			-- exclude servers to be configured seperatly
			local exclude_servers =
				{ ["tsserver"] = true, ["jdtls"] = true, ["rust_analyzer"] = true, ["lua_ls"] = true }

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					if exclude_servers[server_name] ~= nil then
						return
					end

					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
			})

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
		end,
	},
}

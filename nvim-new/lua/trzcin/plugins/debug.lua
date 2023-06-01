vim.keymap.set("n", "<leader>Da", ":lua require('dap').toggle_breakpoint()<cr>") -- add/remove breakpoint
vim.keymap.set("n", "<leader>Dc", ":lua require('dap').continue()<cr>") -- launch debugging/continue execution
vim.keymap.set("n", "<leader>D<Right>", ":lua require('dap').step_over()<cr>")
vim.keymap.set("n", "<leader>D<Down>", ":lua require('dap').step_into()<cr>")
vim.keymap.set("n", "<leader>D<Up>", ":lua require('dap').step_out()<cr>")

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticHint", linehl = "", numhl = "" })

return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		event = "VeryLazy",
		dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text" },
		priority = 1999,
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({})
			require("nvim-dap-virtual-text").setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- setup cpptools adapter
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
			}

			dap.configurations.cpp = {
				{
					name = "Launch File",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = true,
					setupCommands = {
						{
							text = "-enable-pretty-printing",
							description = "enable pretty printing",
							ignoreFailures = false,
						},
					},
				},
			}

			require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependecies = "Mason",
		lazy = true,
		cmd = "Mason",
		config = function()
			require("mason").setup()
			require("mason-nvim-dap").setup({
				ensure_installed = { "cpptools" },
			})
		end,
	},
}

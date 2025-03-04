return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
			}
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, {})
			vim.keymap.set("n", "<Leader>dc", dap.continue, {})
		end,
	},
}

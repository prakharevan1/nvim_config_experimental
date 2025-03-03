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
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		config = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.keymap.set("n", "<leader>a", function()
				vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
				-- or vim.lsp.buf.codeAction() if you don't want grouping.
			end, { silent = true, buffer = bufnr })
			vim.keymap.set(
				"n",
				"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
				function()
					vim.cmd.RustLsp({ "hover", "actions" })
				end,
				{ silent = true, buffer = bufnr }
			)
		end,
	},
}

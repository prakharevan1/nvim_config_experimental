return {
	"mrcjkb/rustaceanvim",
	version = "^4",
	ft = { "rust" },
	lazy = false,
	["rust-analyzer"] = {
		cargo = {
			allFeatures = true,
		},
	},
	dependencies = { "mfussenegger/nvim-dap" },
	config = function()
		local cfg = require("rustaceanvim.config")
		local dap = require("dap")

		-- Find the codelldb paths (Mason path for WSL/Ubuntu)
		local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

		if vim.uv.os_uname().sysname == "Darwin" then
			liblldb_path = liblldb_path:gsub("%.so$", ".dylib")
		end

		-- Ensure position encoding is set to utf-16
		local function on_attach(client, bufnr)
			if not client.offset_encoding or client.offset_encoding ~= "utf-16" then
				client.offset_encoding = "utf-16"
			end
			print("Rustaceanvim attached with encoding: " .. client.offset_encoding)

			-- Override make_position_params globally to enforce utf-16
			local original_make_position_params = vim.lsp.util.make_position_params
			vim.lsp.util.make_position_params = function(_, encoding)
				encoding = "utf-16" -- Force utf-16 for rust-analyzer
				return original_make_position_params(_, encoding)
			end
		end

		-- Rustaceanvim setup
		vim.g.rustaceanvim = {
			server = {
				on_attach = on_attach,
			},
			dap = {
				adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
			},
		}

		-- DAP configuration for Rust
		dap.configurations.rust = {
			{
				name = "Debug Rust Program",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
			{
				name = "Attach to Running Rust Process",
				type = "codelldb",
				request = "attach",
				pid = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}

		-- Keybindings for Rust and Debugging
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Cargo commands
		keymap("n", "<leader>rr", ":!cargo run<CR>", opts) -- Run cargo
		keymap("n", "<leader>rb", ":!cargo build<CR>", opts) -- Build with cargo
		keymap("n", "<leader>rt", ":!cargo test<CR>", opts) -- Run tests

		-- Debugging commands
		keymap("n", "<leader>dd", ":RustLsp debug<CR>", opts) -- Start Debugger
		keymap("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, opts) -- Toggle breakpoint
		keymap("n", "<leader>dc", function()
			dap.continue()
		end, opts) -- Continue execution
		keymap("n", "<leader>ds", function()
			dap.step_over()
		end, opts) -- Step over
		keymap("n", "<leader>di", function()
			dap.step_into()
		end, opts) -- Step into
		keymap("n", "<leader>do", function()
			dap.step_out()
		end, opts) -- Step out
		keymap("n", "<leader>dq", function()
			dap.terminate()
		end, opts) -- Quit Debugger

		-- DAP UI toggle
		keymap("n", "<leader>du", function()
			require("dapui").toggle()
		end, opts) -- Toggle DAP UI
	end,
}

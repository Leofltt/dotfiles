-- Debugging (DAP): LLDB (codelldb + Apple Xcode lldb-dap) and Python (debugpy)

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "mason-org/mason.nvim" },
				opts = {
					ensure_installed = { "codelldb", "python" },
					automatic_installation = true,
					handlers = {},
				},
			},
		},
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start / Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					local cond = vim.fn.input("Breakpoint condition: ")
					if cond ~= "" then
						require("dap").set_breakpoint(cond)
					end
				end,
				desc = "Conditional Breakpoint",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle LLDB/DAP REPL",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "v" },
				desc = "Eval expression",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Stack Frame Up",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Stack Frame Down",
			},
			{
				"<leader>dw",
				function()
					local expr = vim.fn.expand("<cword>")
					if expr == "" then
						expr = vim.fn.input("Watch expression: ")
					end
					if expr ~= "" then
						require("dapui").elements.watches.add(expr)
					end
				end,
				desc = "Watch Word Under Cursor",
			},
			{
				"<leader>dx",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "Clear All Breakpoints",
			},
			{
				"<leader>dL",
				function()
					local msg = vim.fn.input("Log point message: ")
					if msg ~= "" then
						require("dap").set_breakpoint(nil, nil, msg)
					end
				end,
				desc = "Logpoint",
			},
			{ "<leader>dn", "<Cmd>DapNew<CR>", desc = "New Debug Session" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				element_mappings = {
					stacks = {
						open = "<CR>",
						expand = "o",
					},
					breakpoints = {
						open = "<CR>",
						expand = "o",
					},
				},
			})

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end

			-- Resolve Apple Xcode's native lldb-dap on macOS
			local lldb_dap_cmd = vim.fn.exepath("lldb-dap")
			if lldb_dap_cmd == "" then
				for _, candidate in ipairs({
					"/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap",
					"/Library/Developer/CommandLineTools/usr/bin/lldb-dap",
				}) do
					if vim.fn.executable(candidate) == 1 then
						lldb_dap_cmd = candidate
						break
					end
				end
			end

			if lldb_dap_cmd ~= "" then
				dap.adapters.lldb = {
					type = "executable",
					command = lldb_dap_cmd,
					name = "lldb",
				}
			end

			-- Resolve Mason's codelldb (fallback to PATH)
			local mason_codelldb = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
			local codelldb_cmd = vim.fn.executable(mason_codelldb) == 1 and mason_codelldb or vim.fn.exepath("codelldb")
			if codelldb_cmd ~= "" then
				dap.adapters.codelldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = codelldb_cmd,
						args = { "--port", "${port}" },
					},
				}
			end

			local function pick_executable()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end

			dap.configurations.cpp = {
				{
					name = "Launch executable (codelldb)",
					type = "codelldb",
					request = "launch",
					program = pick_executable,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Launch executable (Apple lldb-dap)",
					type = "lldb",
					request = "launch",
					program = pick_executable,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				{
					name = "Attach to process (codelldb)",
					type = "codelldb",
					request = "attach",
					pid = function()
						return require("dap.utils").pick_process()
					end,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Attach to application (codelldb)",
					type = "codelldb",
					request = "attach",
					pid = function()
						return require("dap.utils").pick_process({
							filter = function(proc)
								return vim.startswith(proc.name, "/Applications")
							end,
						})
					end,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
		end,
	},
}

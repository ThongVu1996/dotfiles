return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Debug UI
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",

		-- Debug Adapters
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Debuggers
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_python = require("dap-python")

		dapui.setup()

		require("nvim-dap-virtual-text").setup({
			commented = true,
		})

		require("mason-nvim-dap").setup({
			automatic_setup = true,
			automatic_installation = true,
			ensure_installed = {
				"debugpy", -- Python
			},
		})

		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Breakpoint" })
		vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

		--Signal
		vim.fn.sign_define("DapBreakpoint", {
			text = "",
			texthl = "DiagnosticSignError",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapBreakpointCondition", {
			text = "🔶",
			texthl = "DiagnosticSignWarn",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapLogPoint", {
			text = "📝",
			texthl = "DiagnosticSignInfo",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapBreakpointRejected", {
			text = "", -- or "❌"
			texthl = "DiagnosticSignError",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapStopped", {
			text = "", -- or "→"
			texthl = "DiagnosticSignWarn",
			linehl = "Visual",
			numhl = "DiagnosticSignWarn",
		})

		-- Automatically open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		dap_python.setup("python")
		dap.adapters.python = {
			type = "server",
			host = "127.0.0.1",
			port = 5678,
		}

		table.insert(dap.configurations.python, {
			type = "python",
			request = "attach",
			name = "Attach to FastAPI",
			connect = {
				host = "127.0.0.1",
				port = 5678,
			},
			justMyCode = false,
		})
	end,
}

return {
	"folke/trouble.nvim",
	opts = {
		modes = {
			diagnostics = {
				mode = "document_diagnostics",
				preview = {
					type = "split",
					relative = "win",
					position = "right",
					size = 0.4,
				},
			},
		},
		icons = {
			error = " ",
			warning = " ",
			hint = " ",
			information = " ",
		},
		use_diagnostic_signs = true, -- Use Neovim's built-in diagnostic signs
		action_keys = {
			preview = "p",
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>dl",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Project Diagnostics (Snacks)",
		},
		{
			"<leader>db",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics (Snacks)",
		},
		{
			"<leader>dc",
			function()
				local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
				if #diagnostics > 0 then
					local message = diagnostics[1].message
					vim.fn.setreg("+", message)
					print("Copied diagnostic: " .. message)
				else
					print("No diagnostic at cursor")
				end
			end,
			{ noremap = true, silent = true },
			desc = "Copy diagnostic to clipboard",
		},
		{
			"<leader>dn",
			vim.diagnostic.goto_next,
			desc = "Next diagnostic",
		},
		{
			"<leader>dp",
			vim.diagnostic.goto_prev,
			desc = "Prev diagnostic",
		},
	},
}

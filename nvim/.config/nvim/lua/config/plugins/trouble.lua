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
		-- Preview
		action_keys = {
			preview = "p",
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>dl",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Project Diagnostics",
		},
		{
			"<leader>db",
			"<cmd>Trouble diagnostics lter.buf=0<cr>",
			desc = "Buffer Diagnostics",
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

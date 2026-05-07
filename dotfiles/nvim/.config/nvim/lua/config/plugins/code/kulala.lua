return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	keys = {
		-- Navigation (Optimized for home row)
		{ "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
		{ "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request" },

		-- Execution
		{ "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run current request" },
		{ "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Run all requests in file" },
		{ "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle between Body and Headers" },

		-- Utilities
		{ "<leader>re", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Select environment" },
		{ "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy request as cURL" },
		{ "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect current request" },
	},
	opts = {},
	config = function(_, opts)
		-- Initialize the plugin with options
		require("kulala").setup(opts)

		-- Enable relative numbers for Kulala UI by targeting the specific Window ID
		vim.api.nvim_create_autocmd("BufWinEnter", {
			pattern = "*",
			callback = function(args)
				-- Check if the current buffer is the Kulala UI
				if vim.bo[args.buf].filetype == "json.kulala_ui" then
					-- Defer execution to ensure Kulala has finished rendering its UI
					vim.schedule(function()
						-- Get the exact Window ID of the Kulala buffer
						local win_id = vim.fn.bufwinid(args.buf)

						-- If the window is valid, force enable absolute and relative numbers
						if win_id ~= -1 then
							vim.wo[win_id].number = true
							vim.wo[win_id].relativenumber = true
						end
					end)
				end
			end,
		})
	end,
}

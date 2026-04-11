return {
	"smjonas/inc-rename.nvim",
	event = "BufReadPre",
	lazy = true,
	enabled = false,
	config = function()
		require("inc_rename").setup({
			cmd_name = "IncRename", -- The command name for renaming
			hl_group = "Substitute", -- Highlight group used during renaming
			show_message = true, -- Show notification after rename
			input_buffer_type = nil, -- Input buffer type (nil = default mini buffer)
		})

		-- Short-key for IncRename
		vim.api.nvim_set_keymap(
			"n",
			"<leader>rr",
			":IncRename ",
			{ noremap = true, silent = false, desc = "Rename variable" }
		)
	end,
}

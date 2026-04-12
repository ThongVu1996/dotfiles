return {
	"smjonas/inc-rename.nvim",
	event = "BufReadPost", -- Load after buffer is read for better stability
	lazy = true,
	enabled = false, -- ENABLED now!
	config = function()
		require("inc_rename").setup({
			cmd_name = "IncRename", -- The command name for renaming
			hl_group = "Substitute", -- Highlight group used during renaming
			show_message = true, -- Show notification after rename
			input_buffer_type = nil, -- Input buffer type (nil = default mini buffer)
		})
	end,
	keys = {
		{
			"<leader>rn",
			":IncRename ",
			desc = "LSP Incremental Rename",
		},
	},
}

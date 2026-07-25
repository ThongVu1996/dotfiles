return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- Lazy load the plugin only when these commands are called to optimize startup time
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},

	keys = {
		-- Open Diffview to review uncommitted changes (Working tree vs HEAD)
		{ "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },

		-- Close Diffview and restore the previous Neovim workspace layout
		{ "<leader>dx", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },

		-- Toggle the visibility of the file panel (the left sidebar)
		{ "<leader>dt", "<cmd>DiffviewToggleFiles<cr>", desc = "Diffview Toggle Files Panel" },

		-- Move the cursor focus directly to the file panel
		{ "<leader>df", "<cmd>DiffviewFocusFiles<cr>", desc = "Diffview Focus Files Panel" },

		-- View the Git history (commits) for the current active file
		{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview History (Current File)" },

		-- View the Git history for the entire project
		{ "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview History (Project)" },
	},

	-- Convert opts to a function so we can safely require the Diffview actions module
	opts = function()
		local actions = require("diffview.actions")

		return {
			-- Enhance highlight groups for better visibility with themes like Tokyo Night or Catppuccin
			enhanced_diff_hl = true,

			view = {
				-- Default layout for viewing file diffs (split horizontally)
				default = {
					layout = "diff2_horizontal",
				},
				-- Layout optimized for resolving merge conflicts
				merge_tool = {
					layout = "diff3_mixed",
					-- Disable LSP diagnostics to reduce visual noise during merge resolution
					disable_diagnostics = true,
				},
			},

			-- Configuration for the file list panel
			file_panel = {
				-- Display files in a hierarchical directory tree instead of a flat list
				listing_style = "tree",
				win_config = {
					position = "left", -- Position the panel on the left side
					width = 35, -- Set the panel width
				},
			},

			-- Override internal keymaps for Diffview panels
			keymaps = {
				file_panel = {
					-- When pressing 'j': Move to the next file AND open its diff immediately (auto-preview)
					{ "n", "j", actions.select_next_entry, { desc = "Open diff for next file" } },

					-- When pressing 'k': Move to the previous file AND open its diff immediately (auto-preview)
					{ "n", "k", actions.select_prev_entry, { desc = "Open diff for previous file" } },
				},
			},
		}
	end,
}

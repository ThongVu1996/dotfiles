return {
	"catppuccin/nvim",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			transparent_background = true, -- disables setting the background color.
			float = {
				transparent = true,
				solid = false,
			},
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
			},
		})
		vim.cmd.colorscheme("catppuccin")
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FAB387", bold = true }) -- color current number column
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#A0A0A0", bg = "none" }) -- color default number column
	end,
}

return {
	{
		"HakonHarnes/img-clip.nvim",
		ft = { "markdown", "tex", "html" },
		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = true,
				drag_and_drop = { insert_mode = true },
				dir_path = vim.fn.expand("%:p:h"),
			},
		},
		keys = {
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image" },
		},
	},
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "html", "tex" },
		keys = {
			{ "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Toggle markview" },
		},
		opts = {
			markdown = { images = { enabled = false } },
			preview = {
				icon_provider = "internal",
				modes = { "n", "no", "c", "i" },
				hybrid_modes = { "i" },
				callbacks = {
					on_enable = function(_, win)
						vim.wo[win].conceallevel = 2
						vim.wo[win].concealcursor = "nc"
					end,
				},
			},
		},
	},
}

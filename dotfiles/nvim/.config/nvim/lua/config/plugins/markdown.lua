return {
	-- 1. Clipboard Image Paste Plugin
	{
		"HakonHarnes/img-clip.nvim",
		-- Load when opening Markdown, LaTeX or HTML
		ft = { "markdown", "tex", "html" },

		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = true,
				show_dir_path_in_prompt = true,
				drag_and_drop = { insert_mode = true },
				-- Save images in the same directory as the current file
				dir_path = vim.fn.expand("%:p:h"),
			},
		},
		keys = {
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
		},
	},

	-- 2. Markdown Aesthetics Plugin (Render Text, Tables, Icons)
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "html", "tex" },

		keys = {
			{ "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Toggle markdown view" },
		},

		opts = {
			-- [IMPORTANT] Disable Markview's text-based image rendering
			-- to allow WezTerm to display high-fidelity original images.
			markdown = {
				images = {
					enabled = false,
				},
			},
			preview = {
				icon_provider = "internal",
				modes = { "n", "no", "c", "i" }, -- Active in both Normal and Insert modes
				hybrid_modes = { "i" }, -- Hybrid mode for Insert
				callbacks = {
					on_enable = function(_, win)
						vim.wo[win].conceallevel = 2
						vim.wo[win].concealcursor = "nc"
					end,
					on_mode_change = function(_, win, mode)
						if vim.tbl_contains({ "i" }, mode) then
							-- In Insert mode: Show raw text for easier editing
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = ""
						else
							-- On exit Insert: Hide extra characters for aesthetics
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = "nc"
						end
					end,
				},
			},
		},
	},
}

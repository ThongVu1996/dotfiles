return {
	-- 1. Plugin hiển thị ảnh (Render Image)
	{
		"3rd/image.nvim",
		-- CHỈ LOAD KHI MỞ FILE MARKDOWN HOẶC VIMWIKI
		ft = { "markdown", "vimwiki" },

		build = false,
		opts = {
			backend = "Kitty",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" },
				},
				neorg = { enabled = true },
			},
			max_width = 100,
			max_height = 12,
			max_width_window_percentage = 50,
			window_overlap_clear_enabled = true,
		},
	},

	-- 2. Plugin Paste ảnh từ Clipboard
	{
		"HakonHarnes/img-clip.nvim",
		-- LOAD KHI MỞ MARKDOWN, TEX (LATEX) HOẶC HTML ĐỂ PASTE ẢNH
		ft = { "markdown", "tex", "html" },

		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = true,
				show_dir_path_in_prompt = true,
				drag_and_drop = { insert_mode = true },
				dir_path = vim.fn.expand("%:p:h"),
			},
		},
		keys = {
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
		},
	},

	-- 3. Create table of content
	-- {
	-- 	"mzlogin/vim-markdown-toc",
	-- 	-- ĐÃ CHUẨN: CHỈ LOAD KHI FILE LÀ MARKDOWN
	-- 	ft = { "markdown" },
	--
	-- 	cmd = { "GenTocGFM", "GenTocRedcarpet", "GenTocGitLab", "GenTocMarkDown" },
	-- 	keys = {
	-- 		{
	-- 			"<leader>mt",
	-- 			"<cmd>GenTocGFM<cr>",
	-- 			desc = "Generate Markdown TOC",
	-- 			ft = "markdown",
	-- 		},
	-- 	},
	-- },

	-- 4. Plugin làm đẹp Markdown (Render Text)
	{
		"OXY2DEV/markview.nvim",
		-- QUAN TRỌNG: Bỏ 'lazy = false' và thay bằng 'ft'
		-- Load khi mở Markdown, HTML, hoặc LaTeX (tex)
		ft = { "markdown", "html", "tex" },

		keys = {
			{ "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Toggle markdown view" },
		},

		-- Cấu hình hybrid_modes (giữ hiển thị text gốc khi gõ ở dòng hiện tại)
		opts = {
			preview = {
				icon_provider = "mini",
				modes = { "n", "no", "c", "i" }, -- Giữ bật trong Insert mode
				hybrid_modes = { "i" }, -- Insert mode là hybrid
				callbacks = {
					on_enable = function(_, win)
						vim.wo[win].conceallevel = 2
						vim.wo[win].concealcursor = "nc"
					end,
					on_mode_change = function(_, win, mode)
						if vim.tbl_contains({ "i" }, mode) then
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = "" -- Hiện text gốc khi ở Insert mode
						else
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = "nc"
						end
					end,
				},
			},
		},
	},
	-- {
	-- 	"MeanderingProgrammer/render-markdown.nvim",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	ft = { "markdown" },
	-- 	opts = {
	-- 		code = {
	-- 			width = "block",
	-- 			right_pad = 1,
	-- 		},
	-- 	},
	-- 	keys = {
	-- 		{ "<leader>mp", "<cmd>RenderMarkdown preview<cr>", desc = "Toggle markdown preview" },
	-- 	},
	-- },
	-- 5. Gen TOC
}

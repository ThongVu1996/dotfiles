return {
	-- 1. Plugin Paste ảnh từ Clipboard
	{
		"HakonHarnes/img-clip.nvim",
		-- Load khi mở Markdown, LaTeX hoặc HTML
		ft = { "markdown", "tex", "html" },

		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = true,
				show_dir_path_in_prompt = true,
				drag_and_drop = { insert_mode = true },
				-- Lưu ảnh vào cùng thư mục với file hiện tại
				dir_path = vim.fn.expand("%:p:h"),
			},
		},
		keys = {
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
		},
	},

	-- 2. Plugin làm đẹp Markdown (Render Text, Tables, Icons)
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "html", "tex" },

		keys = {
			{ "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Toggle markdown view" },
		},

		opts = {
			-- [QUAN TRỌNG] Tắt tính năng hiển thị ảnh dạng text của Markview
			-- để nhường chỗ cho WezTerm hiển thị ảnh gốc sắc nét.
			markdown = {
				images = {
					enabled = false,
				},
			},
			preview = {
				icon_provider = "internal",
				modes = { "n", "no", "c", "i" }, -- Hoạt động cả trong Insert mode
				hybrid_modes = { "i" }, -- Chế độ lai cho Insert mode
				callbacks = {
					on_enable = function(_, win)
						vim.wo[win].conceallevel = 2
						vim.wo[win].concealcursor = "nc"
					end,
					on_mode_change = function(_, win, mode)
						if vim.tbl_contains({ "i" }, mode) then
							-- Khi gõ (Insert), hiện text gốc để dễ sửa
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = ""
						else
							-- Khi thoát Insert, ẩn các ký tự thừa đi cho đẹp
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = "nc"
						end
					end,
				},
			},
		},
	},
}

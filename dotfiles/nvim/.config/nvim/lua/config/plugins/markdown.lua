return {
	-- 1. Plugin hiển thị ảnh (Render Image)
	{
		"3rd/image.nvim",
		build = false, -- Sửa lỗi build trên một số máy
		opts = {
			backend = "Kitty", -- Thay bằng "ueberzug" hoặc "iTerm2" nếu không dùng Kitty
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false, -- Giữ ảnh luôn hiện kể cả khi đang gõ
					download_remote_images = true, -- Tải ảnh online về hiển thị luôn
					only_render_image_at_cursor = false, -- Hiển thị tất cả ảnh
					filetypes = { "markdown", "vimwiki" },
				},
				neorg = { enabled = true },
			},
			max_width = 100, -- Giới hạn chiều rộng ảnh cho đỡ vỡ layout
			max_height = 12, -- Giới hạn chiều cao
			max_width_window_percentage = 50, -- Tối đa 50% màn hình
			window_overlap_clear_enabled = true,
		},
	},

	-- 2. Plugin Paste ảnh từ Clipboard
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = false,
				drag_and_drop = { insert_mode = true },
				dir_path = "Downloads/images", -- Tự động lưu ảnh vào thư mục này
			},
		},
		keys = {
			-- Phím tắt: Leader + p để paste ảnh
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
		},
	},

	-- 3. Plugin làm đẹp Markdown (Render Text)
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown" },
		opts = {
			code = {
				width = "block",
				right_pad = 1,
			},
		},
	},
}

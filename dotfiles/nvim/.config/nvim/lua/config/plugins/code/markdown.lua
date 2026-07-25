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
	-- {
	-- 	"OXY2DEV/markview.nvim",
	-- 	ft = { "markdown", "html", "tex" },
	-- 	keys = {
	-- 		{ "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Toggle markview" },
	-- 	},
	-- 	opts = {
	-- 		markdown = { images = { enabled = false } },
	-- 		preview = {
	-- 			icon_provider = "internal",
	-- 			modes = { "n", "no", "c", "i" },
	-- 			hybrid_modes = { "i" },
	-- 			callbacks = {
	-- 				on_enable = function(_, win)
	-- 					vim.wo[win].conceallevel = 2
	-- 					vim.wo[win].concealcursor = "nc"
	-- 				end,
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- render-markdown phụ thuộc vào treesitter và devicons
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		ft = { "markdown", "norg", "rmd", "org", "latex", "tex" }, -- render-markdown hỗ trợ tốt các file này
		keys = {
			-- Lệnh toggle sẽ bật/tắt hiển thị ngay trong buffer hiện tại
			{ "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render Markdown" },
		},
		opts = {
			-- Render-markdown không render ảnh thật (phải dùng kèm image.nvim),
			-- nên không cần cờ tắt ảnh.

			-- Cấu hình thay thế cho `hybrid_modes`:
			-- Tính năng anti-conceal giúp khi con trỏ nhảy vào dòng nào,
			-- dòng đó sẽ hiện lại syntax markdown gốc để bạn dễ edit.
			anti_conceal = {
				enabled = true,
				ignore = {
					code_background = true,
				},
			},

			-- Cấu hình thay thế cho callbacks on_enable (tự set conceallevel):
			-- render-markdown mặc định đã tự động quản lý conceallevel = 2 cho bạn
			-- khi nó được bật, nên không cần viết callback thủ công.
		},
	},
}

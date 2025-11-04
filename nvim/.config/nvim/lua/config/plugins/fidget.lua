return {
	"j-hui/fidget.nvim",
	event = "VeryLazy", -- Chỉ tải khi LSP khởi động
	opts = {
		notification = {
			window = {
				winblend = 0, -- Tắt độ trong suốt (giống trong ảnh)
				border = "none", -- Tắt viền
			},
		},
	},
}

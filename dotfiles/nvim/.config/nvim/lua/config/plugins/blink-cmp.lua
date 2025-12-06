return {
	"saghen/blink.cmp",
	event = { "LspAttach" },
	dependencies = "rafamadriz/friendly-snippets",
	version = "v0.*",
	opts = {
		keymap = {
			-- ["<S-Tab>"] = { "select_prev", "fallback" },
			-- ["<Tab>"] = { "select_next", "fallback" },

			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "snippets", "lsp", "path", "buffer" },
		},
		signature = { enabled = true },
		completion = {
			documentation = {
				-- 1. Tự động hiển thị màn hình phụ (True = Bật)
				auto_show = true,

				-- 2. Thời gian chờ (Delay) trước khi hiện (ms)
				-- Để 0 thì hiện ngay lập tức, để 200 cho đỡ nháy mắt khi lướt nhanh
				auto_show_delay_ms = 200,

				-- 3. Cấu hình giao diện cửa sổ
				window = {
					border = "rounded", -- Viền bo tròn cho đẹp (hoặc "single", "double")
				},
			},

			-- (Tùy chọn) Cấu hình menu danh sách cho gọn đẹp hơn
			menu = {
				border = "rounded",
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
		},
	},
}

local blink = require("blink.cmp")

return {
	-- 1. Lệnh chạy server
	cmd = { "tailwindcss-language-server", "--stdio" },

	-- 2. Hỗ trợ tất cả file Frontend (Có thêm Blade cho PHP)
	filetypes = {
		"javascript", "javascriptreact", "typescript", "typescriptreact",
		"vue", "svelte", "html", "blade", "css", "scss", "less", "postcss"
	},

	-- 3. Cấu hình chuyên sâu cho Tailwind
	settings = {
		tailwindCSS = {
			-- Hiện bảng màu sắc trực tiếp khi di chuột qua class
			hovers = true,
			-- Gợi ý class cực mạnh kèm ô vuông màu sắc
			suggestions = true,
			-- Tự động hoàn thành mã màu (ví dụ: text-sky-500)
			colorDecorators = true,
			-- Linting cho các class (Báo gạch chân nếu bạn gõ class sai cách)
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
			-- Tự động sắp xếp class (Ưu tiên dùng Prettier plugin, nhưng ở đây bật để gợi ý tốt hơn)
			validate = true,
		},
	},

	-- 4. Capabilities (Blink.cmp support)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}

local blink = require("blink.cmp")

return {
	-- 1. Lệnh chạy server
	cmd = { "vscode-html-language-server", "--stdio" },

	-- 2. Chỉ chạy trên HTML thuần và Template (Tránh chạy trên JS/TS gây trùng lặp với vtsls)
	filetypes = { "html", "blade", "svelte" },

	-- 3. Cấu hình capabilities cho HTML
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = false, -- Để Prettier (Conform) lo phần format
	},

	-- 4. Capabilities (Blink.cmp support)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}

local blink = require("blink.cmp")

return {
	-- 1. Lệnh chạy server (Rust-based, cực nhanh)
	cmd = { "markdown-oxide" },

	-- 2. Các loại file hỗ trợ
	filetypes = { "markdown", "markdown.mdx" },

	-- 3. Root markers
	root_markers = { ".git", ".markdown-oxide.toml" },

	-- 4. Capabilities (Blink.cmp + Native LSP)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),

	-- 5. Cấu hình đặc thù cho Oxide (Nếu cần)
	settings = {
		["markdown-oxide"] = {
			-- Hỗ trợ wiki-links giống Obsidian
			wiki_links = {
				enable = true,
			},
		},
	},
}

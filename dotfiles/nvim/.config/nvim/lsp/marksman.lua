local blink = require("blink.cmp")

return {
	-- 1. Lệnh chạy server (Đảm bảo đã cài: :MasonInstall marksman)
	cmd = { "marksman", "server" },

	-- 2. Các loại file hỗ trợ
	filetypes = { "markdown", "markdown.mdx" },

	-- 3. Xác định root: Marksman hoạt động tốt với .git hoặc file cấu hình riêng
	-- Nếu không tìm thấy, nó vẫn chạy tốt ở chế độ single-file
	root_markers = { ".git", ".marksman.toml" },

	-- 4. Capabilities: Kết hợp Blink + LSP chuẩn
	-- Marksman không yêu cầu cấu hình workspace phức tạp như Oxide
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}

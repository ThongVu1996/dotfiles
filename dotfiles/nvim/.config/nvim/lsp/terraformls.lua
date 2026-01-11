-- local blink = require("blink.cmp")
--
-- return {
-- 	cmd = { "terraform-ls", "serve" },
-- 	filetypes = { "terraform", "terraform-vars", "hcl" },
-- 	root_markers = { ".terraform", ".git" },
-- 	init_options = {},
-- 	settings = {},
-- 	on_attach = function(client, bufnr)
-- 		-- QUAN TRỌNG: Tắt format của LSP để nhường quyền cho Conform
-- 		-- Nếu không tắt, nó sẽ đánh nhau với terraform_fmt trong conform
-- 		client.server_capabilities.documentFormattingProvider = false
-- 		client.server_capabilities.documentRangeFormattingProvider = false
-- 	end,
-- 	capabilities = vim.tbl_deep_extend(
-- 		"force",
-- 		{},
-- 		vim.lsp.protocol.make_client_capabilities(),
-- 		blink.get_lsp_capabilities()
-- 	),
-- }
--

local blink = require("blink.cmp")

return {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "terraform-vars", "hcl" },
	root_markers = { ".terraform", ".git" },

	-- === SỬA TẠI ĐÂY ===
	-- Dùng vim.empty_dict() để gửi "{}" (Map) thay vì "[]" (Slice).
	-- Không cần set path, để server tự tìm terraform trong hệ thống.
	init_options = vim.empty_dict(),
	settings = vim.empty_dict(),
	-- ===================

	on_attach = function(client, bufnr)
		-- Tắt format của LSP để nhường cho Conform (như bạn đã config)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}

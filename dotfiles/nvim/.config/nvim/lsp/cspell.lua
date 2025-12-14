local blink = require("blink.cmp")

return {
	cmd = { "cspell-lsp", "--stdio" },

	filetypes = {
		"lua",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"rust",
		"go",
		"python",
		"php",
		"html",
		"css",
		"json",
		"markdown",
		"text",
		"gitcommit",
	},

	-- Thêm .cspell.json vào để nó nhận diện root dự án tốt hơn
	root_markers = { "cspell.json", ".cspell.json", "package.json", ".git" },

	-- Cấu hình riêng cho cSpell
	settings = {
		cSpell = {
			enabled = true,
			checkOnlyEnabledFileTypes = false,
			-- Nếu bạn muốn load thêm 1 file config global (tùy chọn)
			-- import = { vim.fn.expand("~/.config/cspell/cspell.json") },
		},
	},

	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}

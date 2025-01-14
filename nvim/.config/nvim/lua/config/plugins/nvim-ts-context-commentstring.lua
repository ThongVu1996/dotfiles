return {
	-- Detect context to comment
	"JoosepAlviste/nvim-ts-context-commentstring",
	event = { "BufReadPre", "BufNewFile" },
	-- lazy = true,
	opts = {
		enable_autocmd = false,
	},

	-- config = function()
	-- 	vim.g.skip_ts_context_commentstring_module = true
	-- 	require("ts_context_commentstring").setup({
	-- 		enable_autocmd = false,
	-- 		languages = {
	-- 			typescript = "// %s", -- Single-line comments for TypeScript
	-- 			html = "<!-- %s -->", -- HTML comments
	-- 			javascript = "// %s", -- Single-line comments for JavaScript
	-- 			vue = {
	-- 				__default = "// %s", -- Default for Vue (e.g., script, style sections)
	-- 				template = "<!-- %s -->", -- HTML-like comments in Vue templates
	-- 			},
	-- 			php = {
	-- 				__default = "// %s", -- Default single-line comments for PHP
	-- 				__multiline = "/* %s */", -- Block comments for PHP
	-- 				doc = "/** %s */", -- PHPDoc-style comments
	-- 			},
	-- 			javascriptreact = {
	-- 				__default = "// %s", -- Default for React (JSX/TSX)
	-- 				jsx_element = "{/* %s */}", -- JSX element comments
	-- 				jsx_fragment = "{/* %s */}", -- JSX fragment comments
	-- 				jsx_attribute = "// %s", -- Comments within JSX attributes
	-- 			},
	-- 			typescriptreact = {
	-- 				__default = "// %s", -- Default for React (TSX)
	-- 				jsx_element = "{/* %s */}", -- JSX element comments
	-- 				jsx_fragment = "{/* %s */}", -- JSX fragment comments
	-- 				jsx_attribute = "// %s", -- Comments within JSX attributes
	-- 			},
	-- 		},
	-- 	})
	-- end,
}

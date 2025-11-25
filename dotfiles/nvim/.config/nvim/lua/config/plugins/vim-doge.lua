return {
	"kkoomen/vim-doge",
	-- lazy = false,
	event = "FileType php",
	-- :call doge#install() - run add the first time
	config = function()
		vim.g.doge_doc_standard_php = "phpdoc" -- Set the PHPDoc style
		vim.g.doge_php_settings = {
			resolve_fqn = 0, -- Enable resolving fully qualified names
		}
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nd",
			":DogeGenerate<CR>",
			{ noremap = true, silent = true, desc = "Run DogeGenerate" }
		)
	end,
}

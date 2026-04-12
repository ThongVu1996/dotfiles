return {
	"kkoomen/vim-doge",
	event = { "FileType" },
	build = ":call doge#install()",
	config = function()
		vim.g.doge_doc_standard_php = "phpdoc"
		vim.g.doge_php_settings = { resolve_fqn = 0 }
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nd",
			":DogeGenerate<CR>",
			{ noremap = true, silent = true, desc = "Run DogeGenerate" }
		)
	end,
}

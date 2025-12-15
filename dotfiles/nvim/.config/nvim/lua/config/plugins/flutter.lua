return {
	"akinsho/flutter-tools.nvim",
	-- dependencies = {
	--   "dart-lang/dart-vim-plugin",
	--   -- "reisub0/hot-reload.vim"
	-- },
	lazy = true, -- Lazy load only when a Dart project is detected
	event = { "BufReadPre", "BufNewFile" }, -- Load only when opening a Dart file
	config = function()
		require("flutter-tools").setup({
			widget_guides = {
				enabled = true,
			},
			lsp = {
				color = {
					enabled = true,
					background = true,
				},
			},
		})

		-- Set indentation to 4 spaces for Dart/Flutter files
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = "dart",
		-- 	callback = function()
		-- 		vim.opt_local.tabstop = 4
		-- 		vim.opt_local.shiftwidth = 4
		-- 		vim.opt_local.expandtab = true
		-- 	end,
		-- })

		vim.api.nvim_set_keymap(
			"n",
			"<leader>fo",
			":FlutterOutlineToggle<CR>",
			{ noremap = true, silent = true, desc = "Toggle Flutter Outline" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>fl",
			":FlutterLogToggle<CR>",
			{ noremap = true, silent = true, desc = "Toggle Flutter Log" }
		)
	end,
}

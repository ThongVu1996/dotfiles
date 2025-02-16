return {
	"akinsho/flutter-tools.nvim",
	dependencies = {
		"dart-lang/dart-vim-plugin",
		-- "reisub0/hot-reload.vim"
	},
	lazy = true, -- Lazy load only when a Dart project is detected
	cond = function()
		-- Check if any Dart file exists in the project directory
		local dart_files = vim.fn.globpath(vim.fn.getcwd(), "**/*.dart", true)
		return #dart_files > 0
	end,
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

		vim.keymap.set(
			"n",
			"<leader>fF",
			require("flutter_snack_picker").flutter_snack_picker,
			{ noremap = true, silent = true, desc = "Flutter Tools with Snack" }
		)
	end,
}

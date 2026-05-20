return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			keymaps = {
				replace = { n = "<leader>rl" },
				syncAll = { n = "<leader>ra" },
				q = { n = "q" },
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function()
				vim.keymap.set("n", "q", "<Cmd>bd!<CR>", { buffer = true })
			end,
		})

		vim.api.nvim_create_autocmd('FileType', {
			group = vim.api.nvim_create_augroup('grug-far-auto-sync', { clear = true }),
			pattern = { 'grug-far' },
			callback = function(event)
				local bufnr = event.buf

				-- Listen to cursor movement events only within this specific grug-far buffer
				vim.api.nvim_create_autocmd('CursorMoved', {
				buffer = bufnr,
				callback = function()
					-- 1. Save the current grug-far window ID where the user is navigating
					local grug_win = vim.api.nvim_get_current_win()
					
					local inst = require('grug-far').get_instance(bufnr)
					
					-- Safely execute location preview to avoid crashes in non-result areas
					pcall(function()
					-- 2. Open the file and line corresponding to the current search result
					-- Note: This action temporarily shifts Neovim's focus to the code window
					inst:open_location()
					
					-- 3. Forcefully restore focus back to the grug-far window
					vim.api.nvim_set_current_win(grug_win)
					end)
				end,
				})
			end,
		})
	end,
	keys = {
		{
			"<leader>ro",
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace",
		},
		{
			"<leader>rs",
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					engine = "astgrep",
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace (AST)",
		},
	},
}

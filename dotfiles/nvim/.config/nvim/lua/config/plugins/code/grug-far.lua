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

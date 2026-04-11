return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			-- 1. Explicit keymaps within Grug-far
			keymaps = {
				replace = { n = ",r" },
				syncAll = { n = ",s" },
				q = { n = "q" }, -- Use 'q' to quit easily
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function()
				-- Removed old Esc mapping.
				-- Use 'q' in Normal mode to close the window.
				vim.keymap.set("n", "q", "<Cmd>bd!<CR>", { buffer = true })
			end,
		})
	end,
	keys = {
		{
			"<leader>sr",
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
	},
}

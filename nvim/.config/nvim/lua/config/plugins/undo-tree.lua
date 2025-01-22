return {
	"mbbill/undotree",
	keys = { "<leader>ud", "<leader>uf" },
	config = function()
		vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
		vim.keymap.set("n", "<leader>uf", vim.cmd.UndotreeFocus, { desc = "Focus UndoTree" })
	end,
}

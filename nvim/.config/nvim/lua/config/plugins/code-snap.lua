return {
	"mistricky/codesnap.nvim",
	build = "make build_generator",
	config = function()
		require("codesnap").setup({
			save_path = "~/Pictures", -- Change to desired directory
			has_breadcrumbs = true, -- Show breadcrumbs
			bg_theme = "bamboo", -- Background theme (bamboo, nord, etc.)
		})
	end,
	keys = {
		{ "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
		{ "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
	},
}

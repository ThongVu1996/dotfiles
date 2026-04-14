return {
	"ThongVu1996/simple-virtcolumn.nvim",
	event = "UIEnter",
	opts = {
		symbol = "┆",
		column = 80,
	},
	config = function(_, opts)
		require("simple-virtcolumn").setup(opts)
	end,
}

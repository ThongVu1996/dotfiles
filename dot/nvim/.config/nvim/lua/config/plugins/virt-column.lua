return {
	"lukas-reineke/virt-column.nvim",
	event = { "BufRead", "BufNewFile" },
	opts = {
		char = { "┆" },
		virtcolumn = "120",
		highlight = { "NonText" },
	},
}

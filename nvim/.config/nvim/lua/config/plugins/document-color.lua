return {
	"mrshmllow/document-color.nvim",
	lazy = true,
	event = { "BufReadPre" },
	config = function()
		require("document-color").setup({
			mode = "background",
		})
	end,
}

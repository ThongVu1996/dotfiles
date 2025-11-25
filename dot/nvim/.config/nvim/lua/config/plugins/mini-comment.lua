return {
	"echasnovski/mini.comment",
	keys = { "gc", "gb", "gcb", "gcO", "gco", "gcA" },
	opts = {
		options = {
			custom_commentstring = function()
				return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
			end,
		},
	},
}

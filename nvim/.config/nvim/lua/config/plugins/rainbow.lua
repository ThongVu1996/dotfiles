return {
	"HiPhish/rainbow-delimiters.nvim",
	event = "VeryLazy",
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
				vim = rainbow_delimiters.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
			},
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		}

		vim.cmd([[
            highlight RainbowDelimiterRed guifg=#E06C75
            highlight RainbowDelimiterYellow guifg=#E5C07B
            highlight RainbowDelimiterBlue guifg=#61AFEF
            highlight RainbowDelimiterOrange guifg=#D19A66
            highlight RainbowDelimiterGreen guifg=#98C379
            highlight RainbowDelimiterViolet guifg=#C678DD
            highlight RainbowDelimiterCyan guifg=#56B6C2
        ]])
	end,
}

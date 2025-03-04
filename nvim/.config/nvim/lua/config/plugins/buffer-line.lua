return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy", -- Load when Vim is idle
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs", -- Don't show number at the end
				numbers = "none", -- Hide buffer numbers
				show_buffer_close_icons = false, -- Remove close icons
				show_close_icon = false, -- Remove global close icon
				indicator = { style = "none" }, -- Remove final indicators (like numbers)
				separator_style = "thin", -- Nice looking separator
				always_show_bufferline = false, -- Show only when two or more buffers exist
			},
		})

		-- Key mappings for switching buffers
		local map = vim.keymap.set
		map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true, desc = "Previous Buffer" })
	end,
}

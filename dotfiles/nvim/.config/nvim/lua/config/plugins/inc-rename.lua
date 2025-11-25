return {
	"smjonas/inc-rename.nvim",
	event = "BufReadPre",
	lazy = true,
	enabled = false,
	config = function()
		require("inc_rename").setup({
			cmd_name = "IncRename", -- Tên lệnh gọi đổi tên
			hl_group = "Substitute", -- Highlight nhóm cho phần đổi tên
			show_message = true, -- Hiển thị thông báo sau khi đổi tên
			input_buffer_type = nil, -- Kiểu buffer nhập liệu (nil = mặc định dùng mini buffer)
		})

		-- Phím tắt cho IncRename
		vim.api.nvim_set_keymap(
			"n",
			"<leader>rr",
			":IncRename ",
			{ noremap = true, silent = false, desc = "Rename variable" }
		)
	end,
}

-- ========================================================================== --
--                        CUSTOM FOLDING CONFIGURATION                        --
-- ========================================================================== --

-- 1. HÀM XỬ LÝ HIỂN THỊ TEXT KHI FOLD (Core Logic)
function _G.SimpleFoldText()
	local pos = vim.v.foldstart
	local end_pos = vim.v.foldend
	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]

	if not line then
		return { { "...", "Comment" } }
	end

	local text_parts = {}

	-- --- A. Tái tạo màu sắc (Syntax Highlighting) ---
	local prev_hl = nil
	local current_text = ""

	for col = 0, #line - 1 do
		local char = line:sub(col + 1, col + 1)
		local capture_name = "Normal"

		local success, captures = pcall(vim.treesitter.get_captures_at_pos, 0, pos - 1, col)

		if success and captures and #captures > 0 then
			local capture = captures[#captures].capture
			capture_name = "@" .. capture
		end

		if capture_name == prev_hl then
			current_text = current_text .. char
		else
			if prev_hl then
				table.insert(text_parts, { current_text, prev_hl })
			end
			current_text = char
			prev_hl = capture_name
		end
	end
	if current_text ~= "" then
		table.insert(text_parts, { current_text, prev_hl })
	end

	-- --- B. Thêm phần giữa " ... " ---
	table.insert(text_parts, { " ... ", "Comment" })

	-- --- C. Lấy dấu đóng ngoặc thật sự ---
	local end_line = vim.api.nvim_buf_get_lines(0, end_pos - 1, end_pos, false)[1]
	if end_line then
		local closing_part = end_line:match("^%s*(.*)") or "}"
		local last_hl_group = text_parts[#text_parts - 1] and text_parts[#text_parts - 1][2] or "Normal"
		table.insert(text_parts, { closing_part, last_hl_group })
	end

	-- --- D. Thêm thông tin số dòng ---
	local lines_count = end_pos - pos
	table.insert(text_parts, { " ⚡ " .. lines_count .. " lines ", "Special" })

	return text_parts
end

-- 2. CHỨC NĂNG PREVIEW FOLD & SCROLL
local preview_win_id = nil

-- Hàm đóng Preview và dọn dẹp Keymap
local function close_preview()
	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
		vim.api.nvim_win_close(preview_win_id, true)
		preview_win_id = nil
	end

	-- Xóa keymap tạm thời sau khi đóng để tránh xung đột
	-- Dùng pcall để không báo lỗi nếu keymap không tồn tại
	pcall(vim.keymap.del, "n", "q", { buffer = 0 })
	pcall(vim.keymap.del, "n", "<Esc>", { buffer = 0 })
end

-- Hàm Toggle Preview (Mở/Đóng)
local function toggle_peek_fold()
	-- Nếu đang mở thì đóng
	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
		close_preview()
		return
	end

	local winid = vim.api.nvim_get_current_win()
	local lnum = vim.api.nvim_win_get_cursor(winid)[1]
	local fold_start = vim.fn.foldclosed(lnum)

	if fold_start == -1 then
		return
	end

	local fold_end = vim.fn.foldclosedend(lnum)
	local lines = vim.api.nvim_buf_get_lines(0, fold_start - 1, fold_end, false)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	local ft = vim.bo.filetype
	vim.bo[buf].filetype = ft

	local win_width = vim.api.nvim_win_get_width(0)
	local win_height = vim.api.nvim_win_get_height(0)
	local width = math.min(win_width - 10, 80)
	local height = math.min(#lines, win_height - 5)

	local opts = {
		relative = "cursor",
		row = 1,
		col = 1,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	}

	preview_win_id = vim.api.nvim_open_win(buf, false, opts)

	-- === CÀI ĐẶT PHÍM TẮT TẠM THỜI (EPHEMERAL KEYMAPS) ===
	-- Chỉ có tác dụng trong buffer hiện tại khi popup đang mở
	local key_opts = { buffer = 0, silent = true, nowait = true }
	vim.keymap.set("n", "q", close_preview, key_opts)
	vim.keymap.set("n", "<Esc>", close_preview, key_opts)

	-- Tự đóng khi di chuyển con trỏ ra khỏi dòng hiện tại
	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
		buffer = 0,
		callback = function()
			-- Gọi hàm close_preview để vừa đóng window vừa xóa keymap
			close_preview()
			return true -- Xóa autocmd sau khi chạy xong
		end,
	})
end

-- Hàm Scroll Tổng Quát (Có tích hợp zz cho C-u/C-d)
local function execute_scroll(key_mapping)
	local should_center = (key_mapping == "<C-u>" or key_mapping == "<C-d>")
	local cmd = key_mapping .. (should_center and "zz" or "")

	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)

	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
		vim.api.nvim_win_call(preview_win_id, function()
			vim.cmd("normal! " .. keys)
		end)
	else
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end

-- 3. CẤU HÌNH UI & HIGHLIGHT
local function setup_fold_ui()
	vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", italic = false })

	if vim.fn.has("nvim-0.10") == 1 then
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldtext = "v:lua.SimpleFoldText()"
	else
		vim.opt.foldmethod = "indent"
		vim.opt.foldtext = ""
	end

	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99
	vim.opt.foldenable = true
	vim.opt.foldcolumn = "1"
	vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
end

setup_fold_ui()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = setup_fold_ui,
})

-- === KEYMAPS ===

vim.keymap.set("n", "zp", toggle_peek_fold, { desc = "Toggle Fold Preview" })

vim.keymap.set("n", "<C-u>", function()
	execute_scroll("<C-u>")
end, { desc = "Scroll Preview/Page Up" })
vim.keymap.set("n", "<C-d>", function()
	execute_scroll("<C-d>")
end, { desc = "Scroll Preview/Page Down" })

vim.keymap.set("n", "<C-y>", function()
	execute_scroll("<C-y>")
end, { desc = "Scroll Preview/Line Up" })
vim.keymap.set("n", "<C-e>", function()
	execute_scroll("<C-e>")
end, { desc = "Scroll Preview/Line Down" })

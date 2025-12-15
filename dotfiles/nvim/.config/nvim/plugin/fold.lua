-- ========================================================================== --
--                        CUSTOM FOLDING CONFIGURATION                        --
-- ========================================================================== --

-- 1. HÀM FOLDTEXT (Giữ nguyên vì nó đang hiển thị tốt)
function _G.SimpleFoldText()
	local pos = vim.v.foldstart
	local end_pos = vim.v.foldend
	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
	if not line then
		return { { "...", "Comment" } }
	end
	local text_parts = {}
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
	table.insert(text_parts, { " ... ", "Comment" })
	local end_line = vim.api.nvim_buf_get_lines(0, end_pos - 1, end_pos, false)[1]
	if end_line then
		local closing_part = end_line:match("^%s*(.*)") or "}"
		local last_hl_group = text_parts[#text_parts - 1] and text_parts[#text_parts - 1][2] or "Normal"
		table.insert(text_parts, { closing_part, last_hl_group })
	end
	local lines_count = end_pos - pos - 1
	table.insert(text_parts, { " ⚡ " .. lines_count .. " lines ", "Special" })
	return text_parts
end

-- 2. CHỨC NĂNG PREVIEW (FOCUS MODE)
local preview_win_id = nil
local original_win_id = nil -- Lưu lại cửa sổ gốc để quay về

local function close_preview()
	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
		vim.api.nvim_win_close(preview_win_id, true)
		preview_win_id = nil
	end
	-- Quay trở lại cửa sổ gốc nếu nó còn tồn tại
	if original_win_id and vim.api.nvim_win_is_valid(original_win_id) then
		vim.api.nvim_set_current_win(original_win_id)
		original_win_id = nil
	end
end

local function toggle_peek_fold()
	-- Nếu đang mở thì đóng
	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
		close_preview()
		return
	end

	-- Lấy thông tin fold
	local winid = vim.api.nvim_get_current_win()
	local lnum = vim.api.nvim_win_get_cursor(winid)[1]
	local fold_start = vim.fn.foldclosed(lnum)
	if fold_start == -1 then
		return
	end -- Không phải fold thì không làm gì

	local fold_end = vim.fn.foldclosedend(lnum)
	local lines = vim.api.nvim_buf_get_lines(0, fold_start - 1, fold_end, false)

	-- Lưu cửa sổ gốc để quay về sau khi đóng
	original_win_id = winid

	-- Tạo buffer tạm
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Copy filetype để có syntax highlighting
	local ft = vim.bo.filetype
	vim.bo[buf].filetype = ft

	-- Không cho sửa (Read-only) để tránh gõ nhầm
	vim.bo[buf].modifiable = false

	-- Tính toán kích thước
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

	-- Mở cửa sổ
	preview_win_id = vim.api.nvim_open_win(buf, true, opts) -- true = Enter/Focus luôn vào cửa sổ mới

	-- === THIẾT LẬP GIAO DIỆN TRONG PREVIEW ===
	-- Bật số dòng, cursorline để nhìn cho dễ (giống editor thật)
	vim.wo[preview_win_id].number = true
	vim.wo[preview_win_id].cursorline = true
	vim.wo[preview_win_id].signcolumn = "no" -- Tắt cột sign cho gọn

	-- === PHÍM TẮT THOÁT (Exit Keys) ===
	-- Chỉ map trong buffer preview này
	local key_opts = { buffer = buf, silent = true, nowait = true }

	vim.keymap.set("n", "q", close_preview, key_opts)
	vim.keymap.set("n", "<Esc>", close_preview, key_opts)
	-- Cho phép ấn zp lần nữa để đóng (Toggle)
	vim.keymap.set("n", "zp", close_preview, key_opts)

	-- LƯU Ý: Không cần map C-d, C-u ở đây nữa.
	-- Vì ta đã focus vào cửa sổ, nó sẽ tự dùng config global của bạn (cái mà có zz).
end

-- 3. CẤU HÌNH UI (Giữ nguyên)
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

-- === KEYMAP KÍCH HOẠT ===
vim.keymap.set("n", "zp", toggle_peek_fold, { desc = "Toggle Fold Preview" })

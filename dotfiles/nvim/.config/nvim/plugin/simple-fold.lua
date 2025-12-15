-- -- File: ~/.config/nvim/plugin/simple-fold.lua
--
-- -- 1. HÀM TOGGLE PREVIEW (Giữ nguyên)
-- local preview_win_id = nil
-- local function toggle_peek_fold()
-- 	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
-- 		vim.api.nvim_win_close(preview_win_id, true)
-- 		preview_win_id = nil
-- 		return
-- 	end
-- 	local winid = vim.api.nvim_get_current_win()
-- 	local lnum = vim.api.nvim_win_get_cursor(winid)[1]
-- 	local fold_start = vim.fn.foldclosed(lnum)
-- 	if fold_start == -1 then
-- 		return
-- 	end
-- 	local fold_end = vim.fn.foldclosedend(lnum)
-- 	local lines = vim.api.nvim_buf_get_lines(0, fold_start - 1, fold_end, false)
-- 	local buf = vim.api.nvim_create_buf(false, true)
-- 	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
-- 	vim.bo[buf].filetype = vim.bo.filetype
-- 	local width = math.min(vim.api.nvim_win_get_width(0) - 10, 80)
-- 	local height = math.min(#lines, 20)
-- 	local opts = {
-- 		relative = "cursor",
-- 		row = 1,
-- 		col = 1,
-- 		width = width,
-- 		height = height,
-- 		style = "minimal",
-- 		border = "rounded",
-- 		title = string.format(" Preview (%d lines) ", #lines),
-- 		title_pos = "center",
-- 	}
-- 	preview_win_id = vim.api.nvim_open_win(buf, false, opts)
-- 	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
-- 		buffer = 0,
-- 		once = true,
-- 		callback = function()
-- 			if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
-- 				vim.api.nvim_win_close(preview_win_id, true)
-- 				preview_win_id = nil
-- 			end
-- 		end,
-- 	})
-- end
--
-- -- 2. HÀM HIỂN THỊ TEXT (ĐÃ SỬA LỖI HIỂN THỊ QUÁ DÀI)
-- _G.SimpleFoldText = function()
-- 	-- Lấy dòng đầu tiên của khối Fold
-- 	local pos = vim.v.foldstart
-- 	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1] or ""
--
-- 	-- === DỌN DẸP TEXT ===
-- 	-- 1. Xóa khoảng trắng thừa ở đầu
-- 	local text = line:gsub("^%s+", "")
--
-- 	-- 2. Xóa các ký tự lạ (nếu có) do lỗi copy paste hoặc binary
-- 	text = text:gsub("[\t\n]", " ") -- Thay tab/newline bằng space
-- 	text = text:gsub("[%z\1-\31]", "") -- Xóa ký tự điều khiển
--
-- 	-- === CẮT NGẮN (TRUNCATE) ===
-- 	-- Nếu dòng dài hơn 50 ký tự, cắt bớt và thêm "..."
-- 	-- Bạn có thể chỉnh số 50 thành số khác tùy độ rộng màn hình
-- 	local max_width = 50
-- 	if #text > max_width then
-- 		text = text:sub(1, max_width) .. "..."
-- 	end
--
-- 	-- Tính số dòng bị ẩn
-- 	local count = vim.v.foldend - vim.v.foldstart + 1
--
-- 	-- FORMAT: "filetypes = { ... } ⚡ 15 lines"
-- 	-- Tự động thêm dấu đóng ngoặc ảo "}" cho đẹp mắt
-- 	return string.format(" %s ... } ⚡ %d lines", text, count)
-- end
--
-- -- 3. CÀI ĐẶT & FIX MÀU
-- local function setup_fold_ui()
-- 	-- [MÀU SẮC]
-- 	vim.api.nvim_set_hl(0, "Folded", { fg = "#dcd7ba", bg = "#2d2d37", bold = true, force = true })
--
-- 	if vim.fn.has("nvim-0.10") == 1 then
-- 		vim.opt.foldmethod = "expr"
-- 		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- 	else
-- 		vim.opt.foldmethod = "indent"
-- 	end
--
-- 	vim.opt.foldlevel = 99
-- 	vim.opt.foldlevelstart = 99
-- 	vim.opt.foldenable = true
-- 	vim.opt.foldcolumn = "1"
-- 	vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
--
-- 	vim.opt.foldtext = "v:lua.SimpleFoldText()"
-- end
--
-- setup_fold_ui()
--
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	pattern = "*",
-- 	callback = setup_fold_ui,
-- })
--
-- vim.keymap.set("n", "zp", toggle_peek_fold, { desc = "Toggle Fold Preview" })

-- File: ~/.config/nvim/plugin/simple-fold.lua

local preview_win_id = nil

-- ==========================================================================
-- 1. HÀM CUỘN (SCROLL) THÔNG MINH
-- ==========================================================================
local function scroll_preview(direction)
	-- Kiểm tra xem cửa sổ preview có đang mở không
	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
		-- Nếu có: Gửi lệnh cuộn vào trong cửa sổ đó
		vim.api.nvim_win_call(preview_win_id, function()
			-- 'u' = Up (Lên), 'd' = Down (Xuống)
			local key = direction == "u" and "<C-u>" or "<C-d>"
			vim.cmd("normal! " .. vim.api.nvim_replace_termcodes(key, true, false, true))
		end)
	else
		-- Nếu không mở preview: Cuộn cửa sổ chính như bình thường
		local key = direction == "u" and "<C-u>" or "<C-d>"
		local keys = vim.api.nvim_replace_termcodes(key, true, false, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end

-- ==========================================================================
-- 2. HÀM TOGGLE PREVIEW
-- ==========================================================================
local function toggle_peek_fold()
	if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
		vim.api.nvim_win_close(preview_win_id, true)
		preview_win_id = nil
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

	-- Tạo buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = vim.bo.filetype

	-- Tính toán kích thước (Max cao 20 dòng)
	local width = math.min(vim.api.nvim_win_get_width(0) - 10, 80)
	local height = math.min(#lines, 20) -- Bạn có thể tăng số 20 lên nếu muốn xem nhiều hơn

	local opts = {
		relative = "cursor",
		row = 1,
		col = 1,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = string.format(" Preview (%d lines) ", #lines),
		title_pos = "center",
	}

	preview_win_id = vim.api.nvim_open_win(buf, false, opts)

	-- Tự đóng khi di chuyển con trỏ ra chỗ khác
	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
		buffer = 0,
		once = true,
		callback = function()
			if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
				vim.api.nvim_win_close(preview_win_id, true)
				preview_win_id = nil
			end
		end,
	})
end

-- ==========================================================================
-- 3. HÀM FOLD TEXT (CLEAN)
-- ==========================================================================
_G.SimpleFoldText = function()
	local pos = vim.v.foldstart
	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1] or ""

	-- Dọn dẹp text rác
	local text = line:gsub("^%s+", "")
	text = text:gsub("[\t\n]", " ")
	text = text:gsub("[%z\1-\31]", "")

	-- Cắt ngắn nếu quá dài
	if #text > 60 then
		text = text:sub(1, 60) .. "..."
	end

	local count = vim.v.foldend - vim.v.foldstart + 1
	return string.format(" %s ... } ⚡ %d lines", text, count)
end

-- ==========================================================================
-- 4. SETUP & KEYMAPS
-- ==========================================================================
local function setup_fold_ui()
	vim.api.nvim_set_hl(0, "Folded", { fg = "#dcd7ba", bg = "#2d2d37", bold = true, force = true })

	if vim.fn.has("nvim-0.10") == 1 then
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	else
		vim.opt.foldmethod = "indent"
	end

	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99
	vim.opt.foldenable = true
	vim.opt.foldcolumn = "1"
	vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
	vim.opt.foldtext = "v:lua.SimpleFoldText()"
end

setup_fold_ui()
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = setup_fold_ui })

-- === KEYMAPS MỚI ===
vim.keymap.set("n", "zp", toggle_peek_fold, { desc = "Toggle Fold Preview" })

-- Map đè Ctrl-u và Ctrl-d
vim.keymap.set("n", "<C-u>", function()
	scroll_preview("u")
end, { desc = "Scroll Preview Up" })
vim.keymap.set("n", "<C-d>", function()
	scroll_preview("d")
end, { desc = "Scroll Preview Down" })

-- File: lua/outline/core.lua

local M = {}

-- Yêu cầu cấu hình
local CONFIG = require("modules.outline.config")

-- ================= STATE ================= --
local State = {
	win_id = nil,
	buf_id = nil,
	preview_win_id = nil,
	source_win = nil,
	source_buf = nil,
	symbols_map = {},
	ns_id = vim.api.nvim_create_namespace("OutlineColors"),
	search_query = "",
	raw_symbols = nil,
}

-- ================= HELPER ================= --
local function is_valid_buffer(bufnr)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	local ft = vim.bo[bufnr].filetype
	local bt = vim.bo[bufnr].buftype

	for _, bad_ft in ipairs(CONFIG.ignore_filetypes) do
		if ft == bad_ft then
			return false
		end
	end
	for _, bad_bt in ipairs(CONFIG.ignore_buftypes) do
		if bt == bad_bt then
			return false
		end
	end
	return true
end

local function get_clients(opts)
	local fn = vim.lsp.get_clients or vim.lsp.get_active_clients
	return fn(opts)
end

local function match_recursive(symbol, query)
	local name_match = string.find(string.lower(symbol.name), query, 1, true)
	local child_match = false
	if symbol.children then
		for _, child in ipairs(symbol.children) do
			if match_recursive(child, query) then
				child_match = true
				break
			end
		end
	end
	return name_match or child_match
end

-- ================= ACTIONS (CLOSE/OPEN) ================= --

-- Hàm đóng Preview
local function close_preview()
	if State.preview_win_id and vim.api.nvim_win_is_valid(State.preview_win_id) then
		vim.api.nvim_win_close(State.preview_win_id, true)
	end
	State.preview_win_id = nil
end

-- Hàm đóng hoàn toàn Outline
local function close_outline_full()
	close_preview()
	if State.win_id and vim.api.nvim_win_is_valid(State.win_id) then
		vim.api.nvim_win_close(State.win_id, true)
	end
	State.win_id = nil
	State.search_query = ""
end

-- Hàm đóng Explorer (Snacks, NeoTree...)
local function close_explorer()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) then
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.bo[buf].filetype
			-- Kiểm tra xem window này có phải là Explorer không
			for _, exp_ft in ipairs(CONFIG.explorer_filetypes) do
				if ft == exp_ft then
					vim.api.nvim_win_close(win, true)
					break
				end
			end
		end
	end
end

-- ================= PREVIEW LOGIC ================= --

local function calculate_preview_layout()
	local total_width = vim.o.columns
	local total_height = vim.o.lines
	local p_width = math.floor(total_width * CONFIG.preview.width_pct)
	local p_height = math.floor(total_height * CONFIG.preview.height_pct)

	local current_row_in_win = vim.fn.line(".") - vim.fn.line("w0")
	local win_pos = vim.api.nvim_win_get_position(State.win_id)
	local abs_row = win_pos[1] + current_row_in_win
	local overflow = (abs_row + p_height) - total_height
	local row_opt = current_row_in_win

	if overflow > 0 then
		row_opt = current_row_in_win - overflow - 1
	end
	if (win_pos[1] + row_opt) < 0 then
		row_opt = -win_pos[1]
	end

	return {
		relative = "win",
		win = State.win_id,
		col = -(p_width + 2),
		row = row_opt,
		width = p_width,
		height = p_height,
		style = "minimal",
		border = CONFIG.preview.border,
		zindex = 50,
	}
end

local function update_preview()
	if not State.preview_win_id or not vim.api.nvim_win_is_valid(State.preview_win_id) then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local symbol_data = State.symbols_map[cursor[1]]

	if symbol_data and is_valid_buffer(State.source_buf) then
		vim.api.nvim_win_set_buf(State.preview_win_id, State.source_buf)

		local line_count = vim.api.nvim_buf_line_count(State.source_buf)
		local target_line = symbol_data.range.start.line + 1

		if target_line <= line_count then
			vim.api.nvim_win_set_cursor(State.preview_win_id, { target_line, 0 })
			vim.api.nvim_win_call(State.preview_win_id, function()
				vim.cmd("norm! zz")
			end)
			vim.api.nvim_win_set_option(State.preview_win_id, "cursorline", true)
		end

		local new_config = calculate_preview_layout()
		vim.api.nvim_win_set_config(State.preview_win_id, new_config)
	end
end

local function toggle_preview()
	if State.preview_win_id and vim.api.nvim_win_is_valid(State.preview_win_id) then
		close_preview()
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local symbol_data = State.symbols_map[cursor[1]]
	if not symbol_data then
		return
	end

	if not is_valid_buffer(State.source_buf) then
		return
	end

	local win_opts = calculate_preview_layout()
	win_opts.focusable = false

	State.preview_win_id = vim.api.nvim_open_win(State.source_buf, false, win_opts)

	vim.wo[State.preview_win_id].signcolumn = "no"
	vim.wo[State.preview_win_id].number = true
	vim.wo[State.preview_win_id].relativenumber = false
	vim.wo[State.preview_win_id].foldenable = false

	update_preview()
end

-- ================= CORE LOGIC ================= --

local function jump_to_symbol()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local symbol_data = State.symbols_map[cursor[1]]

	if symbol_data and State.source_win and vim.api.nvim_win_is_valid(State.source_win) then
		if is_valid_buffer(State.source_buf) then
			if vim.api.nvim_win_get_buf(State.source_win) ~= State.source_buf then
				local wins = vim.fn.win_findbuf(State.source_buf)
				if #wins > 0 then
					State.source_win = wins[1]
				end
			end

			close_preview()
			vim.api.nvim_set_current_win(State.source_win)

			local line_count = vim.api.nvim_buf_line_count(State.source_buf)
			local target_line = symbol_data.range.start.line + 1
			if target_line <= line_count then
				vim.api.nvim_win_set_cursor(State.source_win, { target_line, symbol_data.range.start.character })
				vim.cmd("norm! zz")
			end
		end
	end
end

local function perform_search()
	vim.ui.input({ prompt = "🔍 Search: " }, function(input)
		if input == nil then
			return
		end
		State.search_query = string.lower(input)
		if State.win_id and vim.api.nvim_win_is_valid(State.win_id) and State.raw_symbols then
			M.render_outline_from_cache()
		end
	end)
end

local function auto_highlight()
	if not State.win_id or not vim.api.nvim_win_is_valid(State.win_id) then
		return
	end

	local cur_win = vim.api.nvim_get_current_win()
	if cur_win == State.win_id then
		if State.preview_win_id then
			update_preview()
		end
		return
	end

	local cur_buf = vim.api.nvim_get_current_buf()
	if cur_buf ~= State.source_buf then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local cur_line = cursor[1] - 1
	local best_match_idx = nil
	local smallest_range = 999999

	for idx, data in pairs(State.symbols_map) do
		local start_line = data.range.start.line
		local end_line = data.range["end"].line
		if cur_line >= start_line and cur_line <= end_line then
			local range_len = end_line - start_line
			if range_len < smallest_range then
				smallest_range = range_len
				best_match_idx = idx
			end
		end
	end

	if best_match_idx then
		vim.api.nvim_win_set_cursor(State.win_id, { best_match_idx, 0 })
		vim.api.nvim_win_set_option(State.win_id, "cursorline", true)
	end
end

local function parse_symbols(symbols, depth, lines, map_tracker, highlights)
	for _, symbol in ipairs(symbols) do
		local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "Variable"
		local is_allowed = CONFIG.allowed_kinds[symbol.kind] or CONFIG.allowed_kinds[kind]

		local is_match_search = true
		if State.search_query ~= "" then
			is_match_search = match_recursive(symbol, State.search_query)
		end

		if is_allowed and is_match_search then
			local icon_conf = CONFIG.icons[kind] or { icon = "●", hl = "Normal" }
			local indent = string.rep("  ", depth)

			table.insert(lines, indent .. icon_conf.icon .. " " .. symbol.name)
			local line_idx = #lines

			map_tracker[line_idx] = {
				range = symbol.selectionRange or symbol.range,
				name = symbol.name,
			}

			local indent_len = #indent
			local icon_len = #icon_conf.icon
			table.insert(highlights, {
				line = line_idx - 1,
				col_start = indent_len,
				col_end = indent_len + icon_len + 10,
				hl_group = icon_conf.hl,
			})

			if symbol.children then
				parse_symbols(symbol.children, depth + 1, lines, map_tracker, highlights)
			end
		end
	end
end

function M.render_outline_from_cache()
	if not State.raw_symbols then
		return
	end
	if not State.buf_id or not vim.api.nvim_buf_is_valid(State.buf_id) then
		return
	end

	local lines = {}
	local map_tracker = {}
	local highlights = {}

	parse_symbols(State.raw_symbols, 0, lines, map_tracker, highlights)
	State.symbols_map = map_tracker

	vim.bo[State.buf_id].modifiable = true
	vim.api.nvim_buf_set_lines(State.buf_id, 0, -1, false, lines)
	vim.bo[State.buf_id].modifiable = false

	vim.api.nvim_buf_clear_namespace(State.buf_id, State.ns_id, 0, -1)
	for _, hl in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(State.buf_id, State.ns_id, hl.hl_group, hl.line, hl.col_start, hl.col_end)
	end

	if State.search_query ~= "" then
		vim.api.nvim_echo({ { "Filtered: " .. State.search_query, "WarningMsg" } }, false, {})
	end
end

local function refresh_outline()
	if not State.win_id or not vim.api.nvim_win_is_valid(State.win_id) then
		return
	end

	local cur_win = vim.api.nvim_get_current_win()
	local potential_buf = vim.api.nvim_get_current_buf()

	-- Chỉ update source nếu focus vào cửa sổ code thật
	if cur_win ~= State.win_id and is_valid_buffer(potential_buf) then
		State.source_buf = potential_buf
		State.source_win = cur_win
	end

	if not is_valid_buffer(State.source_buf) then
		return
	end

	local clients = get_clients({ bufnr = State.source_buf })
	if #clients == 0 then
		return
	end

	local params = { textDocument = vim.lsp.util.make_text_document_params(State.source_buf) }
	vim.lsp.buf_request(State.source_buf, "textDocument/documentSymbol", params, function(err, result, _, _)
		if err or not result or vim.tbl_isempty(result) then
			return
		end
		State.raw_symbols = result
		M.render_outline_from_cache()
	end)
end

-- ================= TOGGLE (API) ================= --
function M.toggle()
	-- CLOSE
	if State.win_id and vim.api.nvim_win_is_valid(State.win_id) then
		close_outline_full()
		return
	end

	-- OPEN
	close_explorer()

	local cur_win = vim.api.nvim_get_current_win()
	local cur_buf = vim.api.nvim_get_current_buf()

	if not is_valid_buffer(cur_buf) then
		vim.notify("Outline: Cannot open on this buffer", vim.log.levels.WARN)
		return
	end

	State.source_win = cur_win
	State.source_buf = cur_buf

	vim.cmd("botright vsplit")
	vim.cmd("vertical resize " .. CONFIG.width)

	State.win_id = vim.api.nvim_get_current_win()
	State.buf_id = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(State.win_id, State.buf_id)

	local win_opts = {
		number = false,
		relativenumber = false,
		cursorline = true,
		wrap = false,
		signcolumn = "no",
		winfixwidth = true,
		spell = false,
		foldcolumn = "0",
		list = false,
	}
	for k, v in pairs(win_opts) do
		vim.wo[State.win_id][k] = v
	end

	vim.bo[State.buf_id].bufhidden = "wipe"
	vim.bo[State.buf_id].filetype = "outline"
	vim.bo[State.buf_id].buftype = "nofile"
	vim.bo[State.buf_id].modifiable = false

	local opts = { buffer = State.buf_id, noremap = true, silent = true }
	vim.keymap.set("n", "<CR>", jump_to_symbol, opts)
	vim.keymap.set("n", "o", jump_to_symbol, opts)
	vim.keymap.set("n", "q", function()
		M.toggle() -- Dùng M.toggle() thay vì _G.ToggleOutline()
	end, opts)
	vim.keymap.set("n", CONFIG.keymap_preview, toggle_preview, opts)
	vim.keymap.set("n", CONFIG.keymap_search, perform_search, opts)

	refresh_outline()
end

-- ================= AUTO COMMANDS (API) ================= --
function M.setup_autocmds()
	local grp = vim.api.nvim_create_augroup("OutlineSidebar", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
		group = grp,
		callback = function()
			vim.defer_fn(refresh_outline, 200)
		end,
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = grp,
		callback = auto_highlight,
	})
	vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
		group = grp,
		callback = function()
			if State.preview_win_id and vim.api.nvim_win_is_valid(State.preview_win_id) then
				local new_config = calculate_preview_layout()
				vim.api.nvim_win_set_config(State.preview_win_id, new_config)
			end
		end,
	})

	-- Tự động đóng Outline nếu người dùng mở Explorer
	vim.api.nvim_create_autocmd("FileType", {
		group = grp,
		pattern = CONFIG.explorer_filetypes,
		callback = function()
			if State.win_id and vim.api.nvim_win_is_valid(State.win_id) then
				close_outline_full()
			end
		end,
	})
end

return M

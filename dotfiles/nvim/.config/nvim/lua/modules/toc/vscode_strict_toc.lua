-- lua/modules/toc/vscode_strict_toc.lua
local M = {}

function M.setup()
	-- ========================================================================
	-- PHẦN 1: SLUGIFY (VS Code strict)
	-- ========================================================================
	local function slugify(text)
		local slug = vim.fn.tolower(text)
		slug = slug:gsub("%s+", "-")
		slug = slug:gsub("[\240-\247][\128-\191][\128-\191][\128-\191]", "")
		slug = slug:gsub("\226[\128-\191][\128-\191]", "")
		slug = slug:gsub("\239\184\111", "")
		slug = slug:gsub("[%.%,%/%?%!%:%;%(%)%[%]%%\"'`@#%$%^&%*+=|\\~<>]", "")
		return slug
	end

	-- ========================================================================
	-- PHẦN 2: :GenTOC
	-- ========================================================================
	vim.api.nvim_create_user_command("GenTOC", function()
		local buf = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		local toc_marker = "<!-- toc -->"
		local toc_stop = "<!-- tocstop -->"

		local old_start, old_end, insert_pos

		for i, line in ipairs(lines) do
			if line:find(toc_marker, 1, true) then
				old_start = i
				insert_pos = i
			end
			if line:find(toc_stop, 1, true) then
				old_end = i
			end
		end

		if old_start and old_end and old_end > old_start then
			vim.api.nvim_buf_set_lines(buf, old_start - 1, old_end, false, {})
			lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		end

		if not insert_pos then
			vim.api.nvim_buf_set_lines(buf, 1, 1, false, { "", toc_marker, "" })
			insert_pos = 3
			lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		end

		local toc_content = { "" }

		for _, line in ipairs(lines) do
			local hashes, title = line:match("^(##+)%s+(.*)$")
			if hashes then
				local level = #hashes
				if level > 1 then
					local raw_title = title:match("^%s*(.-)%s*$")
					local link = slugify(raw_title)
					local indent = string.rep("  ", level - 2)
					local display = raw_title:gsub("%[", "\\["):gsub("%]", "\\]")
					table.insert(toc_content, string.format("%s- [%s](#%s)", indent, display, link))
				end
			end
		end

		table.insert(toc_content, "")
		table.insert(toc_content, toc_stop)

		vim.api.nvim_buf_set_lines(buf, insert_pos, insert_pos, false, toc_content)
		vim.cmd("write")
		vim.notify("✅ Đã tạo TOC chuẩn VS Code Strict!", vim.log.levels.INFO)
	end, {})

	-- ========================================================================
	-- PHẦN 3: SUPER GD
	-- ========================================================================
	local function super_gd()
		local line = vim.api.nvim_get_current_line()
		local link = line:match("%(#(.-)%)")

		if link then
			local fp = link:gsub("%-", ""):gsub("%%", ""):lower()
			for i, l in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
				if l:match("^#+") then
					local hfp = l:lower():gsub(
						"[^a-z0-9àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]",
						""
					)
					if hfp:find(fp, 1, true) then
						vim.api.nvim_win_set_cursor(0, { i, 0 })
						vim.cmd("norm! zz")
						return
					end
				end
			end
		end

		vim.lsp.buf.definition()
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function(ev)
			vim.keymap.set("n", "gd", super_gd, { buffer = ev.buf, silent = true })
			vim.keymap.set("n", "<leader>mt", "<cmd>GenTOC<cr>", {
				buffer = ev.buf,
				desc = "Gen TOC (Strict VSCode)",
			})
		end,
	})
end

return M

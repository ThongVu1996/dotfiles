-- return {
-- 	{
-- 		name = "native-vscode-toc",
-- 		dir = vim.fn.stdpath("config"),
-- 		ft = "markdown",
-- 		keys = {
-- 			{ "<leader>mt", "<cmd>GenTOC<cr>", desc = "Gen TOC (Delete & Recreate)", mode = "n" },
-- 		},
-- 		config = function()
-- 			-- 1. Hàm tạo Slug chuẩn VS Code (Giữ Tiếng Việt)
-- 			local function slugify(text)
-- 				local slug = vim.fn.tolower(text)
-- 				-- Xóa Emoji (4-byte)
-- 				slug = slug:gsub("[\240-\247][\128-\191][\128-\191][\128-\191]", "")
-- 				-- Xóa ký tự đặc biệt VS Code không thích
-- 				slug = slug:gsub("[%.%,%/%?%!%:%;%(%)%[%]%%\"'`@#%$%^&%*+=|\\~<>]", "")
-- 				-- Space -> Gạch ngang
-- 				slug = slug:gsub("%s+", "-")
-- 				-- Xóa gạch ngang thừa
-- 				slug = slug:gsub("%-+", "-")
-- 				slug = slug:gsub("^%-", ""):gsub("%-$", "")
-- 				return slug
-- 			end
--
-- 			vim.api.nvim_create_user_command("GenTOC", function()
-- 				local buf = vim.api.nvim_get_current_buf()
-- 				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--
-- 				local toc_marker = ""
-- 				local toc_stop = ""
--
-- 				-- A. TÌM VÀ XÓA TOC CŨ (Dọn đường trước)
-- 				local old_start = nil
-- 				local old_end = nil
--
-- 				for i, line in ipairs(lines) do
-- 					if line:find(toc_marker, 1, true) then
-- 						old_start = i
-- 					end
-- 					if line:find(toc_stop, 1, true) then
-- 						old_end = i
-- 					end
-- 				end
--
-- 				-- Nếu có cả mở và đóng -> Xóa sạch đoạn giữa
-- 				if old_start and old_end and old_end > old_start then
-- 					vim.api.nvim_buf_set_lines(buf, old_start - 1, old_end, false, {})
-- 					vim.notify("🗑️ Đã xóa TOC cũ để tạo lại...", vim.log.levels.INFO)
-- 					-- Cập nhật lại lines sau khi xóa
-- 					lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
-- 					old_start = nil -- Reset để tìm lại vị trí chèn mới
-- 				end
--
-- 				-- B. TÌM LẠI VỊ TRÍ CHÈN MỚI
-- 				local insert_pos = nil
-- 				for i, line in ipairs(lines) do
-- 					if line:find(toc_marker, 1, true) then
-- 						insert_pos = i
-- 						break
-- 					end
-- 				end
--
-- 				-- Nếu mất tiêu luôn tag mở (do xóa nhầm hoặc chưa có) -> Tạo lại ở dòng 2
-- 				if not insert_pos then
-- 					vim.api.nvim_buf_set_lines(buf, 1, 1, false, { "", toc_marker, "" })
-- 					insert_pos = 3 -- Vị trí tag vừa chèn
-- 					lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false) -- Reload lines
-- 				end
--
-- 				-- C. TẠO NỘI DUNG MỚI
-- 				local toc_content = {}
-- 				-- Không cần chèn toc_marker vào toc_content vì nó đã nằm sẵn ở file rồi
-- 				-- Ta chỉ chèn nội dung vào SAU toc_marker
--
-- 				table.insert(toc_content, "") -- Dòng trống cho thoáng
--
-- 				local count = 0
-- 				for _, line in ipairs(lines) do
-- 					-- Regex bắt H2, H3...
-- 					local hashes, title = line:match("^(##+)%s+(.*)$")
-- 					if hashes then
-- 						local level = #hashes
-- 						if level > 1 then -- Bỏ qua H1
-- 							count = count + 1
-- 							title = title:match("^%s*(.-)%s*$")
-- 							local link = slugify(title)
-- 							local indent = string.rep("  ", level - 2)
-- 							table.insert(toc_content, string.format("%s- [%s](#%s)", indent, title, link))
-- 						end
-- 					end
-- 				end
--
-- 				table.insert(toc_content, "")
-- 				table.insert(toc_content, toc_stop)
--
-- 				-- D. GHI VÀO FILE (QUAN TRỌNG)
-- 				-- Ghi ngay sau dòng chứa (tức là insert_pos)
-- 				if count > 0 then
-- 					vim.api.nvim_buf_set_lines(buf, insert_pos, insert_pos, false, toc_content)
--
-- 					-- FORCE SAVE & RELOAD (Để đảm bảo mắt thường nhìn thấy)
-- 					vim.cmd("write")
-- 					vim.cmd("edit!")
--
-- 					vim.notify(
-- 						"✅ Đã chèn " .. count .. " dòng mục lục. (Saved & Reloaded)",
-- 						vim.log.levels.INFO
-- 					)
-- 				else
-- 					vim.notify("⚠️ Không tìm thấy Heading nào (##) để tạo!", vim.log.levels.WARN)
-- 				end
-- 			end, {})
-- 		end,
-- 	},
-- }

return {
	{
		name = "vscode-strict-toc",
		dir = vim.fn.stdpath("config"),
		ft = "markdown",
		keys = {
			{ "<leader>mt", "<cmd>GenTOC<cr>", desc = "Gen TOC (Strict VSCode)", mode = "n" },
		},
		config = function()
			-- ========================================================================
			-- PHẦN 1: HÀM SLUGIFY (Giữ nguyên gạch ngang đầu/cuối của VSCode)
			-- ========================================================================
			local function slugify(text)
				local slug = vim.fn.tolower(text)

				-- 1. Space -> Gạch ngang TRƯỚC TIÊN
				-- " chọn ... ?" -> "-chọn-...-?"
				slug = slug:gsub("%s+", "-")

				-- 2. Xóa Emoji (4-byte, 3-byte, VS-16)
				slug = slug:gsub("[\240-\247][\128-\191][\128-\191][\128-\191]", "")
				slug = slug:gsub("\226[\128-\191][\128-\191]", "")
				slug = slug:gsub("\239\184\111", "")

				-- 3. Xóa ký tự đặc biệt (Punctuation)
				-- Lưu ý: "/opt/devcom/" -> "optdevcom" (Dấu / bị xóa)
				slug = slug:gsub("[%.%,%/%?%!%:%;%(%)%[%]%%\"'`@#%$%^&%*+=|\\~<>]", "")

				-- 4. TUYỆT ĐỐI KHÔNG TRIM GẠCH NGANG
				-- Code cũ có trim -> Đã xóa bỏ.
				-- Kết quả: "-tại-sao...optdevcom-" được bảo toàn.

				return slug
			end

			-- ========================================================================
			-- PHẦN 2: LỆNH :GenTOC
			-- ========================================================================
			vim.api.nvim_create_user_command("GenTOC", function()
				local buf = vim.api.nvim_get_current_buf()
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

				local toc_marker = string.char(60, 33, 45, 45, 32, 116, 111, 99, 32, 45, 45, 62)
				local toc_stop = string.char(60, 33, 45, 45, 32, 116, 111, 99, 115, 116, 111, 112, 32, 45, 45, 62)

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
					for i, line in ipairs(lines) do
						if line:find(toc_marker, 1, true) then
							insert_pos = i
							break
						end
					end
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
							local display_title = raw_title:gsub("%[", "\\["):gsub("%]", "\\]")
							table.insert(toc_content, string.format("%s- [%s](#%s)", indent, display_title, link))
						end
					end
				end
				table.insert(toc_content, "")
				table.insert(toc_content, toc_stop)

				vim.api.nvim_buf_set_lines(buf, insert_pos, insert_pos, false, toc_content)
				vim.cmd("write")
				vim.cmd("edit!")
				vim.notify("✅ Đã tạo TOC chuẩn VS Code Strict!", vim.log.levels.INFO)
			end, {})

			-- ========================================================================
			-- PHẦN 3: FINGERPRINT GD (Nhảy link bất chấp ký tự lạ)
			-- ========================================================================
			local function super_gd()
				local line = vim.api.nvim_get_current_line()
				-- 1. Lấy link thô: #-tại-sao...optdevcom-
				local link = line:match("%(#(.-)%)")

				if link then
					-- 2. Tạo "Vân tay" cho Link (Xóa hết gạch ngang và dấu %)
					-- VD: "optdevcom"
					local link_fingerprint = link:gsub("%-", ""):gsub("%%", "")
					link_fingerprint = vim.fn.tolower(link_fingerprint)

					-- 3. Quét tất cả dòng tiêu đề để so khớp vân tay
					local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					local target_line = nil

					for i, l in ipairs(lines) do
						if l:match("^#+") then
							-- Tạo "Vân tay" cho Tiêu đề
							-- VD: "/opt/devcom/" -> Xóa ký tự lạ -> "optdevcom"
							local header_fingerprint = vim.fn.tolower(l)
							-- Xóa sạch sành sanh mọi thứ không phải chữ/số để so sánh
							header_fingerprint = header_fingerprint:gsub(
								"[^a-z0-9aaaaaaàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]",
								""
							)

							-- So sánh: Nếu tiêu đề chứa nội dung của link (đã làm sạch)
							-- VD: header "taisao...optdevcom" CHỨA link "optdevcom" -> Match!
							if header_fingerprint:find(link_fingerprint, 1, true) then
								target_line = i
								break
							end
						end
					end

					if target_line then
						vim.api.nvim_win_set_cursor(0, { target_line, 0 })
						vim.cmd("norm! zz")
						return
					end
				end

				-- Fallback
				vim.lsp.buf.definition()
			end

			vim.keymap.set("n", "gd", super_gd, { buffer = true, noremap = true, silent = true })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(ev)
					vim.keymap.set("n", "gd", super_gd, { buffer = ev.buf, noremap = true, silent = true })
				end,
			})
		end,
	},
}

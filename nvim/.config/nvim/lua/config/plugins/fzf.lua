return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"echasnovski/mini.icons",
		"mfussenegger/nvim-dap",
	},
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			"telescope", -- Hiển thị như telescope
			winopts = {
				-- height = 0.9, -- Chiều cao cửa sổ popup
				-- width = 0.9, -- Chiều rộng cửa sổ popup
				-- row = 0.35, -- Vị trí từ trên xuống
				-- col = 0.50, -- Vị trí ngang
				-- border = "rounded", -- Viền tròn
				fullscreen = true,
				preview = {
					layout = "horizontal", -- Preview theo chiều dọc
					-- layout = "vertical", -- Preview theo chiều dọc
					scrollbar = "border", -- Hiển thị thanh cuộn ở viền
					hidden = "nohidden",
					defautl = "bat",
					horizontal = "right:70%",
					vertical = "up:70%",
				},
			},
			previewers = {
				codeaction = {
					-- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
					diff_opts = { ctxlen = 3 },
					algorithm = "myers", -- Thuật toán diff (myers, minimal, patience, histogram)
					indent_heuristic = true, -- Tăng độ chính xác cho diff khi indent
				},
				codeaction_native = {
					diff_opts = { ctxlen = 3, algorithm = "myers" },
					-- git-delta is automatically detected as pager, set `pager=false`
					-- to disable, can also be set under 'lsp.code_actions.preview_pager'
					-- recommended styling for delta
					pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
				},
			},
			keymap = {
				fzf = {
					["ctrl-k"] = "up", -- Di chuyển đến kết quả trước
					["ctrl-j"] = "down", -- Di chuyển đến kết quả tiếp theo
					["ctrl-d"] = "preview-page-down", -- Cuộn preview xuống
					["ctrl-u"] = "preview-page-up", -- Cuộn preview lên
					["ctrl-q"] = "select-all+accept", -- Chọn tất cả và xác nhận
				},
			},
			files = {
				prompt = "🔍 Related Files: ", -- Prompt tùy chỉnh cho Find Files
				cmd = "fd --type f --hidden --exclude .git",
			},
			grep = {
				prompt = "🔍 Live Grep: ",
				cmd = "rg --vimgrep --smart-case --column", -- Tìm kiếm với ripgrep
			},
			git = {
				files = { prompt = "🔍 Git Related Files: " }, -- Prompt tùy chỉnh cho Git Files
				status = { prompt = "🔍 Git Status: " },
				commits = { prompt = "🔍 Git Commits: " },
				branches = { prompt = "🔍 Git Branches: " },
			},
			buffers = {
				prompt = "🔍 Buffers: ",
				sort_lastused = true, -- Sắp xếp buffer gần nhất
			},
		})

		-- Keybindings tương tự Telescope
		local keymap = vim.keymap

		-- Tìm file trong dự án
		keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files in cwd" })

		-- Tìm file mở gần đây
		keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", { desc = "Find recent files" })

		-- Tìm kiếm văn bản trong dự án
		keymap.set("n", "<leader>fs", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })

		-- Tìm kiếm từ dưới con trỏ
		keymap.set("n", "<leader>fc", "<cmd>FzfLua grep_cword<CR>", { desc = "Find word under cursor" })

		-- Tìm buffers đang mở
		keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find buffers" })

		-- Tìm TODO và FIXME
		keymap.set("n", "<leader>ft", "<cmd>FzfLua grep { search = 'TODO|FIXME' }<CR>", { desc = "Find TODO/FIXME" })

		-- Tìm file Git
		keymap.set("n", "<leader>gf", "<cmd>FzfLua git_files<CR>", { desc = "Find git files" })

		-- Xem Git status
		keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Git status" })

		-- Xem Git commits
		keymap.set("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Git commits" })

		-- Xem các nhánh Git
		keymap.set("n", "<leader>gb", "<cmd>FzfLua git_branches<CR>", { desc = "Git branches" })
	end,
}

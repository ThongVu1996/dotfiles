return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "VeryLazy",
	opts = {
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
		open_fold_hl_timeout = 400,
		close_fold_kinds_for_ft = { "imports", "comment" },
		preview = {
			win_config = {
				border = "rounded",
				winblend = 0,
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder",

				-- Positioning the preview window
				relative = "editor",
				anchor = "NE",
				row = math.floor(vim.o.lines * 0.25), -- Start at 25% of the screen height
				col = math.floor(vim.o.columns * 0.7), -- Move to the right (70% of screen width)
				width = math.max(30, math.floor(vim.o.columns * 0.3)), -- At least 30 columns wide
				height = math.max(10, math.floor(vim.o.lines * 0.5)), -- At least 10 lines tall
				maxheight = math.floor(vim.o.lines * 0.5),
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},
	},
	init = function()
		-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		-- vim.o.foldcolumn = "1"
		-- vim.o.foldlevel = 99
		-- vim.o.foldlevelstart = 99
		-- vim.o.foldenable = true

		vim.o.foldcolumn = "1" -- Always show fold column
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		vim.o.fillchars = "fold: ,foldopen:,foldsep: ,foldclose:"
	end,
	config = function(_, opts)
		local handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local totalLines = vim.api.nvim_buf_line_count(0)
			local foldedLines = endLnum - lnum
			local suffix = (" 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
			suffix = (" "):rep(rAlignAppndx) .. suffix
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end
		opts["fold_virt_text_handler"] = handler
		require("ufo").setup(opts)

		-- Keymaps
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
		vim.keymap.set("n", "zp", function()
			require("ufo").peekFoldedLinesUnderCursor()
			vim.defer_fn(function()
				vim.api.nvim_input("<C-w>w")
			end, 50)
		end, { noremap = true, silent = true, desc = "preview fold" })
	end,
}

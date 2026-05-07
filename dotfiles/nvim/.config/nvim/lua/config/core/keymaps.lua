vim.g.mapleader = " " -- Set leader key
vim.g.maplocalleader = ","
local keymap = vim.keymap -- Alias for conciseness

-- Exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk", noremap = true, silent = true })

-- Copy into end of the line
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights", noremap = true, silent = true })

-- Increment/Decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number", noremap = true, silent = true })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number", noremap = true, silent = true })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically", noremap = true, silent = true })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally", noremap = true, silent = true })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size", noremap = true, silent = true })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split", noremap = true, silent = true })

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab", noremap = true, silent = true })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab", noremap = true, silent = true })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab", noremap = true, silent = true })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab", noremap = true, silent = true })
keymap.set(
	"n",
	"<leader>tf",
	"<cmd>tabnew %<CR>",
	{ desc = "Open current buffer in new tab", noremap = true, silent = true }
)

-- Open Lazy plugin manager
keymap.set("n", "<leader>ll", ":Lazy<CR>", { desc = "Open Lazy plugin manager", noremap = true, silent = true })

-- Move lines up/down (VsCode style)
keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { noremap = true, silent = true, desc = "Move current line down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { noremap = true, silent = true, desc = "Move current line up" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selected block down" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selected block up" })

-- Smart scrolling logic
local function smart_page_scroll(direction)
	local win_height = vim.api.nvim_win_get_height(0)
	local cur_line = vim.api.nvim_win_get_cursor(0)[1]
	local total_lines = vim.api.nvim_buf_line_count(0)

	if direction == "down" then
		-- If next page would exceed file end
		if cur_line + win_height >= total_lines then
			-- Jump to absolute end (G)
			vim.cmd("normal! G")
			-- Lock line to the BOTTOM (zb) to fill screen with preceding code
			vim.cmd("normal! zb")
		else
			-- Otherwise, normal scroll forward
			vim.cmd([[execute "normal! \<C-f>"]])
		end
	else
		-- Scroll back (C-b) uses default behavior
		vim.cmd([[execute "normal! \<C-b>"]])
	end
end

-- 1. SEARCH MAPPINGS - KEEP CENTERED
-- Functions used to ensure view is centered after jumping
vim.keymap.set("n", "n", function()
	pcall(function()
		vim.cmd("normal! nzzzv")
	end)
end, { desc = "Next result (centered)" })
vim.keymap.set("n", "N", function()
	pcall(function()
		vim.cmd("normal! Nzzzv")
	end)
end, { desc = "Prev result (centered)" })
vim.keymap.set("n", "*", function()
	pcall(function()
		vim.cmd("normal! *zzzv")
	end)
end, { desc = "Search word (centered)" })
vim.keymap.set("n", "#", function()
	pcall(function()
		vim.cmd("normal! #zzzv")
	end)
end, { desc = "Search backward (centered)" })

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (visual)" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (visual)" })

-- 2. HALF PAGE SCROLLING - CENTERED
-- Ensure 'zz' keeps the active line in middle of the screen
vim.keymap.set("n", "<C-d>", function()
	vim.cmd([[execute "normal! \<C-d>zz"]])
end, { desc = "Half page down (centered)" })

vim.keymap.set("n", "<C-u>", function()
	vim.cmd([[execute "normal! \<C-u>zz"]])
end, { desc = "Half page up (centered)" })

-- 3. FULL PAGE SCROLLING - SMART SCROLL (FIXED)
-- Smart function prevents "last line only" bug at EOF
vim.keymap.set("n", "<C-f>", function()
	smart_page_scroll("down")
end, { desc = "Smart Page down" })

-- Full page scroll up
vim.keymap.set("n", "<C-b>", function()
	smart_page_scroll("up")
end, { desc = "Smart Page up" })

-- Auto-center view after interactive search (/ or ?)
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = vim.api.nvim_create_augroup("AutoCenterSearch", { clear = true }),
	callback = function()
		local cmdtype = vim.fn.getcmdtype()
		-- Only activate for search types
		if cmdtype == "/" or cmdtype == "?" then
			-- vim.schedule ensures command runs AFTER Vim jumps to target
			vim.schedule(function()
				vim.cmd("normal! zzzv")
			end)
		end
	end,
})

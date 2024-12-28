vim.g.mapleader = " " -- Set leader key

local keymap = vim.keymap -- Alias for conciseness

-- Exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk", noremap = true, silent = true })

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

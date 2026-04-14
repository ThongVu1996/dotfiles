-- Cài đặt gập code thông minh bằng Treesitter cho Blade v0.12.0
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Đảm bảo không gập code khi mới mở file
vim.opt_local.foldlevel = 99
vim.opt_local.foldenable = true

-- Sử dụng engine render của Simple-Fold cho đẹp
vim.opt_local.foldtext = "v:lua.require('simple-fold').render()"
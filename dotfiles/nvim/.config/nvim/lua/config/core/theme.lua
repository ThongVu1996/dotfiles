-- 1. Load cấu hình từ Stylix (Nix tạo ra ở ~/.config/nvim-stylix-config.lua)
local stylix_config = vim.fn.expand("~/.config/nvim-stylix-config.lua")
if vim.fn.filereadable(stylix_config) == 1 then
    dofile(stylix_config)
end

-- 2. Nạp plugin từ Nix
if vim.g.base16_plugin_path then
    vim.opt.rtp:prepend(vim.g.base16_plugin_path)
end

-- 3. Nạp màu Dynamic thông qua API của base16-nvim
if vim.g.base16_colors then
    local status, base16 = pcall(require, "base16-colorscheme")
    if status then
        base16.setup(vim.g.base16_colors)
    end
end

-- 4. Overrides cho UI (Dynamic theo theme)
local c = vim.g.base16_colors
if c then
    vim.api.nvim_set_hl(0, "LineNr", { fg = c.base04 }) -- Xám vừa (Dòng không chọn)
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.base05, bold = true }) -- Màu sáng (Dòng hiện tại)
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = c.base04, italic = true }) -- Sáng hơn cho dễ quan sát
    vim.api.nvim_set_hl(0, "SnacksPickerPath", { fg = c.base04 })
    vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { fg = c.base04 })
    vim.api.nvim_set_hl(0, "LazyComment", { fg = c.base03 })
end

-- 5. Hàm transparent cực mạnh
local function apply_transparency()
    local bg_none = { bg = "NONE", ctermbg = "NONE" }
    local hl_groups = {
        "Normal", "NormalNC", "NormalFloat", "FloatBorder",
        "TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder",
        "TelescopeResultsBorder", "TelescopePreviewBorder",
        "SnacksPicker", "SnacksPickerBorder", "Pmenu", "SignColumn"
    }
    for _, group in ipairs(hl_groups) do
        vim.api.nvim_set_hl(0, group, bg_none)
    end
end

apply_transparency()
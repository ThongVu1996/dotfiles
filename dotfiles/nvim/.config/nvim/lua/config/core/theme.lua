-- Nạp plugin từ Nix
if vim.g.base16_plugin_path then
    vim.opt.rtp:prepend(vim.g.base16_plugin_path)
end

-- Nạp màu từ Nix
if vim.g.stylix_theme then
    pcall(vim.cmd, "colorscheme " .. vim.g.stylix_theme)
end

-- Hàm transparent cực mạnh (như đã tách ở bước trước)
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
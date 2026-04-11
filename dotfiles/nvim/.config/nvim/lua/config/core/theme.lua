-- 1. Extract and Decode Palette
local palette_raw = os.getenv("STYLIX_PALETTE")
local c = nil

if palette_raw then
    local ok, decoded = pcall(vim.json.decode, palette_raw)
    if ok then c = decoded end
end

-- 2. Apply Theme
local status_base16, base16 = pcall(require, "base16-colorscheme")

if c and status_base16 then
    -- Apply Stylix Palette
    base16.setup(c)
else
    -- Fallback if Stylix is missing
    vim.cmd.colorscheme("habamax")
end

-- 3. UI Enhancements (Transparency & Highlights)
local function apply_ui_theme()
    if not c then return end
    
    local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end
    local bg_none = { bg = "none", ctermbg = "none" }

    -- Transparency
    local groups = {
        "Normal", "NormalNC", "NormalFloat", "FloatBorder",
		"TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder",
		"TelescopeResultsBorder", "TelescopePreviewBorder",
		"SnacksPicker", "SnacksPickerBorder", "Pmenu", "SignColumn"
    }
    for _, group in ipairs(groups) do hl(group, bg_none) end

    -- Custom Palette Highlights
    hl("LineNr", { fg = c.base04 })
    hl("CursorLineNr", { fg = c.base05, bold = true })
    hl("Search", { bg = c.base0A, fg = c.base00 })
end

-- Run transparency every time the colorscheme is loaded
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_ui_theme,
})

-- Initial apply
apply_ui_theme()
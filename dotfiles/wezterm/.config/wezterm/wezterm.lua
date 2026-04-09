local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- 1. OS DETECTION
local function is_mac()
    return wezterm.target_triple:find("apple") ~= nil
end

-- 2. BACKGROUND IMAGE PATH (Automatically detects Home directory)
local home = wezterm.home_dir
local bg_path = nix_bg_path or (home .. "/.config/wezterm/bg/bg.jpg")
local bg = false -- Toggle background image

-- --------------------------------------------------------------------
-- APPEARANCE CONFIGURATION
-- --------------------------------------------------------------------
-- config.color_scheme = "Tokyo Night"
config.font = wezterm.font("JetBrains Mono", { weight = "Medium", stretch = "Expanded" })
config.font_size = 15
config.line_height = 1.2
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.enable_tab_bar = false

-- Background Image Settings
if bg then
    config.window_background_image = bg_path
end

config.window_background_image_hsb = {
    brightness = 0.4,
    hue = 1.0,
    saturation = 1.0,
}

-- OS-Specific Optimizations
if is_mac() then
    config.front_end = "WebGpu"
    config.macos_window_background_blur = 20
    config.window_background_opacity = 0.85
    config.window_decorations = "RESIZE"
else
    config.front_end = "OpenGL"
    config.window_background_opacity = 1.0
    config.window_decorations = "RESIZE | TITLE"
end

-- --------------------------------------------------------------------
-- CURSOR & KEYBINDINGS
-- --------------------------------------------------------------------
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true
config.window_close_confirmation = "NeverPrompt"

-- Custom Keybindings
config.keys = {
    -- Paste from Clipboard
    { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
    -- Quit WezTerm Application
    {
        key = 'q',
        mods = 'ALT',
        action = wezterm.action.QuitApplication,
    },
}

-- Mouse Bindings (Fixed scoping issue)
config.mouse_bindings = {
    -- Triple-click to select a semantic zone
    {
        event = { Down = { streak = 3, button = "Left" } },
        action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
        mods = "NONE",
    },
    -- Right-click behavior: Copy if text is selected, otherwise Paste
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
            end
        end),
    },
    -- CTRL + Click to open Hyperlinks
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.OpenLinkAtMouseCursor,
        -- Prevents event from being sent to tmux, ensuring WezTerm handles the hyperlinks
        mouse_reporting = true,
    },
}

return config
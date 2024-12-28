local wezterm = require("wezterm")
local config = wezterm.config_builder()
local io = require("io")
local os = require("os")
local act = wezterm.action

-- image setting
local user_home = os.getenv("HOME")

-- Apperence
config.window_background_opacity = 1
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_background_image_hsb = {
	brightness = 0.1,
	hue = 1.0,
	saturation = 1.0,
}

-- end image setting

config.color_scheme = "tokyonight_moon"
config.window_background_image = user_home .. "/.config/wezterm/bg/bg.jpg"

config.font = wezterm.font("Hack Nerd Font", { weight = "Medium", stretch = "Expanded" })
config.font_size = 15
config.line_height = 1.5
config.window_decorations = "RESIZE|TITLE"
config.enable_tab_bar = false

-- cursor blink
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true

-- mouse_bindings
config.keys = { { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") } }
config.mouse_bindings = mouse_bindings

mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
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
}
return config

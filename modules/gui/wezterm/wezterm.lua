local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local act = wezterm.action

-- Terminal
config.initial_cols = 160
config.initial_rows = 35
config.prefer_egl = true
config.window_background_opacity = 0.8
config.macos_window_background_blur = 30
config.text_background_opacity = 1
config.adjust_window_size_when_changing_font_size = true
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.color_scheme = "Tokyo Night Moon"
config.enable_wayland = false

-- font
config.font_size = 14.0
--config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font = wezterm.font_with_fallback({
  { family = "HackGen Console NF", weight = "Regular" },
  { family = "HackGen Console NF", weight = "Regular", assume_emoji_presentation = true },
  { family = "Noto Sans CJK JP" },
})

-- Leader key
config.leader = { key = "b", mods = "CTRL", time_millisecons = 1000 }

-- keybinds
config.disable_default_key_bindings = true
local keybind = require("keybinds")
config.keys = keybind.keys
config.key_tables = keybind.key_tables

return config

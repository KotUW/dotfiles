local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Font
config.font = wezterm.font('Rec Mono Casual')
-- config.font = wezterm.font('JetBrains Mono')

-- config.font = wezterm.font('LiterationMono Nerd Font')
-- config.harfbuzz_features = { "zero" , "ss01", "cv05" }

config.font_size = 18
-- config.dpi = 125.0

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom= true

config.color_schemes = {
		["Charmful Dark"] = require("charmful"),
}

-- config.color_scheme = "Charmful Dark"
-- config.color_scheme = "Dark Pastel"
config.color_scheme = "carbonfox"
-- color_scheme = "DotGov"

-- KeyBindings
config.disable_default_key_bindings = false
config.keys = {
    { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
    { key = 'Enter', mods = 'ALT', action = wezterm.action.DisableDefaultAssignment },
    
    { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = "t", mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
   
    { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateLastTab },
    { key = 'x', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCopyMode },
    { key = ' ', mods = 'CTRL|SHIFT', action = wezterm.action.QuickSelect },
    
    { key = "c", mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
    { key = "v", mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom'Clipboard' },
    
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
    
    { key = 'DownArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
    { key = 'RightArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
    { key = 'LeftArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
    { key = 'UpArrow', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
    
    { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.ToggleFullScreen },
}

-- Starts home-manager managed nix shell.
config.default_prog = {"fish"}

-- config.adjust_window_size_when_changing_font_size = false

config.enable_wayland = true
config.enable_kitty_keyboard = true


return config

local wezterm                                     = require 'wezterm'

local config                                      = wezterm.config_builder()

config.color_scheme                               = 'tokyonight_moon'

-- https://github.com/wezterm/wezterm/issues/4962
config.enable_wayland                             = false

config.hide_tab_bar_if_only_one_tab               = false
config.use_fancy_tab_bar                          = false
config.tab_bar_at_bottom                          = true
config.max_fps                                    = 120

config.adjust_window_size_when_changing_font_size = false

config.default_cursor_style                       = 'BlinkingBlock'
config.cursor_blink_rate                          = 900

config.leader                                     = { key = 's', mods = 'CTRL', timeout_milliseconds = 5000 }


config.keys                      = {
  -- Send Ctrl+a to terminal when pressed twice
  { key = "a",   mods = "LEADER|CTRL",  action = wezterm.action.SendString("\x01") },

  -- Doom Mode trigger
  { key = 'w',   mods = 'LEADER',       action = wezterm.action.ActivateKeyTable { name = 'window_mode', one_shot = true } },
  { key = 'Tab', mods = 'LEADER',       action = wezterm.action.ActivateKeyTable { name = 'workspace_mode', one_shot = true } },

  -- Flat binding
  { key = "-",   mods = "LEADER",       action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "\\",  mods = "LEADER",       action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "s",   mods = "LEADER",       action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "v",   mods = "LEADER",       action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "o",   mods = "LEADER",       action = wezterm.action.TogglePaneZoomState },
  { key = "z",   mods = "LEADER",       action = wezterm.action.TogglePaneZoomState },
  { key = "c",   mods = "LEADER",       action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "n",   mods = "LEADER",       action = wezterm.action.SpawnTab("CurrentPaneDomain") },

  -- Navigation
  { key = "h",   mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j",   mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k",   mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l",   mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Right") },

  -- Resizing
  { key = "H",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
  { key = "J",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
  { key = "K",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
  { key = "L",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Right", 5 } },

  -- Tab Navigation (1-9)
  { key = "1",   mods = "LEADER",       action = wezterm.action.ActivateTab(0) },
  { key = "2",   mods = "LEADER",       action = wezterm.action.ActivateTab(1) },
  { key = "3",   mods = "LEADER",       action = wezterm.action.ActivateTab(2) },
  { key = "4",   mods = "LEADER",       action = wezterm.action.ActivateTab(3) },
  { key = "5",   mods = "LEADER",       action = wezterm.action.ActivateTab(4) },
  { key = "6",   mods = "LEADER",       action = wezterm.action.ActivateTab(5) },
  { key = "7",   mods = "LEADER",       action = wezterm.action.ActivateTab(6) },
  { key = "8",   mods = "LEADER",       action = wezterm.action.ActivateTab(7) },
  { key = "9",   mods = "LEADER",       action = wezterm.action.ActivateTab(8) },

  -- Closing
  { key = "&",   mods = "LEADER|SHIFT", action = wezterm.action.CloseCurrentTab { confirm = true } },
  { key = "d",   mods = "LEADER",       action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = "x",   mods = "LEADER",       action = wezterm.action.CloseCurrentPane { confirm = true } },
}

config.window_close_confirmation = 'AlwaysPrompt'

return config

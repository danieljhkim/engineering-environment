local wezterm = require("wezterm")

local config = {}

-- PERFORMANCE
config.max_fps = 120
config.animation_fps = 120
config.front_end = "WebGpu"

-- FONT
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.line_height = 1.0 

-- WINDOW
config.window_padding = {
  left = 8,
  right = 8,
  top = 6,
  bottom = 6,
}

config.window_background_opacity = 0.90
config.macos_window_background_blur = 10

-- SCROLLBACK
config.scrollback_lines = 50000

-- CURSOR
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600

-- COLOR SCHEME
config.color_scheme = "Catppuccin Mocha"

-- TAB BAR
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false

-- WINDOW BEHAVIOR
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = "NeverPrompt"


-- KEYBINDINGS
local act = wezterm.action

config.keys = {

  -- new tab
  {key="t", mods="CMD", action=act.SpawnTab("CurrentPaneDomain")},

  -- close tab
  {key="w", mods="CMD", action=act.CloseCurrentTab({confirm=false})},

  -- split panes
  {key="d", mods="CMD", action=act.SplitHorizontal({domain="CurrentPaneDomain"})},
  {key="D", mods="CMD|SHIFT", action=act.SplitVertical({domain="CurrentPaneDomain"})},

  -- pane navigation
  {key="h", mods="CMD|CTRL", action=act.ActivatePaneDirection("Left")},
  {key="l", mods="CMD|CTRL", action=act.ActivatePaneDirection("Right")},
  {key="k", mods="CMD|CTRL", action=act.ActivatePaneDirection("Up")},
  {key="j", mods="CMD|CTRL", action=act.ActivatePaneDirection("Down")},

  -- copy mode
  {key="c", mods="CMD|SHIFT", action=act.CopyTo("Clipboard")},
  {key="v", mods="CMD", action=act.PasteFrom("Clipboard")},

  -- quick launcher
  {key="p", mods="CMD", action=act.ActivateCommandPalette},

  -- search scrollback
  {key="f", mods="CMD", action=act.Search({CaseSensitiveString=""})},
}

-- LAUNCH MENU
config.launch_menu = {
  {
    label = "tmux",
    args = {"/opt/homebrew/bin/tmux", "new-session", "-A", "-s", "main"},
  },
  {
    label = "zsh",
    args = {"zsh"},
  },
}

-- DEFAULT PROGRAM
config.default_prog = {"zsh", "-l"}

return config

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

config.font=wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19


config.keys = {
  -- This will create a new split and run your default program inside it
  {
    key = ':',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- This will create a new split and run your default program inside it
  {
    key = '"',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Add a shortcut for closing the current pane
    {
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },
}

-- Disable copy-on-select: releasing the left button just finalizes the
-- selection without copying it to the clipboard.
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.ExtendSelectionToMouseCursor 'Cell',
  },
}

return config
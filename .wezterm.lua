local wezterm = require 'wezterm'
return {
  font = wezterm.font('Fira Code', {
                        weight = "DemiBold",
  }),
  keys = {
    {
      key = '@',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'n',
      mods = 'CMD',
      action = wezterm.action.SendKey { key = 'n', mods = 'OPT' },
    },
    {
      key = 'p',
      mods = 'CMD',
      action = wezterm.action.SendKey { key = 'p', mods = 'OPT' },
    },
    {
      key = 'DownArrow',
      mods = 'CMD',
      action = wezterm.action.SendKey { key = 'DownArrow', mods = 'OPT' },
    },
    {
      key = 'Backspace',
      mods = 'CMD',
      action = wezterm.action.SendKey { key = 'Backspace', mods = 'OPT' },
    },
    {
      key = 'Backspace',
      mods = 'CTRL',
      action = wezterm.action.SendKey { key = 'Backspace', mods = 'OPT' },
    }
  },
  font_size = 12.0,
  line_height = 1.0,
  default_cursor_style = 'SteadyUnderline',
  enable_scroll_bar = true,
  color_scheme = "iceberg-dark",
  window_background_opacity = 0.92,
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  initial_cols = 120,
  initial_rows = 40,
}

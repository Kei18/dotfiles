local wezterm = require 'wezterm'
return {
  font = wezterm.font('Fira Code', {
                        weight = "DemiBold",
  }),
  font_size = 12.0,
  line_height = 1.0,
  default_cursor_style = 'SteadyUnderline',
  enable_scroll_bar = true,
  color_scheme = "iceberg-dark",
  window_background_opacity = 0.92,
  hide_tab_bar_if_only_one_tab = true,
  initial_cols = 120,
  initial_rows = 40,
}

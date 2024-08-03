{gVar, ...}: let
  theme = gVar.palette;
in {
  programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font";
    font.size = 14;
    settings = {
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      window_padding_width = 9;
      confirm_os_window_close = 0;
      background = theme.base00;
      foreground = theme.base05;
      selection_background = "none";
      selection_foreground = "none";
      color0 = theme.base00;
      color1 = theme.base08;
      color2 = theme.base0B;
      color3 = theme.base0A;
      color4 = theme.base0D;
      color5 = theme.base0E;
      color6 = theme.base0C;
      color7 = theme.base05;
      color8 = theme.base03;
      color9 = theme.base08;
      color10 = theme.base0B;
      color11 = theme.base0A;
      color12 = theme.base0D;
      color13 = theme.base0E;
      color14 = theme.base0C;
      color15 = theme.base07;
    };
  };
}

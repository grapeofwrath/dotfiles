{...}: {
  programs.kitty = {
    enable = true;
    #font.name = "JetBrainsMono Nerd Font";
    #font.size = 12;
    #theme = "Glacier";
    settings = {
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      window_padding_width = 10;
      confirm_os_window_close = 0;
      #background_opacity = "1";
    };
  };
}

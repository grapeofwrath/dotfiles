{
  config,
  lib,
  campfire,
  ...
}: let
  cfg = config.terminal;
in {
  options.terminal = with lib; {
    fontSize = mkOption {
      type = types.int;
      default = 12;
    };
  };

  config = {
    programs = {
      kitty = {
        enable = true;
        enableGitIntegration = true;
        # extraConfig = "";
        font = {
          name = "Jetbrains Mono Nerd Font";
          size = cfg.fontSize;
        };
        settings = {
          enable_audio_bell = true;
          # bell_path = "";
          # linux_bell_theme = "";
          window_padding_width = 5;
          # theme
          foreground = campfire.text;
          background = campfire.base;
          background_opacity = 1;
          selection_foreground = "none";
          selection_background = "none";
          color0 = campfire.base;
          color1 = campfire.dusk;
          color2 = campfire.evergreen;
          color3 = campfire.ember;
          color4 = campfire.foam;
          color5 = campfire.fern;
          color6 = campfire.shore;
          color7 = campfire.text;
          color8 = campfire.subtle;
          color9 = campfire.dusk;
          color10 = campfire.evergreen;
          color11 = campfire.ember;
          color12 = campfire.foam;
          color13 = campfire.fern;
          color14 = campfire.shore;
          color15 = campfire.moon;
        };
        shellIntegration = {
          enableBashIntegration = true;
          enableFishIntegration = true;
        };
      };
    };
  };
}

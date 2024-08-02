{
  config,
  lib,
  gVar,
  ...
}: let
  cfg = config.base.zellij;
  theme = gVar.palette;
in {
  options.base.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };
  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        theme = "campfire";
        themes.campfire = {
          fg = theme.base05;
          bg = theme.base00;
          black = theme.base06;
          red = theme.base08;
          green = theme.base0B;
          yellow = theme.base0A;
          blue = theme.base0D;
          magenta = theme.base0E;
          cyan = theme.base0C;
          white = theme.base07;
          orange = theme.base09;
        };
      };
    };
  };
}

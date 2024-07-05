{
  config,
  lib,
  ...
}: let
  cfg = config.orion.zellij;
in {
  options.orion.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };
  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        theme = "campfire";
        themes.campfire = {
          fg = "#EFC164";
          bg = "#14171F";
          black = "#2A2F3C";
          red = "#A885C1";
          green = "#468966";
          yellow = "#F3835D";
          blue = "#70ADC2";
          magenta = "#67CC8E";
          cyan = "#3A8098";
          white = "#DDD7CA";
          orange = "#F35955";
        };
      };
    };
  };
}

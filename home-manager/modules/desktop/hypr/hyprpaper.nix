{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hyprpaper;
in {
  options.hyprpaper = {
    enable = mkEnableOption "Enable HyprPaper";
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [
          "/home/marcus/Pictures/wallpapers/carlos-williams.png"
        ];
        wallpaper = [
          ",/home/marcus/Pictures/wallpapers/carlos-williams.png"
        ];
      };
    };
  };
}

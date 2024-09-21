{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.hyprland;
in lib.mkIf cfg.enable {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload =
        [ "~/Pictures/wallpaper.png" ];
      wallpaper = [
        ",~/Pictures/wallpaper.png"
      ];
    };
  };
}

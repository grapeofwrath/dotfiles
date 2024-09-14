{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.hyprland;
in lib.mkIf cfg.enable {
  home.file."Pictures/wallpaper.png".source = ./../../../../assets/wallpaper.png;

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

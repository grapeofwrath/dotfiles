{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.hyprland;
in lib.mkIf cfg.enable {
  services = {
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };
}

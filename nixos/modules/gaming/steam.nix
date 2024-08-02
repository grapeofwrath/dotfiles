{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gaming.steam;
in {
  options.gaming.steam = {
    enable = lib.mkEnableOption "steam";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonup-qt
      mesa
      unzip
      xdotool
      xorg.xwininfo
      yad
    ];
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
      };
      gamescope.enable = true;
      gamemode.enable = true;
    };
  };
}

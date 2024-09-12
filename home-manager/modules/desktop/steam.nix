{
  config,
  lib,
  ...
}: with lib; let
  cfg = config.desktop.steam;
in {
  options.desktop.steam = {
    enable = mkEnableOption "To be enabled if NixOS steam module is enabled";
  };
  config = mkIf cfg.enable {
    home = {
      file.".steam/steam/steam_dev.cfg".source = ../../../assets/steam_dev.cfg;
    };
  };
}

{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.desktop.plasma;
in {
  options.orion.desktop.plasma = with types; {
    enable = mkBoolOpt false "Enable Plasma desktop environment with SDDM";
  };
  config = mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    services.xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
}

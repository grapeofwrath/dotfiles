{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gnome;
in {
  options.gnome = {
    enable = mkEnableOption "Enable Gnome Desktop Environment";
    # autoLogin = mkOption {
    #   type = types.bool;
    #   default = false;
    # };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-software
    ];
    services.xserver = {
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm = {
          enable = true;
        };
      };
    };
  };
}

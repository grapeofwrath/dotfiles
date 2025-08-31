{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hyprland;
in {
  options.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-software
      hyprpanel
    ];
    # nixpkgs = {
    #   overlays = [inputs.hyprpanel.overlay];
    # };

    programs.hyprland = {
      enable = true;
      withUWSM = false;
    };

    programs.uwsm.enable = false;

    nix.settings = {
      substituters = [
        "https://walker-git.cachix.org"
      ];
      trusted-public-keys = [
        "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
      ];
    };
  };
}

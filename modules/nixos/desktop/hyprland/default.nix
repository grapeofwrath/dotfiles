{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.desktop.hyprland;
in {
  options.orion.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable Hyprland session";
  };
  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}

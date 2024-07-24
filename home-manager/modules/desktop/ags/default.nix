{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktop.ags;
in {
  imports = [
    inputs.ags.homeManagerModules.default
    ./style.nix
  ];

  options.desktop.ags = {
    enable = lib.mkEnableOption "Enable AGS";
  };

  config = lib.mkIf cfg.enable {
    programs.ags = {
      enable = true;
      configDir = null;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
    xdg.configFile = {
      "ags" = {
        source = ../../../../assets/ags;
        recursive = true;
      };
    };
  };
}

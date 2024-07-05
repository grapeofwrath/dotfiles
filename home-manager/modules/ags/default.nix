{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.orion.hyprgalactic.ags;
in {
  imports = [inputs.ags.homeManagerModules.default];

  options.orion.hyprgalactic.ags = {
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
        source = ../../../assets/ags;
        recursive = true;
      };
    };
  };
}

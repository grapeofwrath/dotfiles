{
  config,
  lib,
  inputs,
  pkgs,
  campfire,
  ...
}:
with lib; let
  cfg = config.walker;
in {
  options.walker = {
    enable = mkEnableOption "Enable Walker";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      walker
    ];
    # imports = [inputs.walker.homeManagerModules.default];
    #
    # programs.walker = {
    #   enable = true;
    #   runAsService = true;
    #
    #   config = {
    #     ui.fullscreen = true;
    #     # app_launch_prefix = "uwsm app -- ";
    #   };
    #
    #   # style = ''
    #   #
    #   # '';
    # };
  };
}

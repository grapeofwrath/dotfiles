{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.base.fish;
in {
  options.base.fish = {
    enable = lib.mkEnableOption "Enable Fish Shell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      fish.enable = true;
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.orion.fish;
in {
  options.orion.fish = {
    enable = lib.mkEnableOption "Enable Fish Shell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      fish.enable = true;
    };
  };
}

{
  config,
  lib,
  ...
}: with lib; let
  cfg = config.base.fish;
in {
  options.base.fish = {
    enable = mkEnableOption "Enable Fish Shell";
  };

  config = mkIf cfg.enable {
    programs = {
      fish.enable = true;
    };
  };
}

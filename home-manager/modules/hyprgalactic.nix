{
  config,
  lib,
  ...
}: let
  cfg = config.orion.hyprgalactic;
in {
  options.orion.hyprgalactic = {
    enable = lib.mkEnableOption "Enable HyprGalactic Desktop Experience";
  };

  config =
    lib.mkIf cfg.enable {
    };
}

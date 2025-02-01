{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.immich;
in {
  options.immich = {
    enable = mkEnableOption "Enable Immich";
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
    };
  };
}

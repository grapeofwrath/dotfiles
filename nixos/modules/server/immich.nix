{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.immmich;
in {
  options.immmich = {
    enable = mkEnableOption "Enable Immich";
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
    };
  };
}

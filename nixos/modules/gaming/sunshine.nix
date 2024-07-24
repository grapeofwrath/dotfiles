{
  config,
  lib,
  ...
}: let
  cfg = config.gaming.sunshine;
in {
  options.gaming.sunshine = {
    enable = lib.mkEnableOption "Enable Sunshine streaming service";
  };
  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
    };
  };
}

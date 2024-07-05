{
  config,
  lib,
  ...
}: let
  cfg = config.orion.battery;
in {
  options.orion.battery = {
    enable = lib.mkEnableOption "Enable battery setup for laptops";
    intelCPU = lib.mkOption {
      description = "Whether or not the system has an intel cpu";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    services.system76-scheduler.settings.cfsProfiles.enable = true;
    powerManagement.powertop.enable = true;
    services.thermald.enable = lib.mkIf cfg.intelCPU true;
  };
}

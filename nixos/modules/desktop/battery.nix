{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.battery;
in {
  options.battery = {
    enable = mkEnableOption "Enable battery setup for laptops";
    intelCPU = mkOption {
      description = "Whether or not the system has an intel cpu";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services = {
      system76-scheduler.settings.cfsProfiles.enable = true;
      thermald.enable = mkIf cfg.intelCPU true;
      gvfs.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
    powerManagement.powertop.enable = true;
  };
}

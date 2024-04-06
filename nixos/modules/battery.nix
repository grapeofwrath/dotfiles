{config,lib,...}: with lib;
let cfg = config.orion.battery; in {
  options.orion.battery = {
    enable = mkEnableOption "Enable battery setup for laptops";
    intelCPU = mkOption {
      description = "Whether or not the system has an intel cpu";
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    services.system76-scheduler.settings.cfsProfiles.enable = true;
    powerManagement.powertop.enable = true;
    services.thermald.enable = mkIf cfg.intelCPU true;
  };
}

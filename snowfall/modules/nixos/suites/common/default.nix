{options,config,pkgs,lib,...}: with lib; with lib.orion;
let cfg = config.orion.suites.common; in {
  options.orion.suites.common = with types; {
    enable = mkBoolOpt false "Enable common configuration modules";
    bluetooth = mkBoolOpt false "Enable bluetooth support";
    systemdBoot = mkBoolOpt false "Enabled EFI boot";
  };
  config = mkIf cfg.enable {
    orion = {
      nix = enabled;
      hardware = {
        audio = enabled;
        bluetooth = mkIf cfg.bluetooth enabled;
        network = enabled;
      };
      system = {
        boot.efi = mkIf cfg.systemdBoot enabled;
        locale = enabled;
        time = enabled;
        vars = enabled;
        xkb = enabled;
      };
      services = {
        ssh = enabled;
      };
    };
  };
}

{config,lib,...}:
let cfg = config.orion.gaming.sunshine; in {
  options.orion.gaming.sunshine = {
    enable = lib.mkEnableOption "Enable Sunshine streaming service";
  };
  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
    };
  };
}

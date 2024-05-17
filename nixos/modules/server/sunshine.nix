{config,lib,...}:
let cfg = config.orion.server.sunshine; in {
  options.orion.server.sunshine = {
    enable = lib.mkEnableOption "Enable Sunshine streaming service";
  };
  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
    };
  };
}

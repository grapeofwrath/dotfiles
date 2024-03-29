{options,config,pkgs,lib,...}: with lib; with lib.orion;
let cfg = config.orion.system.time; in {
  options.orion.system.time = with types; {
    enable = mkBoolOpt false "Enable timezone";
  };
  config = mkIf cfg.enable {
    time.timeZone = "America/Chicago";
  };
}

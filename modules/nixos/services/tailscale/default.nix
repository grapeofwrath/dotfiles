{options,config,pkgs,lib,...}: with lib; with lib.orion;
let cfg = config.orion.tools.tailscale; in {
  options.orion.tools.tailscale = with types; {
    enable = mkBoolOpt false "Enable tailscale";
  };
  config = mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}

{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.tools.ssh;
in {
  options.orion.tools.ssh = with types; {
    enable = mkBoolOpt false "Enable ssh";
  };
  config = mkIf cfg.enable {
    programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}

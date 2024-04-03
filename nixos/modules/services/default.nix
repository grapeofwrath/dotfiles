{config,lib,...}: with lib;
let cfg = config.orion.nixos.services; in {
  options.orion.nixos.services = {
    tailscale.enable = mkEnableOption "tailscale";
  };
  config = {
    # TODO find correct way to auto add ssh keys
    # programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    services.tailscale.enable = mkIf cfg.tailscale.enable true;
  };
}

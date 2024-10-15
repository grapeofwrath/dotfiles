{
  config,
  pkgs,
  lib,
  gVar,
  ...
}: with lib;
let
  cfg = config.server.podman;
in {
  options.server.podman = {
    enable = mkEnableOption "Enable Podman";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yarn
    ];
    virtualisation = {
      docker.enable = true;
      # podman = {
      #   enable = true;
      #   autoPrune.enable = true;
      #   dockerCompat = true;
      #   defaultNetwork.settings = {
      #     # Required for container networking to be able to use names.
      #     dns_enabled = true;
      #   };
      # };
      # oci-containers.backend = "podman";
    };

    # Enable container name DNS for non-default Podman networks.
    # https://github.com/NixOS/nixpkgs/issues/226365
    # networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];
  };
}

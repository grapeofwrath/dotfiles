{
  config,
  lib,
  defaultUser,
  ...
}:
with lib; let
  cfg = config.podman;
in {
  options.podman = {
    enable = mkEnableOption "Enable Podman";
  };

  config = mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    users.users.${defaultUser} = {
      extraGroups = ["podman"];
    };
  };
}

{
  config,
  pkgs,
  defaultUser,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/base
    ./../modules/desktop
    ./../modules/users
    ./../modules/server
  ];

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    qemu_kvm
  ];

  users.users.${defaultUser} = {
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "docker"
      "podman"
      "nextcloud"
    ];
    # packages = with pkgs; [
    # ];
  };

  # Personal Modules
  tailscaleAutoConnect = {
    enable = true;
    authkeyFile = config.sops.secrets.tailscale_key.path;
    loginServer = "https://login.tailscale.com";
    exitNode = "grapecontrol";
    exitNodeAllowLanAccess = true;
  };

  plasma = {
    enable = true;
    autoLogin = true;
  };

  enteServer.enable = true;
  foundryVTT.enable = true;
  hoarder.enable = true;
  nextcloud.enable = false;

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.11";
}

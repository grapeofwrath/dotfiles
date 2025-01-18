{
  config,
  lib,
  defaultUser,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/base
    ./../modules/users
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.domain = "";
  system.stateVersion = "23.11";

  services = {
    caddy = {
      enable = true;
      virtualHosts."foundry.adventurerstome.com".extraConfig = ''
        reverse_proxy http://grapelab:30000
      '';
    };
    fail2ban.enable = true;
  };

  users.users.${defaultUser} = {
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  tailscaleAutoConnect = {
    enable = true;
    authkeyFile = config.sops.secrets.tailscale_key.path;
    loginServer = "https://login.tailscale.com";
    advertiseExitNode = true;
    exitNodeAllowLanAccess = true;
  };

  # auto-generated for DigitalOcean
  networking = {
    firewall = {
      allowedTCPPorts = [80 443 22];
    };
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "161.35.224.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "161.35.226.80";
            prefixLength = 20;
          }
          {
            address = "10.48.0.5";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::246b:50ff:fe33:fb6";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [
          {
            address = "161.35.224.1";
            prefixLength = 32;
          }
        ];
        ipv6.routes = [
          {
            address = "";
            prefixLength = 128;
          }
        ];
      };
      eth1 = {
        ipv4.addresses = [
          {
            address = "10.124.0.2";
            prefixLength = 20;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::40ea:bfff:fe65:58cb";
            prefixLength = 64;
          }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="26:6b:50:33:0f:b6", NAME="eth0"
    ATTR{address}=="42:ea:bf:65:58:cb", NAME="eth1"
  '';
}

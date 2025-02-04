{
  config,
  inputs,
  pkgs,
  lib,
  hostName,
  gLib,
  campfire,
  ...
}: {
  imports = (gLib.scanPaths ./.) ++ [inputs.sops-nix.nixosModules.sops];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = ["/etc/nix/path"];
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  sops = {
    defaultSopsFile = ./../../../secrets.yaml;
    validateSopsFiles = false;
    age = {
      # auto imports host SSH keys as age keys
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    # secrets are output to /run/secrets
    # ie /run/secrets/gitea_dbpass
    secrets = {
      nextcloud_admin = {
        group = "nextcloud";
      };
      tailscale_key = {
        group = "users";
      };
    };
  };

  environment = {
    etc =
      lib.mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      font-awesome
      polkit
      tree
      imagemagick
      curl
      wget
      unzip
      lazygit
    ];
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = ["v4l2loopback"];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  };

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  time.timeZone = lib.mkDefault "America/Los_Angeles";

  networking = {
    inherit hostName;
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
    };
  };

  console = let
    c = campfire;
    nh = h: lib.strings.removePrefix "#" h;
  in {
    colors = [
      (nh c.base)
      (nh c.dusk)
      (nh c.evergreen)
      (nh c.ember)
      (nh c.foam)
      (nh c.fern)
      (nh c.shore)
      (nh c.text)
      (nh c.subtle)
      (nh c.dusk)
      (nh c.evergreen)
      (nh c.ember)
      (nh c.foam)
      (nh c.fern)
      (nh c.shore)
      (nh c.moon)
    ];
    useXkbConfig = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
  ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    xserver = {
      xkb = {
        layout = lib.mkDefault "us";
        options = "caps:escape";
      };
    };
  };
}

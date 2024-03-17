{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.sops-nix.nixosModules.sops

    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";
  networking.hostName = "orion";
  networking.networkmanager.enable = true;

  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    nushell
    carapace
    vim
    neovim
    curl
    wget
    zoxide
    gnupg
    sops
    ssh-to-age
    age
    alejandra
    wineWowPackages.staging
    exercism
  ];

  programs.dconf.enable = true;
  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.tailscale.enable = true;
  #sops.defaultSopsFile = ./../../secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  #sops.age.keyFile = "/home/grape/.config/sops/age/keys.txt";
  #sops.secrets.grape = {};

  users.users = {
    grape = {
      isNormalUser = true;
      description = "Grape of Wrath";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.nushell;
    };
  };
  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    grape = {
      imports = [../home-manager];
      home = {
        username = "grape";
        homeDirectory = "/home/grape";
        stateVersion = "23.11";
      };
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
  };

  nix.settings = {
    builders-use-substitutes = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.chachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "on";
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };
}

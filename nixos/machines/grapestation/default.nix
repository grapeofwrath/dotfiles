{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: let
  hostName = "grapestation";
  nixConfDir = "~/Documents/dev/nix/orion";
  timeZone = "America/Chicago";
  defaultLocale = "en_US.UTF-8";
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.sops-nix.nixosModules.sops

    ./hardware-configuration.nix
    ../../modules
  ];

  networking = {inherit hostName;};
  networking.networkmanager.enable = true;

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

  time = {inherit timeZone;};
  i18n = {inherit defaultLocale;};

  environment.variables = {
    EDITOR = "nvim";
  };
  environment.shellAliases = {
    nvim = "nix run github:grapeofwrath/nixvim-flake";
    n = "nvim";
    rebuild = "sudo nixos-rebuild switch --flake ${nixConfDir}#${hostName}";
    update = "sudo nix flake update";
    ll = "ls -la";
    ".." = "cd ..";
    "dev go init" = "nix flake init --template github:grapeofwrath/dev-templates#let-it-go";
    "dev go new" = "nix flake new --template github:grapeofwrath/dev-templates#let-it-go";
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
    xkb.layout = "us";
    xkb.variant = "";
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };
  };
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    vim
    neovim
    curl
    wget
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
      #shell = pkgs.nushell;
    };
  };
  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    grape = {
      imports = [../../../home-manager/users/grape];
      home = {
        username = "grape";
        homeDirectory = "/home/grape";
        stateVersion = "23.11";
      };
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
  };

  # hyprland
  nix.settings = {
    builders-use-substitutes = true;
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}

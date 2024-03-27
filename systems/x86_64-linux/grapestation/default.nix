{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [./hardware-config.nix];

  nix.enable = true;
  hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    network = {
      enable = true;
      hostName = "grapestation";
    };
  };
  system = {
    boot.enable = true;
    locale.enable = true;
    time.enable = true;
    vars.enable = true;
    xkb.enable = true;
  };
  desktop = {
    hyprland.enable = true;
    plasma.enable = true;
  };
  tools = {
    appimage.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
  };
  user = {
    name = "grape";
    description = "Marcus Montgomery";
  };
  cli.shell.aliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/Documents/dev/nix/orion#${config.network.hostName}";
    update = "sudo nix flake update";
  };

  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    vim
    neovim
    curl
    wget
  ];

  programs.dconf.enable = true;
  #sops.defaultSopsFile = ./../../secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  #sops.age.keyFile = "/home/grape/.config/sops/age/keys.txt";
  #sops.secrets.grape = {};

  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    grape = {
      imports = [../../../home-manager/grape/${hostName}.nix];
      home = {
        username = "grape";
        homeDirectory = "/home/grape";
        stateVersion = "23.11";
      };
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
  };
}

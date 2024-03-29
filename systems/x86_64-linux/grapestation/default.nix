{config,pkgs,lib,inputs,outputs,...}: {
  imports = [./hardware-config.nix];

  orion = {
    hardware.network.hostName = "grapestation";
    suites = {
      common = {
        enable = true;
        bluetooth = true;
        systemdBoot = true;
      };
    };
    services = {
      tailscale.enable = true;
    };
    desktop = {
      hyprland.enable = true;
      plasma.enable = true;
    };
    tools = {
      appimage.enable = true;
    };
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
      imports = [../../../home-manager/grape/${config.networking.hostName}.nix];
      home = {
        username = "grape";
        homeDirectory = "/home/grape";
        stateVersion = "23.11";
      };
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "23.11";
}

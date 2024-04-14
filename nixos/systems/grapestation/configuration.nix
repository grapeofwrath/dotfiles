{inputs,config,lib,pkgs,...}: {
  imports = [
    ./hardware-config.nix
    ../../modules
  ];
  orion = {
    hardware = {
      bluetooth = true;
      hostName = "grapestation";
    };
    system.latestKernel = true;
    services.tailscale.enable = true;
    tools.appimage.enable = true;
    desktop = {
      hyprland.enable = true;
      plasma.enable = true;
    };
    apps = {
      steam.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    vim
    neovim
    curl
    wget
  ];

  #sops.defaultSopsFile = ./../../secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  #sops.age.keyFile = "/home/grape/.config/sops/age/keys.txt";
  #sops.secrets.grape = {};

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "23.11";
}

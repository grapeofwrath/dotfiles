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

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "23.11";
}

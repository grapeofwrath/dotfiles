{inputs,config,lib,pkgs,...}: {
  imports = [
    ./hardware-config.nix
    ../../modules
  ];
  orion = {
    interwebs = {
      hostName = "grapestation";
    };
    hardware = {
      bluetooth = true;
    };
    system.latestKernel = true;
    tailscale.enable = true;
    tools.appimage.enable = true;
    desktop = {
      auto-login.enable = false;
      hyprland.enable = true;
      plasma.enable = true;
    };
    gaming = {
      steam.enable = true;
      sunshine.enable = true;
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

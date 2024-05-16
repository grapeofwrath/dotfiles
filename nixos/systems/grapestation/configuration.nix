{inputs,config,lib,pkgs,...}: {
  imports = [
    ./hardware-config.nix
    ../../modules
  ];
  orion = {
    interwebs = {
      bluetooth = true;
      hostName = "grapestation";
    };
    system.latestKernel = true;
    tailscale.enable = true;
    tools.appimage.enable = true;
    desktop = {
      autoLogin = true;
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

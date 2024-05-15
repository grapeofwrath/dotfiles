{inputs,config,pkgs,lib,...}: {
  imports = [
    ./hardware-config.nix
    ../../modules
  ];
  orion = {
    battery = {
      enable = true;
      intelCPU = true;
    };
    interwebs = {
      hostName = "grapepad";
    };
    system.latestKernel = true;
    services.tailscale.enable = true;
    tools.appimage.enable = true;
    desktop = {
      auto-login.enable = false;
      hyprland.enable = true;
      plasma.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
  ];

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "23.11";
}

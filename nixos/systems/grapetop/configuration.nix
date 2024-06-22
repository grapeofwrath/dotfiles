{inputs,config,pkgs,lib,...}: {
  imports = [
    ./hardware-config.nix
    ../../modules
  ];
  orion = {
    battery = {
      enable = true;
    };
    interwebs = {
      hostName = "grapetop";
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
    };
  };
  #services.displayManager.sddm.theme = "${import ./sddm-theme.nix {inherit pkgs;}}";
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
  ];

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "23.11";
}

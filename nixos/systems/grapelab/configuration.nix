{pkgs, ...}: {
  imports = [
    ./hardware-config.nix
    ../../modules
  ];
  orion = {
    interwebs = {
      hostName = "grapelab";
    };
    system.latestKernel = true;
    tailscale.enable = true;
    tools.appimage.enable = true;
    # TODO
    # setup auto login
    desktop = {
      auto-login.enable = false;
      plasma = {
        enable = true;
        auto-login = true;
      };
    };
    server = {
      gitea.enable = true;
      minecraft.enable = false;
      nextcloud.enable = false;
      purpur.enable = false;
      savagecraft.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
  ];
  services.flatpak.enable = true;

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "23.11";
}

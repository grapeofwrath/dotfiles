{pkgs,...}: {
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
      auto-login.enable = true;
      plasma.enable = false;
    };
    server = {
      gitea.enable = true;
      minecraft.enable = true;
      nextcloud.enable = true;
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

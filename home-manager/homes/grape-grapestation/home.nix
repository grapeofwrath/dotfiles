{config,lib,pkgs,...}: {
  imports = [ ../../modules ];

  home = {
    username = "grape";
    homeDirectory = "/home/grape";
  };

  home.packages = with pkgs; [
    # desktop
    brave
    discord
    spotify
    element-desktop
    gnome.gnome-keyring
    kdePackages.qtstyleplugin-kvantum
    obs-studio
    filezilla
    # gaming
    wineWowPackages.staging
  ];

  # Disable when auto-login is off
  programs = {
    keychain = {
      enable = true;
      enableNushellIntegration = true;
      keys = [ "id_${config.home.username}-${config.orion.sops.hostName}" ];
    };
  };

  orion = {
    desktop = {
      hyprland = {
        enable = true;
      };
    };
    shell = {
      nushell.enable = true;
    };
    sops.hostName = "grapestation";
  };


  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}

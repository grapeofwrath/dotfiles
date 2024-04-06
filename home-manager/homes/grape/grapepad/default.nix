{pkgs,...}: {
  imports = [ ../../../modules ];

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
    # gaming
    wineWowPackages.staging
  ];

  #orion.shell.aliases = {
  #  da = "direnv allow";
  #};

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}

{lib,pkgs,...}: {
  imports = [ ../../../modules ];

  home = {
    username = "grape";
    homeDirectory = "/home/grape";
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
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
  home.stateVersion = "23.11";
}
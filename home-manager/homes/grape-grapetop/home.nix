{pkgs,...}: {
  imports = [../../modules];
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
    nh
    filezilla
    # charm
    vhs
    charm-freeze
    glow
    # gaming
    wineWowPackages.unstableFull
    moonlight-qt
    # custom
    jot
  ];
  orion = {
    desktop = {
      hyprland = {
        enable = true;
      };
    };
    shell = {
      nushell.enable = true;
    };
    sops.hostName = "grapetop";
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}

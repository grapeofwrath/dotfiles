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
    vhs
    charm-freeze
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
    sops.hostName = "grapepad";
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}

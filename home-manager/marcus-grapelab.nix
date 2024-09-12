{pkgs, ...}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];
  home.packages = with pkgs; [
    # desktop
    brave
    # discord
    vesktop
    spotify
    gnome-keyring
    kdePackages.qtstyleplugin-kvantum
    # charm
    vhs
    charm-freeze
    glow
    # gaming
    wineWowPackages.unstableFull
    moonlight-qt
  ];

  # Personal modules
  base = {
    dev.enable = true;
    fish.enable = true;
    nushell.enable = true;
    zellij.enable = true;
  };

  desktop = {
    ags.enable = false;
    hyprland.enable = false;
    waybar.enable = false;
  };
}

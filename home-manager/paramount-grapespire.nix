{pkgs, ...}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];
  home = {
    username = "paramount";
    packages = with pkgs; [
      # desktop
      brave
      discord
      spotify
      element-desktop
      gnome-keyring
      kdePackages.qtstyleplugin-kvantum
      filezilla
      # charm
      vhs
      charm-freeze
      glow
      # design
      blender
      # gaming
      wineWowPackages.unstableFull
      moonlight-qt
      # custom
      #jot
    ];
  };

  # Personal modules
  base = {
    dev.enable = true;
    fish.enable = true;
    nushell.enable = true;
    zellij.enable = true;
  };
  desktop = {
    hyprland.enable = true;
  };
}

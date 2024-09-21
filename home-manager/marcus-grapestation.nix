{
  pkgs,
  ...
}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];
  home = {
    username = "marcus";
    packages = with pkgs; [
      # desktop
      brave
      # discord
      vesktop
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
      lutris
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
    hyprland.enable = false;
    steam.enable = true;
  };
}

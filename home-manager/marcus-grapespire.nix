{pkgs, ...}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];
  home = {
    username = "marcus";
    packages = with pkgs; [
      # desktop
      element-desktop
      kdePackages.qtstyleplugin-kvantum
      # design
      blender
      # gaming
      wineWowPackages.unstableFull
      moonlight-qt
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
    steam.enable = true;
  };
}

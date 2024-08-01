{
  pkgs,
  host,
  username,
  ...
}: {
  imports = [
    ../modules/base
    ../modules/desktop
  ];
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
  home.packages = with pkgs; [
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
  programs = {
    keychain = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      keys = ["id_${username}-${host}"];
    };
  };

  # Personal modules
  base = {
    dev.enable = true;
    fish.enable = true;
    nushell.enable = true;
    zellij.enable = true;
  };
  desktop = {
    ags.enable = true;
    hyprland.enable = true;
    waybar.enable = true;
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "24.05";
}

{
  pkgs,
  host,
  gVar,
  ...
}: {
  imports = [
    ../modules/base
    ../modules/desktop
  ];
  # TODO
  # move to module
  home = {
    username = gVar.username;
    homeDirectory = "/home/${gVar.username}";
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
  # TODO
  # move to module
  programs = {
    keychain = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      keys = ["id_${gVar.username}-${host}"];
      extraFlags = ["--quiet"];
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

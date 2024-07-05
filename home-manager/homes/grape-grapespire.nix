{
  config,
  pkgs,
  ...
}: {
  imports = [../modules];
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
    #jot
  ];
  programs = {
    keychain = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      keys = ["id_${config.home.username}-${config.orion.sops.hostName}"];
    };
  };
  orion = {
    dev.enable = true;
    shell.fish.enable = true;
    zellij.enable = true;
    nushell.enable = true;

    hyprgalactic = {
      ags.enable = true;
      hyprland.enable = true;
      waybar.enable = true;
    };

    sops.hostName = "grapespire";
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "24.05";
}

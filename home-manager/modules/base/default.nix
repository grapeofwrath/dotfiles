{pkgs,...}: {
  systemd.user.startServices = "sd-switch";
  home.packages = with pkgs; [
    # Packages that don't have custom configs go here

    # cli
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    font-awesome
    tree
    exercism

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
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
  };
}

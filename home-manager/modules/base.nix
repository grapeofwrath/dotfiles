{pkgs,...}: {
  systemd.user.startServices = "sd-switch";
  home.packages = [
    # cli
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "CascadiaCode"
      ];
    })
    pkgs.font-awesome
    pkgs.polkit
    pkgs.tree
  ];
  programs = {
    home-manager.enable = true;
  };
}

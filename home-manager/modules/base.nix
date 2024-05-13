{pkgs,...}: {
  systemd.user.startServices = "sd-switch";
  home.packages = [
    # cli
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    pkgs.font-awesome
    pkgs.polkit
    pkgs.tree
    pkgs.zellij
  ];
  programs = {
    home-manager.enable = true;
  };
}

{pkgs,...}: {
  systemd.user.startServices = "sd-switch";
  home.packages = with pkgs; [
    # cli
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    font-awesome
    tree
    zellij
  ];
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
  };
}

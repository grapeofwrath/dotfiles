{pkgs,...}: {
  systemd.user.startServices = "sd-switch";
  home.packages = with pkgs; [
    # cli
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    font-awesome
    tree
    exercism
  ];
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
  };
}

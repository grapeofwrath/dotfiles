{pkgs,username, ...}: {
  systemd.user.startServices = "sd-switch";
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = [
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
    # Believe it or not, if you change this? Straight to jail.
    stateVersion = "24.05";
  };
  programs = {
    home-manager.enable = true;
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
}

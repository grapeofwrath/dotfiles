{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ../modules
  ];
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
  ];
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
  };
  programs.git = {
    enable = true;
    userName = "grapeofwrath";
    userEmail = "69535018+grapeofwrath@users.noreply.github.com";
    extraConfig = {
      url."ssh://git@github.com" = {
        insteadOf = "https://github.com";
      };
      init.defaultBranch = "main";
    };
  };
}

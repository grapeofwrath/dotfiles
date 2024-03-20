{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ../../modules
  ];
  systemd.user.startServices = "sd-switch";
  home.packages = with pkgs; [
    # Packages that don't have custom configs go here

    # cli
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    font-awesome
    fzf
    tree
    ripgrep
    exercism
    sops
    ssh-to-age
    age

    # desktop
    brave
    discord
    spotify
    element-desktop
    gnome.gnome-keyring

    # gaming
    wineWowPackages.staging
  ];
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
  };
  programs.git = {
    enable = true;
    userName = "grapeofwrath";
    userEmail = "grapeofwrath@noreply.gitea.com";
    extraConfig = {
      url."ssh://git@gitea.com" = {
        insteadOf = "https://gitea.com";
      };
      init.defaultBranch = "main";
    };
  };
}

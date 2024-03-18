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
    # cli
    git
    zoxide
    starship
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    font-awesome
    direnv
    fzf
    tree
    ripgrep
    alejandra
    exercism
    zoxide
    sops
    ssh-to-age
    age
    # desktop
    kitty
    brave
    discord
    spotify
    element-desktop
    # gaming
    brave
    discord
    spotify
    element-desktop
    wineWowPackages.staging
  ];
  programs = {
    home-manager.enable = true;
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

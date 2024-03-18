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
    git
    nushell
    kitty
    brave
    carapace
    zoxide
    starship
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    font-awesome
    direnv
    fzf
    tree
    discord
    ripgrep
    spotify
    element-desktop
  ];
  programs = {
    home-manager.enable = true;
    zoxide.enable = true;
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
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

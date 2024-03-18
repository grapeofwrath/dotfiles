{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
  };
}

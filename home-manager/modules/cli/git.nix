{...}:{
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

{...}: {
  programs.nixvim = {
    plugins.zellij = {
      enable = true;
    };
  };
}

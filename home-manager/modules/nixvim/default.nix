{inputs,config,pkgs,lib,...}: {
  #imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
}

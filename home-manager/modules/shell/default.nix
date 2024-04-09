{config,osConfig,lib,...}: with lib;
let cfg = config.orion.shell; in {
  #options.orion.shell = {
  #  aliases = mkOption {
  #    description = "Shell aliases available accross all shells";
  #    type = with types; attrsOf str;
  #  };
  #};
  config = {
    home.shellAliases = {
      grep = "rg";
      nvim = "nix run github:grapeofwrath/nixvim-flake";
      n = "nvim";
      ll = "ls -alF";
      ".." = "cd ..";
      tree = "tree --dirsfirst -F";
      mkdir = "mkdir -pv";
      # nix
      #update = "sudo nix flake update";
      da = "direnv allow";
    };
    #} ++ cfg.aliases;
    programs = {
      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };
      fzf.enable = true;
      ripgrep.enable = true;
      btop = {
        enable = true;
        #settings = {
        #  color_theme = "Default";
        #  theme_background = false;
        #};
      };
    };
  };
}

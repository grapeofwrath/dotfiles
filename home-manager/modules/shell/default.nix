{libgrape,config,lib,...}: with lib;
let cfg = config.orion.home-manager.shell; in {
  imports = libgrape.allSubdirs ./.;
  options.orion.home-manager.shell = with types; {
    aliases = mkOption {
      description = "Shell aliases available accross all shells";
      type = types.attrsOf str;
    };
  };
  config = {
    home.shellAliases = {
      grep = "rg";
      nvim = "nix run github:grapeofwrath/nixvim-flake";
      n = "nvim";
      ll = "ls -alF";
      ".." = "cd ..";
      tree = "tree --dirsfirst -F";
      mkdir = "mkdir -pv";
      rebuild = "sudo nixos-rebuild switch --flake .#${config.networking.hostName}";
      update = "sudo nix flake update";
    } ++ cfg.aliases;
    programs = {
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
      ripgrep.enable = true;
      btop = {
        enable = true;
        settings = {
          color_theme = "Default";
          theme_background = false;
        };
      };
    };
  };
}

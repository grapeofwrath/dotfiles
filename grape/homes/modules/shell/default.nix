{libgrape,config,lib,...}: with lib;
let cfg = config.orion.shell; in {
  imports = libgrape.allSubdirs ./.;
  options.orion.shell = with types; {
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
  };
}

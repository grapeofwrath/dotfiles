{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.cli.shell;
in {
  options.orion.cli.shell = with types; {
    aliases = mkOpt attrs {} "Shell aliases available system wide";
  };
  config = {
    environment.shellAliases = {
      grep = "rg";
      nvim = "nix run github:grapeofwrath/nixvim-flake";
      n = "nvim";
      ll = "ls -alF";
      ".." = "cd ..";
      tree = "tree --dirsfirst -F";
      mkdir = "mkdir -pv";
      rebuild = "sudo nixos-rebuild switch --flake ~/Documents/dev/nix/orion#${config.networking.hostName}";
      update = "sudo nix flake update";
    } ++ cfg.aliases;
  };
}

{ osConfig, ... }:
let
  # want to switch this as inherited from main conf
  nixConfDir = "~/Documents/dev/nix/orion";
in {
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        function dfinit() {
          nix flake init --template github:grapeofwrath/dev-templates#"$1"
        }
        function dfnew() {
          nix flake new --template github:grapeofwrath/dev-templates#"$1" "$2"
        }
      '';
      historyControl = [ "ignoredups" ];
      historyIgnore = [
        "ls"
        "ll"
        "cd"
        "z"
        ".."
        "exit"
      ];
      shellAliases = {
        # nix
        rebuild = "sudo nixos-rebuild switch --flake ${nixConfDir}#${osConfig.networking.hostName}";
        update = "sudo nix flake update";
      };
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
    ripgrep.enable = true;
  };
}

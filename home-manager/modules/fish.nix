{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.orion.shell.fish;
in {
  options.orion.shell.fish = {
    enable = lib.mkEnableOption "Enable Fish Shell";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';
        functions = {
          "home" = {
            body = "home-manager switch --flake .#$argv";
          };
          "flake" = {
            body = "sudo nixos-rebuild $argv[1] --flake $argv[2]";
          };
        };
        shellAliases = {
          n = "nvim";
          da = "direnv allow";
          ".." = "cd ..";
          taildrop = "sudo tailscale file get .";
        };
      };
      bash = {
        initExtra = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
    };
  };
}

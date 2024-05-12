{config,lib,...}:
let cfg = config.orion.shell.bash; in {
  options.orion.shell.bash = {
    #aliases = mkOption {
    #  type = types.attrsOf types.str;
    #  default = {};
    #};
  };
  config = {
    programs.bash = {
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
        grep = "rg";
        #nvim = "nix run github:grapeofwrath/nixvim-flake";
        n = "nvim";
        ll = "ls -alF";
        #".." = "cd ..";
        tree = "tree --dirsfirst -F";
        mkdir = "mkdir -pv";
        # nix
        #update = "sudo nix flake update";
        da = "direnv allow";
      };
    };
  };
}

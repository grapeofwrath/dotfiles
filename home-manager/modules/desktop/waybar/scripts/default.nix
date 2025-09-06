{
  pkgs,
  lib,
  ...
}: let
  scanDir = path: (builtins.attrNames
    (lib.attrsets.filterAttrs
      (
        path: _type:
          (_type == "directory") || (path != "default.nix")
      ) (builtins.readDir path)));
  scriptNames = scanDir ./.;
  scripts = builtins.listToAttrs (map (script: let
      src = builtins.readFile ./${script}.sh;
    in {
      name = script;
      value = pkgs.writeScriptBin script src;
    })
    scriptNames);
in
  scripts
  // {
    home.packages = scriptNames;
  }

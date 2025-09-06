{
  pkgs,
  lib,
  defaultUser,
  ...
}: let
  # scanDir = path: (builtins.attrNames
  #   (lib.attrsets.filterAttrs
  #     (
  #       path: _type:
  #         (_type == "directory") || (path != "default.nix")
  #     ) (builtins.readDir path)));
  # scriptNames = map (n: lib.strings.removeSuffix ".sh" n) (scanDir ./.);
  # scripts = builtins.listToAttrs (map (script: let
  #     src = builtins.readFile ./${script}.sh;
  #   in {
  #     name = script;
  #     value = pkgs.writeScriptBin script src;
  #   })
  #   scriptNames);
  gScript = name: pkgs.writeScriptBin name (builtins.readFile ./${name}.sh);

  gscript_backlight = gScript "gscript_backlight";
  gscript_battery-state = gScript "gscript_battery-state";
  gscript_bluetooth = gScript "gscript_bluetooth";
  gscript_network = gScript "gscript_network";
  gscript_power-menu = gScript "gscript_power-menu";
  gscript_wireplumber = gScript "gscript_wireplumber";
in {
  # environment.systemPackages = map (n: "pkgs." + n) (builtins.attrNames scripts);
  environment.systemPackages = with pkgs; [
    gscript_backlight
    gscript_battery-state
    gscript_bluetooth
    gscript_network
    gscript_power-menu
    gscript_wireplumber
  ];
}

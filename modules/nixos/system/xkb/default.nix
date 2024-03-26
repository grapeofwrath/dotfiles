{ options, config, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.system.xkb;
in {
  options.orion.system.xkb = with types; {
    enable = mkBoolOpt false "Configure xkb";
  };
  config = mkIf cfg.enable {
    console.useXkbConfig = true;
    services.xserver = {
      layout = "us";
      xkb.options = "caps:escape";
    };
  };
}

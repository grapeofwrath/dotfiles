{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.hardware.bluetooth;
in {
  options.orion.hardware.bluetooth = with types; {
    enable = mkBoolOpt false "Enable bluetooth support";
  };
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    # not sure if this is necessary, maybe just with hyprland?
    # adds secondary bluetooth systray icon on plasma
    #services.blueman.enable = true;
  };
}

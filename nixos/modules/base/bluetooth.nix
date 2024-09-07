{
  config,
  lib,
  ...
}: let
  cfg = config.base.bluetooth;
in {
  options.base.bluetooth = {
    enable = lib.mkEnableOption "Enable Bluetooth";
  };
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    # not sure if this is necessary, maybe just with hyprland?
    # adds secondary bluetooth systray icon on plasma
    #services.blueman.enable = mkIf cfg.bluetooth.enable true;
  };
}

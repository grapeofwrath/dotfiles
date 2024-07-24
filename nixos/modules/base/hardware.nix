{
  config,
  lib,
  ...
}: let
  cfg = config.base.hardware;
in {
  options.base.hardware = {
    # TODO
    # separate bluetooth into its own module
    bluetooth = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    hardware.bluetooth = lib.mkIf cfg.bluetooth {
      enable = true;
      powerOnBoot = true;
    };
    # not sure if this is necessary, maybe just with hyprland?
    # adds secondary bluetooth systray icon on plasma
    #services.blueman.enable = mkIf cfg.bluetooth.enable true;
  };
}

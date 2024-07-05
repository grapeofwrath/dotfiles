{
  config,
  lib,
  ...
}: let
  cfg = config.orion.desktop.auto-login;
in {
  options.orion.desktop.auto-login = {
    enable = lib.mkEnableOption "auto-login";
  };
  config = lib.mkIf cfg.enable {
    services = {
      getty.autologinUser = "grape";
      xserver = {
        displayManager.startx.enable = true;
      };
    };
  };
}

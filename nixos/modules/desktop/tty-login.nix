{
  config,
  lib,
  gVar,
  ...
}: let
  cfg = config.desktop.tty-login;
in {
  options.desktop.tty-login = {
    enable = lib.mkEnableOption "tty-login";
  };
  config = lib.mkIf cfg.enable {
    services = {
      # getty.autologinUser = gVar.username;
      xserver = {
        displayManager.startx.enable = true;
      };
    };
  };
}
